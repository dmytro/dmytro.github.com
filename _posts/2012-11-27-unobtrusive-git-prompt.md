---
layout: post
title: Unobtrusive Git prompt for ZSH
enable_gist_numbers: true
tags:
  - tips
  - unix
  - zsh
  - shell
  - prompt
  - cli

summary: |
  How to incorporate Git information in Zsh shell prompt in an unobtrusive manner
description: |
  vcs_info module for ZSH gives an ability to design nice and functional prompts for use with version control systems.
  
---


Summary
==========

{{ page.summary }} 

{{ page.description }} Google can find large number of references to manuals, tutorials, blog posts and what not regrading using the module for prompt designs. In many cases, however, as to my taste resulting prompts stand in the way more than actually help. Four  or five lines shell prompts are not for me, same if prompt occupies 80% of the command line space, or it is too colorful.

It took me a while, first, to learn about ZSH prompts and vcsinfo, and second to design a prompt, that I can use without too much hating it. Below are some screen-shots and code for the prompt.

I am using `git` mostly, so all my examples below are for `git`.

Screen shots
----------------------

### Standard prompt

When not in the git repository prompt is pretty much standard UNIX shell prompt: user name, hostname and last part of the current directory. Stepping into git repository add right part to the prompt (see below).

![Regular shell prompt - not git repository](/images/posts/2012-11-27-1.png)

### Small screen

Same prompt if I am in the git repository but my screen space is too small to accommodate both parts of the prompt (yellow line on the right is pane border in Tmux). Also what is really nice about right part of the prompt: if I start typing very long command and come close to the right part of the prompt, it disappears. 

![Narrow screen](/images/posts/2012-11-27-2.png)

### Clean Git repository 

When I am inside git repository right part of the prompt appears and it indicates:

1. git branch
2. git repository name
3. directory inside the git repository (last part of it)

![Clean git repository](/images/posts/2012-11-27-3.png)

### Git repository with uncommitted changes

Right part in this case adds indication for:

- U - for unstaged changes (encircled)
- S - for staged changes
- M - for stashed changes

![Repository with changes](/images/posts/2012-11-27-4.png)

### Action indication

Finally last screen shot shows example of unfinished merge. In red color indicated current action: merge, rebase,etc.

![In the middle of a merge](/images/posts/2012-11-27-5.png)

Source code
===========

<script src="https://gist.github.com/4152569.js?file=prompt.zsh"></script>

Short explanation for the code.

* Each `zstyle ':vcs_info:*'` line sets style for vcs_info messages. There are 2 messages configured: `vcs_info_msg_0_` and `vcs_info_msg_1_`.
* In each line `vcs_info_msg_0_` and `vcs_info_msg_1_` are first and second arguments in each definition. I.e., for example on line 9 `"%f[%%n@%%m %1~] $ "` is msg 0, and `"%f%a %F{3}%m%u%c %f%b:%r/%S"` is msg 1.
  * `formats` defines style for prompt in inside git repository
  * `nvcsformats` - same for non git directories
  * `actionformats` - for git actions
* Left and right parts of prompt are set on lines 13 and 14 correspondingly to display `vcs_info_msg_0_` on the left and `vcs_info_msg_1_` on the right.

References
===========

Below are links to some of the resources I've used. They can be used as reference or simply as example of different designs of the prompt.

* [Customize your ZSH prompt with vcs_info](http://arjanvandergaag.nl/blog/customize-zsh-prompt-with-vcs-info.html)
* [Git info in your ZSH Prompt](http://briancarper.net/blog/570/git-info-in-your-zsh-prompt)
* [To get a prompt which indicates Git-branch in Zsh](http://stackoverflow.com/questions/1128496/to-get-a-prompt-which-indicates-git-branch-in-zsh)
