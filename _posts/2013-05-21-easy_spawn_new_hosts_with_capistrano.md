---
layout: post
title: Build new hosts with Capistrano and Chef
# series: 
# github_project: 
# gh_pages:
#
# include_toc: false
#
# Make TOC floating or plain: left or right
float_toc: right
#
# What headers to include in TOC: not they must be double and single quoted
# toc_headers: "'h1,h2,h3'"
tags:
  - ruby
  - chef
  - capistrano
  - deployment
  - installation
  - development
  - environment
published: true
summary: |
  Include Chef recipes into Capistrano deploy script, and create full-blown application servers from scratch in a minutes
description: |
  I was using Chef-solo to configure new hosts before they can be used to deploy applications by Capistrano. But Capistrano is not just for the app deployment!
  
---
<em>{{ page.summary }}. <p> {{ page.description }}.</em>

# Call Chef from Capistrano
Capistrano is capable of executing batches of commands in parallel on multiple remote servers, and its only dependency is SSH access.  So, why not use this to spawn chef-solo processes on these servers?

So, easy solution is to simply include your Chef-solo repository/scripts as a first step in the Capistrano deployment process. This way each time you do a deployment Chef will take care about configuring your server first. And if your server is not configured, or even just recently built, all necessary components will be magically deployed with simply typing `cap deploy`.

## Capistrano Recipe

Add this simple recipe to capistrano to make sure that Chef solo is started before any other Capistrano tasks:

{% highlight ruby %}
set_default :chef_solo_path, File.expand_path("../chef-solo/", File.dirname(__FILE__))
set_default :chef_solo_json, "empty.json"

namespace :chefsolo do 
  task :deploy do
    temp = %x{ mktemp /tmp/captemp-tar.XXXX }.chomp

    run_locally "cd #{chef_solo_path} && tar cfz #{temp} . "
    upload( temp, temp, :via => :scp)
    run_locally "rm -f #{temp}"

    run "mkdir -p ~/chef && cd ~/chef && tar xfz #{temp} && rm -f #{temp}"    
    run "#{try_sudo} cd ~/chef && bash ./install.sh #{chef_solo_json}"
  end
  before "deploy", "chefsolo:deploy"
end
{% endhighlight %}

Just make sure that your `chef-solo` repository is installed in the `./deploy/chef-solo` directory or set `:chef_solo_path` attribute accordingly.

Full text of Chef-solo Capistrano recipe is available in [the repository](https://github.com/dmytro/capistrano-recipes) in `chef_solo.rb` file. 

# Chef-solo Repository


This is [Chef-solo repository](https://github.com/dmytro/chef-solo) that I am using for my deployments. I forked it from somebody else, but heavily modified to suit my needs. Currently install script supports deployment/bootstrapping to MacOSX and several Linux distros. Among supported Linuxes are Debian/Ubuntu and RedHat/CentOS. Wan not tested with Fedora (maybe needs some adjustments for the Rpmforge).

## Server Bootsrapping

Even if you do not need to install any additional software using Chef-solo, you still need to put some prerequisits on the server. Like Ruby for Rails development - is an abvious example. 

Chef-solo install script can do just that. Without any cookbooks, it would simply create development or production environment by installing: prerequisite development environment (development RPM's or DEB's), Ruby version manager - RVM, Ruby itself and Chef (in that order). 

For this simply set `:chef_solo_json` attribute to `"empty.json"` as in the example above. `"empty.json"` is exactly what it says it's an JSON file that does not contain any recipes.


<!--  LocalWords:  capistrano dirname chefsolo mktemp cd cfz scp mkdir xfz
 -->
<!--  LocalWords:  endhighlight
 -->
