---
layout: post
title: My Really Low Tech Music Player 
tags:
  - mac
  - ruby
  - cli 
  - configuration
  - tips
summary: |
  Small script to play music collection from commands line.
description: |
  Really minimalistic Ruby script to shuffle audio files and play them randomly form disk
---

Summary
==========


{{ page.summary }} 


{{ page.description }} No GUI, very little contol, just enough for simply playing music. Script randomizes list of files and plays them in random order, `Ctrl-C` skips current song and goes to the next, `Ctrl-Z` exits script.

Source code
=============

<script src="https://gist.github.com/4115472.js?file=play.rb"></script>

Configuration
--------------

Before using script generate list of songs with:

    find PATH/TO/THE/LIBARY -type f > music.list
  
Creating "playlists" is just `grep`:


    grep Beatles music.list > favorites.list
    grep "Deep Purple" music.list >> favorites.list

