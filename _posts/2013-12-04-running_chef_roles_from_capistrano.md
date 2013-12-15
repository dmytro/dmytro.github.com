---
layout: post
title: Running Chef roles from Capistrano
# series: 
github_project: und_capiche
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
  - deployment
  - ruby
  - configuration
  - development
published: true
summary: |
  Chef databags are used to pass information between sessions of Capistrano and Chef.
description: |
  Databags are generated on Capistrano side and then used by Chef for server and components configuration.
  
---

<em>{{ page.summary }} {{ page.description }}</em>

In my new project [*und Capiche*](/2013/11/01/chef_and_capistrano_integration.html) I use tandem of Capistrano (or *cap*) and Chef-solo (*chef*) to deploy stacks of applications. Stacks are collections of server configuration, software packages required to run application, software configuration, and application code itself.

# Capistrano + Chef #

Here's a brief flow of typical deployment process in this schema:

- locally capistrano creates configuration to be used in Chef;
- *cap* copies Chef-solo and configuration to all remote hosts;
- *cap* starts chef-solo on remote hosts;
- after *chef* finished, *cap* starts standard application deployment.

## Databag messenger ##

There are significant differences in how *cap* and *chef* executed. First and main difference is that they are invoked on different servers. *Cap* starts deployment from local server, but *chef* processes (possibly many of them) run on remote servers in parallel.

There are no standard ways (like calling method and passing arguments) for information exchange between *cap* and *chef*. I use *chef databags* as information medium between *cap* and *chef*.

Capistrano needs an ability to generate databags from its own configuration in the format that *chef* cookbooks understand; also capistrano should be able to read and search *chef* databags.

### Hosts (AKA nodes) databag ###

First and very important task, is to be able to pass server configuration -- including roles -- from local Capistrano process to the remote nodes, where *chef* can use it. Example below shows how this could be implemented.

Suppose you have hosts configuration like the following:

{% highlight ruby %}
server '10.0.1.10',  :app, :web, :db, :admin, hostname: "mysql01", primary: true
server '10.0.1.11',  :app, :web,              hostname: "web01"
server '10.0.1.12',  :app, :web,              hostname: "web02"
server '10.0.1.13', :logger, :dns, :security, :monitoring, no_release: true, hostname: "master"
{% endhighlight %}

From this configuration Capistrano recipe creates databag called `:node` with one item for each capistrano host. Example of a recipe:

{% highlight ruby %}
task :roles do
    find_servers.each do |server|
        File.open("#{dir}/#{server}.json", "w") do |f|
            f.print({
                id:        server.host.gsub(/\./,'_'),
                role:      role_names_for_host(server),
                fqdn:      server.options[:hostname] || server.host, 
                ipaddress: server.host,
                options:   server.options
            }.to_json)
            f.close
        end
    end
end
{% endhighlight %}

Generated databag for one of the host looks like:

{% highlight javascript %}
{
    "id"        : "10_0_1_11",
    "role"      : ["logger", "dns", "security", "monitoring"],
    "fqdn"      : "10.0.1.11",
    "ipdaress"   : "10.0.1.11",
     "options" : {
         "no_release"    : "true",
         "hostname"      : "master"
    }
}
{% endhighlight %}

This databag can be used directly with *chef* recipes, using `data_bag_item` or `search` methods as for example:

{% highlight ruby %}
servers    = search(:node, '*')
monitoring = search(:node, "roles:*monitoring*")
{% endhighlight %}

> **Note**: There is one trick though. Recipe needs to be written in such a way as to support search in *Chef-solo*.

> By default *Chef-solo* is only able to use data bags for `data_bag` and `data_bag_item` operations; to use search with solo you need to use extension [chef-solo-search](TODO).

> **Note 2**: In some cases this is not enough, however: if cookbook designed in such a way that search is explicitly prohibited in solo mode, some changes to the cookbook are necessary. Below is an example of the modifications I had to do for *Munin* cookbook to make it work with both *Chef-solo* and search.

{% highlight ruby %}
# Original cookbook recipe
if Chef::Config[:solo]
   sysadmins = data_bag('users').map { |user| data_bag_item('users', user) }

# Change to
cant_search = Chef::Config[:solo] && node.recipes.grep(/chef-solo-search/).empty?
if cant_search
   sysadmins = data_bag('users').map { |user| data_bag_item('users', user) }
{% endhighlight %}

## Applying Chef roles ##

There are two sides to actual executing a Chef cookbook via capistrano: *cap* side and *chef*. On every server we need to execute command that applies configuration specific to that server. We could do this sequentially, by using `:hosts` option to `run` method, but this will be really slow.

Instead of this, I am using a bit of Capistrano magic and small Ruby script on remote server(s) side.

### Capistrano task ###

Following task starts parallel run of remote script `run_roles.rb` on all servers with option that contains server name from *cap* configuration. This `$CAPISTRANO:HOST$` variable is special Capistrano magic, it is internally converted by Capistrano to `server.host` (Note: It is *not* shell variable, it is set by Capistrano *before* shell runs).

{% highlight ruby %}
task :roles do 
    run %Q{ #{try_sudo} #{chef_solo_remote}/run_roles.rb  $CAPISTRANO:HOST$ }
end
{% endhighlight %}

On remote (i.e. *chef* side) there's a small script, that takes `server.host` as an argument and applies roles from `node` databag.

What happens here is the following:

- script reads databag with current server configuration;
- it reads all roles files (`role.json`) that are listed in the databag;
- combines them into single `run_list`; and
- runs *chef-solo* using combined run list.

{% highlight ruby %}

Chef::Config[:solo] = true
Chef::Config[:data_bag_path] = "#{current_path}/data_bags"
current_host = ARGV[0].gsub(/\./,'_')

exit unless current_host

roles =  Chef::DataBagItem.load(:node, current_host)["role"]

run_lists = []
roles.map{ |x| "#{ current_path}/#{x}.json"}.each do |role|
  run_lists += JSON.parse(File.read role)["run_list"]
end

File.open("#{current_path}/#{current_host}.json", "w") do |f|
  f.print({ run_list: run_lists.compact.uniq }.to_json)
end

cmd = "cd #{current_path} && chef-solo --config solo.rb --json-attributes #{current_host}.json"
begin
  PTY.spawn (cmd) do |stdin, stout, pid|
    begin
      stdin.each { |line| print line }
    rescue Errno::EIO
    end
  end
rescue PTY::ChildExited
  puts "The child process exited!"
end
{% endhighlight %}

# Next steps #

To be able to deploy full stacks of applications additionally to basic hosts information Capistrano needs to share all its configuration with Chef. In next installments I will describe how this can be achieved.

<!--  LocalWords:  und Capiche sysadmins sudo config PTY stdin pid
 -->
