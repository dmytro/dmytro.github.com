---
layout: post
title: Chef and Capistrano Integration
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
  Capistrano privides excellent remote SSH execution framework. I am using Capistrano to execute and deploy Chef roles and provide tools to access Capistrano configuration from inside Chef.
description: |
  Fot past several months I was working a lot on deployments. Mostly Linux infrastructure deployment and Ruby on Rails or Node.js bases applications deployments. Can this be combined? Can I deploy infra and app in single step? Why noy? There are solutions available on the net for integrating Chef and Capistrano, however I settled on my own.
  
---

# What is it? #

<em>{{ page.summary }}. {{ page.description }}.</em>

# What do I want? #

First my goal is to be able to build servers from scratch, i.e. if not from bare metal, then at least from 'bare OS installation'. Not just servers, but 'architectures', i.e. servers organized into logical groups, with applicaiton(s) running on them at the end of single step deployment.

**I want to be able to:**

- provide an IP adress(es) of server(s), many of them if that required by application;
- have an SSH access key(s);
- Sudo access on all servers, or `su` possibly ability;
- specify server role(s), like `:app` (Note: I am following Ruby and Capistrano conventions here), `:monitoring`, `:logger`;
- run deployment;
- have running application on newly deployed server(s) is XX minutes;
- I do not want to write extensive configuration for each new application or 'architecture', just server IP's or hostnames and roles.

Additionally I do not want to depend on any specific 'cloud' or non-cloud provider of computing resources, similarly I do not really want to depend on existing 'server infrastructure'. My idea is to bring my laptop to you, plug it in, and have *your* application deployed in if not minutes, then tens of minutes.

At a later stage this can be extended to auto-generating role description files from the knowledge of available computing resources and application(s) requirements. But let's make one step at a time.

Too much? Not really.

## Chef and Cap ##


