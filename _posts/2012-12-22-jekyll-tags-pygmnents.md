---
github_project: dmytro.github.com
layout: post
title: New tricks and questions with Jekyll
series: "Github & Jekyll"
# Make TOC floating or plain: left or right
# float_toc: right
tags:
  - blog
  - github
  - jekyll
  - tips
published: true
summary: |
  Some new feature added to the blog, but this also brought new questions
description: |
  I've learned something new about using Jekyll, but at the same time have some new questions not resolved yet
  
---

<p class="italic"> {{ page.summary}}. {{ page.description }}. </p>

## Tagging and tag cloud

I was playing a bit with different versions of tags clouds. Some of them didn't quite work for me , since they require adding Jekyll plug-ins and Github does not allow running custom plug-ins.

I've ended up with jQuery based tags. Now there's a tag cloud on pages, cross referenced links to tags list. And question:

### How to make tags in pages work?

For now ` site.tags ` lists only tags in blog posts, but not tags defined in other pages (for example in projects pages). however each individual page list tags when accessed by `page.tags`. 

Ideally I want to see list of all my pages in the tags list.  Not found solution for this yet. Keep looking.

### Sources

All tag cloud related stuff can be downloaded from the Github repo and is in `_includes/tag_*` files.

## Syntax highlight with Pygments

Up until today I was using Gists for inclusion (colored) pieces of code into blog posts. This works quite well, but for many small snippets can be a bit troublesome. Instead I've discovered for myself Pygments, and this is the result:

{% highlight ruby linenos %}
def foo
  puts 'foo'
end
{% endhighlight %}

To have that code above colored, simply add `highlight` tags around your code as in the example below:


    { % highlight ruby linenos % }
      # ....  code here
    { % endhighlight % }

You need to do some preparation too:

* add `pygments: true` in `_config.yml`
* create CSS file and include reference to it
  - CSS file can be generated easily by:
```  
   pygmentize -S default -f html > default.css
```
