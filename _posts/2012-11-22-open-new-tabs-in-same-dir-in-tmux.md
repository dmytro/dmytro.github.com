---
layout: post
title: Opening multiple Tmux panes in the same directory
enable_gist_numbers: true
tags:
  - tips
  - unix
  - tmux
  - cli
  - shell
summary: |
  This small snippet of code allows opening windows/panes inside tmux in the same UNIX directory.
description: ""
---


Summary
==========

{{ page.summary }} 

<br clear='all'>
Source code
------------

<script src="https://gist.github.com/4129656.js?file=tmux_pwd.sh"></script>

When working on project I quite often want to open new window or pane in Tmux in the same directory where I am now at the moment. Before I figured out how to do it, it was like this: open new pane, `cd <...>`, `cd <...>`, `cd <...>`.  Even with single `cd` and tab completion, navigating through deeply nested project tree can be not that easy.

Solution
-----------

Here's the small shell function and alias to help. 

### This is how I use it 

When I want new window or pane to be created and `cd` to that dir automatically I simply type `pwd` and after this open new window/pane.


### And this is how it works


* `tmux_pwd` function executed in your current directory simply sets option for window in your current Tmux session to use this directory as default (lines 3 and 4 of the gist).
    * Line 3 detects current session of the tmux.
* I don't want this function to be executed in the shell which does not run under Tmux. Hence the line No 1 in gist.
* And I don't want all my new windows to be opened in this directory forever. I have my 'global' default directory, which is `~/Development`, and this is where all my windows usually open. So, there's a 'timeout' setting to set my default directory back after 5 mins. Lines 5 and 6.
* And finally there's an alias, on line 8.

I've added this to my zsh functions, but I don't see why it shouldn't work in another shells like Bash. 


