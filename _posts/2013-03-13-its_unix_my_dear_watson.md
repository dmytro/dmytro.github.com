---
layout: post
title: It's UNIX my dear Watson
# series: 
github_project: sherlock_os
tags:
  - blog
  - shell
  - unix
  - cli
  - linux
published: true
summary: |
  Shell script for detecting aspects of UNIX OS: version, Linux distribution, clone name, release
description: |
  This is a simple shell script to detect UNIX/Linux OS and various aspects of the OS. Especially for Linux: distribution type and derivative (such as CentOS/RHEL or Debian/Ubuntu)
  
---

![](/images/2013_03_13_it_s_unix_my_dear_watson.png)
>> Summary:
>> _{{ page.summary }}._

In many shell scripts one can find pieces of code such as:


{% highlight bash %}
if [ grep -i centos /etc/redhat-release ]
then
   DISTRO=CentOS
else
   ...
{% endhighlight %}

and so on. 

It's not difficult task to find what OS/ditsro you are running on, but sometimes it takes couple minutes to remember what is actually different between Debian and Ubuntu to make reliable guess. And it is a repeating task, meaning that couple minutes can be spent more than once.

# Meet Sherlock OS

{{ page.description }}

But it is packaged as real Ruby gem (I am mostly developing in Ruby these days), so installation is as simple as `gem install sherlock_os`. After you install it you can do it like:

{% highlight bash %}
$ sherlock
OS=Linux
MACH=x86_64
KERNEL=2.6.32-5-amd64
DISTRIBUTION=debian
FAMILY=debian
DERIVATIVE=Debian
RELEASE=6.0.6
CODENAME=squeeze
{% endhighlight %}

or even 

{% highlight bash %}
$ eval `sherlock | grep DERIVATIVE`
$
$ echo DERIVATIVE
Debian
{% endhighlight %}

## Documentation

Available at [http://dmytro.github.com/sherlock_os](http://dmytro.github.com/sherlock_os)

## Source code

[http://github.com/dmytro/sherlock_os](http://github.com/dmytro/sherlock_os)

_Enjoy!_

