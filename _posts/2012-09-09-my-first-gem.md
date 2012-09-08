---
layout: default
title: My first gem and first Rubygems impressions
categories: 
  - ruby
  - development
summary: "Producing and publishing gems are easier than I thought"
---

Two days ago I've produced and published my first gem. 

Process ? Simple!
=================

Being from the Perl CPAN background I was prepared for something more laborious: tar'ing and gzip'ing, and uploading files to web server. Moving file(s) around, maintaining archives and deleting old versions (not that I've got any old versions yet).

However, in the end it was much simpler. Even little disappointingly too simple. After you finished writing gemspec file, you simply do `gem build [gemfile]` to build it, `gem install ... ` to install and test locally and `gem push [just-built.gem]` to push it to <http:://rubygems.org> . You'd need to create your Rubygems account first.

After last action -- having answered command line prompt questions about your Rubygems login -- few seconds later you think: "That's all!?" Yes, that's it. Your gem released and can be installed simply by `gem install [name]`.

Well done - Rubygems
====================

After registering and playing a little bit more with Rubygems, I've found some nice features.

Documentation
-------------
Rubygems displays YARD-formatted documentation for the gem.  I am not sure if it's by default or because I had `rake doc` task in my Rakefile, that call `yarddoc`.

Stats
-----

Looking 2 days after uploading gem I discovered this [download stats](https://rubygems.org/gems/rspec_normalized_hash/stats). Of course, you'd like to know, whether somebody likes your work or even did at least somebody download at all ?


What about CPAN?
================

What I found missing in Rubygems compared to Perl CPAN, or at least haven't found it yet with my limited Rubygems experience.
 
- **Testing**  After each update of CPAN module I've used to receive automated test results. Module automatically submitted to testing framework and your test are being run in multiple exnvironments. Good for testing on platforms that I don't have access too -- Windows or  something like AIX/HP-UX, or testing for missing dependencies -- did I have that_nice.gem installed on my system, but didn't include it in dependency list?. However, latter case is rather less important with `bundler` and `Gemfile`.
- **Namespacing** CPAN allows you to apply and register namespace for the module(s) and families of modules. By setting some rules on namings Perl does it easier to find what you really need going from top to bottom. This is what I really miss in Ruby community - searching for right gems can be simpler then it is now.
- **Ticketing** RT (AKA Request Tracker) is ticketing system developed by Perl programmers and it is used by Perl programmers. What can you say more? It is ticketing system used by all Perl contributors. Will be nice to have something similar for Ruby and Rubygems.

What I have released?
================

Hopefully something useful. It's an RSpec test suite for what I call Normalized Hash. Description of Normalized Hash and more info about the specs are in [github project](/rspec_normalized_hash/).
