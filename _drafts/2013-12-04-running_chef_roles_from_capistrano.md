---
layout: post
title: Running Chef roles from Capistrano
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
  - deployment
  - ruby
  - configuration
  - development
published: false
summary: |
  I use Chef databags to pass information between sessions of Capisntrano and Chef
description: |
  Databags are generated on Capistrano side and then used by Chef for server and components configuration
  
---

<em>{{ page.summary }}. {{ page.description }}.</em>

In my new project *und Capiche* I use tandem of Capistrano and Chef-solo to deploy stacks of applications. Stacks are server(s) configuration, all software packages required to run application and their configurations, and application code itself.

Thera are significnt differences between Capistrano run and Chef runs. First and main difference is that they are invoked on different servers. I.e. when Capistrano starts deployment
