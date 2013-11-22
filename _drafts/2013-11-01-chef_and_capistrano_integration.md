---
layout: post
title: "und Capiche: Chef and Capistrano Integration"
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
  - rails
  - node.js
  - configuration
  - development
published: true
summary: |
  Capistrano privies excellent remote SSH execution framework. I am using Capistrano to execute and deploy Chef roles and provide tools to access Capistrano configuration from inside Chef, and vice-versa.
description: |
  I do deployments. Both Linux infrastructure and applications (Ruby on Rails or Node.js). Can this be combined? Can I deploy infra and application in single step? Why not?
  
---

# What is it? #

<em>{{ page.summary }} {{ page.description }}</em>

Capistrano and Chef have many things in common. Chef deploys 'things', Capistrano deploys other 'things'; there are roles in Chef, there are roles in Capistrano; both can execute commands, install packages and do other similar things.

At the same time Cap and Chef there are differences: they are configured differently; roles are slightly different, and are defined differently.

In the past I've made several attempts to combine deployments by Chef and Capistrano. These attempts are reflected in several git repositories: ****aws_deploy, chef-solo, capistrano-recipes.**** 

# Application Centric Architectures

In the old days deploying a server took longer. Install server in a rack (if you're lucky, you could reuse somebody else's retired box). Optimistically - racking a server is one day. You (or your SA) installs OS on it: another day (with all the approvals). In extreme cases (not a joke!) deploying a server took me 5 to 6 months.

In the old days, you had standard servers built for you -- if you were application person. But if you were UNIX SA like me, you were building standard servers. Depending on your application resources demands you were installing different pieces of the application(s) on this or that server.

Quite often function of the server was shared between multiple applications: "There's a DB server, we will install every possible database on it, because it has a lot of memory and disks. But if there's no enough space for all databases, we will migrate that server to larger hardware, we build a cluster, add disks and memory." Application architecture was influenced or dictated by infrastructure architecture.

Now, with virtualization, how long does it take to deploy a new server? Depends, but in most cases below a minute. Instead of placing all of the company's databases onto singe DB server, each application can have own DB server or cluster. Same for the application servers. There is no reason to share server between applications or between different functions of the same application. Server sizing is easier, each application, database, web or other server can have exactly as much resources as is required by the application component.

These days architecture of the application dictates architecture of the infra. Each application can have its own architecture, list of components, and amount of resources consumed by each component.

## Management ##

All of these make administration of this architecture easier and more difficult at the same time.

Easier, because of the one function per server approach. We can decomission (upgrade) server and be sure that it did not serve any additional tasks that we are not aware of. For exactly the same reason shorter life-time of the server(s) is better.

Management is more difficult, because of larger number of servers that you need to manage. But this is where devops code can help.

# What do I want with this project? #

I want to build servers from scratch& If not from bare metal, then at least from 'bare OS installation'. Not just servers, but 'architectures' - architectures, tailored for applications. Servers organized into logical groups, with application(s) running on them at the end of single step deployment.

**I want to be able to:**

- provide hostname(s) of server(s), many of them if that required by application;
- have an SSH access key(s);
- Sudo access on all servers, or at least `su`;
- specify server role(s), like `:app` (Note: I am following Ruby and Capistrano conventions here), `:monitoring`, `:logger`;
- run deployment;
- have running application on newly deployed server(s) is XX minutes;
- I do not want to write extensive configuration for each new application or 'architecture', just server IP's or hostnames and roles.

Additionally I do not want to depend on any specific 'cloud' or non-cloud provider of computing resources. Similarly, I do not really want to depend on existing 'server infrastructure'. My idea is to bring my laptop to you, plug it in, and have *your* application deployed in minutes, or at least in tens of minutes.

Providing list of hostnames or IP addresses in configuration files are not scalable for large naumber of managed applications and/or for large-scale applications, using hundreds of hosts.

However, I feel that later thsi approach can be extended to auto-generating role description files from the knowledge of available computing resources and application(s) requirements. But let's make one step at a time.

Too much? Not really.

## Chef and Cap ##



<!--  LocalWords:  und Capiche SA
 -->
