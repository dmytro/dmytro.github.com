---
layout: post
title: More about custom CSS for RT4
series: Request Tracker
# github_project: 
# gh_pages:
#
include_toc: false
#
# Make TOC floating or plain: left or right
# float_toc: right
#
# What headers to include in TOC: not they must be double and single quoted
# toc_headers: "'h1,h2,h3'"
tags:
  - tips
  - request tracker
  - css
  - configuration
published: true
summary: |
  How do I add custom CSS to RT, where is it?
description: |
  I've received a question to my previous blog - [RT can be less ugly](/2012/07/18/rt-custom-css.html). Question basically was, OK I have CSS, now where do I add it?
  
---

<em>{{ page.summary }}. {{ page.description }}.</em>

Yes, it's not that easy to find this in RT interface. So, here is a small screen shot that shows how to get to this setting. Just don't forget you need to be logged in as root or as user who has permission to see this configuration menu.

Select menu: *Tools &raquo; Configuration &raquo; Tools (again) &raquo; Theme*

When you're there, you'll find *Custom CSS (Advanced)* text box, where you need to add your custom stuff:

![](/images/2013_05_15_custom_css_for_rt4.png)


From the same place you can customize some other visuals of the RT, like colors and company logo.

Here's scren shot for colors and fonts GUI confiruation:

![](/images/2013_05_15_custom_css_for_rt4_2.png)
