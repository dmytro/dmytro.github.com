---
layout: post
title: und Capiche
# series: 
# github_project: 
# gh_pages:
#
# include_toc: false
#
# Make TOC floating or plain: left or right
# float_toc: right
#
# What headers to include in TOC: not they must be double and single quoted
# toc_headers: "'h1,h2,h3'"
tags:
  - capistrano
  - chef
  - ruby
  - deployment
  - configuration
  - development
published: true
summary: |
  Capistrano is primarily used as web application deployment framework. It is excellent combination of remote parallel execution of SSH commands with work-flow management. Chef, on the other side, is designed as configuration management tool and mostly used to configure infrastructure.
description: |
  Is it possible to combine powers of Capistrano and Chef for simpler and faster deployments, with simplified configuration? Can I deploy infra and application in a single step?
  
---

# What is it? #

<em>{{ page.summary }} {{ page.description }}</em>

I've made several attempts to combine powers of Chef and Capistrano: [aws_deploy](https://github.com/dmytro/aws_deploy), [chef-solo](https://github.com/dmytro/chef-solo), [capistrano-recipes](https://github.com/dmytro/capistrano-recipes). This is a start for the new project.

# Application Centric Architectures

In the old days deploying a server took longer. Rack it: optimistically - one day (if you're lucky, you could reuse somebody else's retired box); you (or your SA's) install OS on it - another day (with all the approvals and manual configs). In extreme cases (not a joke!) deploying a server took me 5 to 6 months.

Application design was largely influenced or dictated by infrastructure architecture. Not only because of the price of the hardware, but also because of the difficulties with the deployment, multiple applications were sharing single server: *"Our existing DB server has a lot of RAM and disks, we will put every possible database on it. When we run out, we will add disks and memory or migrate box to larger hardware or we build a cluster."*

These days architecture of the infrastructure is rather influenced by the application environment. Each application can have distinct architecture, different from any other application or even dynamically changing architecture, depending on the needs. Since deploy of a new server can take less than a minute, they are created when required, and there is no need to share.

## Management ##

Dynamics of the environment makes administration of the architecture easier and more difficult at the same time.

Easier, because of the one function per server approach. We can decommission (or upgrade) server and be sure that it did not serve any additional tasks that we are not aware of. For exactly the same reason shorter life-time of the server(s) is better.

On the other side, management is a bit more difficult, because of higher number of servers that you need to manage. But this is where devops tools can really help.

# What is my goal for this project? #

I want to build servers from scratch. If not from bare metal, then at least from 'bare OS installation'. Not just servers, but 'architectures' - tailored for applications. Servers organized into logical groups, with application functioning at the end of single step deployment.

**I want to:**

- have a list of hosts or IP's;
- an SSH key(s);
- `Sudo` or `su` access;
- define server role(s), like `:app` (Note: I am following Ruby and Capistrano conventions here), `:monitoring`, `:logger`;
- run deployment;
- have running application on newly deployed server(s) is XX minutes;

**I want to avoid:**

- This should be easy to configure for end user, avoid writing extensive configuration for each new application or *'architecture'*: just hostnames and roles.
- Additionally, I want to be independent from any specifics of cloud or non-cloud provider.
- Similarly, I wish avoid building custom configuration and deployment management infrastructure (such as Chef or Puppet servers). My idea is to bring my laptop to you, plug it in (or let you git clone configuration repository), and by running single command have *your* application deployed in minutes (or, let's say dozens of minutes).

Yes, there are drawbacks. Configuring lists of hostnames or IP addresses in files is not scalable in the long run -- for large-scale applications or for multiple applications, for hundreds of hosts. One step at a time...

## Chef and Capistrano ##

I had made several approaches trying to make Cap and Chef work together.

First attempt was a project called [aws_deploy](...). Simply speaking it is a Ruby wrapper around AWS API, Chef-solo and Capistrano. Goal of the project was to have a single step deployment of application server in EC2 environment. AWS deploy is able to spawn new AWS instance if it does not exist, bootstrap it and install required git branch of RoR application.

Although this project simplified deployment process a bit, shortcomings of the AWS Deploy design are obvious:

- AWS Deploy is able to deploy only single instance at a time;
- chef-solo is not really configurable and only delivers standard static configuration server prepared to run Ruby on Rails;
- there is no interaction between Capistrano and Chef, they simply executed one after another by script wrapper.

# Cap + Chef = Capiche #

Capistrano recipes often have some kind of installation task. Before deploying a configuration, you have to install the package. Such recipes are usually similar to the example below:

{% highlight ruby %}
namespace :nginx do
    task :install do
        sudo "apt-get install -y nginx"
    end
end
{% endhighlight %}

There's an obvious problem with the recipe: it is not portable. This will work only on Debian or Ubuntu, and even on these systems there cases when this is not enough: what if I want different version of Nginx, or if I want to compile it from source with some custom configuration.

At the same time Chef is designed to handle such situations, and have all necessary DSL for it.

Is it possible to change Capistrano recipe like one above and make it use Chef cookbook instead?

This is exactly what I am trying to achieve with the new project I am calling **Unified Deployment with Capistrano and Chef** or *'und Capiche'* (AKA *Capiche*) for short.

The new project is not really new, it's rather a combination of the efforts from previous similar projects. Some things is already implemented and working, as I write this. But functionality and code are spread across multiple repositories and it's not easy even for myself to join pieces together to design deployment for new project.

## Components ##

Current *Capiche* setup is based on RVM, Capistrano `2.x`, Chef-solo and Capistrano [multi-configuration extension](https://github.com/railsware/capistrano-multiconfig).

## Current state ##

Below is an example of how configuration file for an application. This is actual working setup.

{% highlight ruby %}
server '10.0.1.10',  :app, :web, :db, :admin, hostname: "mysql01", primary: true
server '10.0.1.11',  :app, :web,              hostname: "web01"
server '10.0.1.12',  :app, :web,              hostname: "web02"

server '10.0.1.13', :logger, :dns, :security, :monitoring, no_release: true, hostname: "master"
{% endhighlight %}

* `:app`, `:web` and `:db` are standard Capistrano roles for Rails application,
* additional roles present here are `:admin`, `:logger`, `:security`, and `:monitoring` - new roles can be defined as necessary.
* Similarly `:primary` and `:no_release` are standard Capistrano host options, but
* `:hostname` is custom option used to set target host hostname and DNS.

Capistrano roles one-to-one correspond to roles on Chef side. This allows skip additional configuration.

Each Chef JSON role is simply a pointer to a more details role Ruby file. JSON roles look similar to:

{% highlight javascript %}
// app.json
{ "run_list" : ["role[rails_common]", "role[common]"] }

// logger.json
{ "run_list" : ["role[logger]"] }

// mysql.json
{ "run_list" : ["role[mysql]", "role[common]"] }

// web.json
{ "run_list" : ["role[web]", "role[common]"] }
{% endhighlight %}

Example of Ruby role file:


{% highlight ruby %}
name "common"
description "Components required on every node"

run_list [
    "recipe[user::databag]",
    "recipe[deep_security]",
    "recipe[rsyslog]",
    "recipe[chef-solo-search]",
    "recipe[yum::epel]",
    "recipe[yum::remi]",
    "role[monitoring_client]",
    "recipe[git]"
]

  default_attributes user: { :data_bag_name => :users }
{% endhighlight %}


## Scope ##

It is important to understand, that main target of this kind of setup is small to medium sort of applications -- tens of servers, rather than hundreds or thousands. But, at the same time, there are thousands of such applications, therefore ease of configuration and adaptability to the environment of next application is a key.

## Project home ##

There is no code now in Github repo, as I write this, I only created new repo few minutes ago, but I am starting moving bits and pieces from other places. Watch [this space](https://github.com/dmytro/und_capiche).




<!--  LocalWords:  und Capiche SA Centric decommission devops SA's configs db admin mysql dns rsyslog repo
 -->
 
