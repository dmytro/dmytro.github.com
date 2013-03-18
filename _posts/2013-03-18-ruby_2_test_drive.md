---
layout: post
title: Ruby 2 test drive
# series: 
# github_project: 
tags:
  - ruby
  - environment
  - installation
published: true
include_toc: false
summary: |
  Ruby 2 is fast!
description: |
  First experience of running some of my scripts in Ruby 2 was: WOW !!!
  
---

<em>{{ page.summary }}. {{ page.description }}.</em>

Ruby 2.0.0-p0 is barely out. I was wating for it to appear on RVM radar and today tried it finally. And ... as I said WOW !!!

Look at the numbers below. It's not what you can call a scientific approach for benchmarking, but demonstrates main idea well enough.

Running same small script in 2 Ruby revisions. Ususally second run is faster since some libraries are already preloaded in memory.

Can you see the difference?


## ruby-1.9.3-p374

      Run          First       Second 
                   ------      -----
      real         2.12        1.68
      user         1.54        1.53
      sys          0.16        0.13





## ruby-2.0.0-p0

      Run          First       Second 
                   ------      -----
      real         0.89        0.66
      user         0.59        0.56
      sys          0.10        0.09


