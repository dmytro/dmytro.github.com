---
layout: post
title: Easy translate on a Mac with Google translate
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
  - mac
  - development
  - tips
published: false
summary: |
  Use Google Translate service to create context menu for text snippets translation on a Mac
description: |
  Apple script with Automator allows for simple creating on workflow to use Google Translate service for creatin of context menu for text snippets translation on a Mac

---

<em>{{ page.description }}.</em>




    on run {input, parameters}
    	-- the following 2 lines should be on one line
    	set output to "http://translate.google.com/translate_t?text=" & urldecode(input as string) & "&langpair=auo%7Cen"
    	-- above 2 lines should be on one line
    	return output
    end run

    on urldecode(x)
    	set cmd to "'require \"cgi\"; puts CGI.escape(STDIN.read.chomp)'"
    	do shell script "echo " & quoted form of x & " | ruby -e " & cmd
    end urldecode
