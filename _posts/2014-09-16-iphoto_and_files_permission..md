---
layout: post
title: iPhoto and files permission
# series:
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
  - mac
  - iphoto
published: true
summary: |
  Why is it so difficult to execute chown or chmod with root password?
description: |
  Migrating photo album from iPhoto 8 to iPhoto 9 does not seem and easy task on Mac anymore.

---

<em>{{ page.summary }} {{ page.description }}</em>

First of all iPhoto refuses to upgrade any old library, if it resides on Netatalk volume. It just hangs indefinitely without seemingly doing anything. Then, after you copy all you library to local disk and start rebuilding/upgrading you'd see following dialogs:

![](/images/2014-09-16-iphoto_and_files_permission.iphoto1.png)
![](/images/2014-09-16-iphoto_and_files_permission.iphoto2.png)
![](/images/2014-09-16-iphoto_and_files_permission.iphoto3.png)

But... I'm sorry, iPhoto! I just gave you my root password!? What else do you need to repair permissions? Why simple `chmod -R 777` works for me  and not for you?

Worth mentioning that upgrades are not 100% safe, some libraries are partially broken after completion... :(
