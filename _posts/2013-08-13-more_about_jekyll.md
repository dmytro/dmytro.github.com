---
github_project: dmytro.github.com
layout: post
title: More experience with Jekyll and setup changes
series: "Github & Jekyll"
tags:
  - blog
  - github
  - jekyll
  - tips
published: true
summary: |
  New features added to the Jekyll gem, at the same time trying to extend my Jekyll setup I hit Github limitations.
description: |
  Several times I've tried to introduce plugins to Jekyll setup or some advanced feature, only to discover that Github disables some of the (quite useful) features.
  
---

<p class="italic"> {{ page.summary}} {{ page.description }}. </p>

# Github's Jekyll

## Plugins

Use of plugins is disabled by Github for security reasons. End of story. You can't use Jekyll plugins when relying on generating your site by Github.

## Related posts and LSI

It was troubling me for some time, since I didn't understand how exactly `post.related_posts` function worked in Jekyll. In the related posts I always saw just a list of latest posts. 

After some searching and reading, I found that Jekyll has attribute `LSI` to control how the list of related posts is generated. When LSI is `false` result is simple list of latest posts, which I had. Also I discovered that Github disables LSI since it produces too much load on their resources.

Solution is to run jekyll locally, generate site and push it to Github. The only thing I didn't know how to make it clean and not requiring lot of maintenance. 

Somebody had [this solution published](http://www.trottercashion.com/2011/04/11/use-git-plumbing-for-more-awesome-github-pages.html), but problem with it was that on each publishing it is pushing whole site instead of changed files only. This is taking too long with my site, since I have some photos, PDF's and what not.

Creating git repository in `_site` directory didn't work because running jekyll build was also destroying `.git` in it.

Advises on [keeping .git with Jekyll](http://stackoverflow.com/questions/7555837/publish-jekyll-generated-to-gh-pages-and-not-overwite-the-git-in-site) gave me some ideas about going forward.


# Jekyll v. 1.x

First of all, there's a lot of changes in Jekyll. I was running v.0.12.x and many changes happened since Jekyll moved to v.1.x, one important change is added option to keep some files from overwriting. 

Below is step by step process for publishing site with Jekyll running locally.

## Process

You'd need some changes to  the configuration of Jekyll.

### Files

Configuration for included or excluded files for Jekyll generation:

1. File lists in Jekyll changed from simple list of space separated strings to arrays of strings. So, for example exclude list now looks differently (see below).
2. Add `keep_files` your `_config.yml` file. It will preserve your `_site/.git` repository information. This is, BTW default setting. 
3. Make sure to include `lsi` attribute, so that your local Jekyll will use it for related content generation.

{% highlight yaml %}
keep_files: [.git]
exclude: [bin, spec, Rakefile, Guardfile, _posts/template.md.erb, Gemfile*, \
  template.md.erb, sass, presentations/css/theme/template]
lsi: true
{% endhighlight %}

### Setup git branches

Publications pushed to Github pages depend on the type of Github page. Here I am discussing "user pages". 

User pages use master branch of the git repository. If master branch contains Markdown, Textile or other markup files Github's Jekyll will try to generate _site from it, but it won't try to generate anything if it's only HTML files. 

We'd need to prepare branches accordingly:

* generated content should go into `master` branch;
* all sources go into different branch. I've chosen to call it `source`.


{% highlight bash linenos=table %}
#
# Create source branch from current master
#
git checkout -b source 
#
# And push it to source branch at Github
#
git push origin source -u
#
# Now, *before* pushing to remote master, clone it into _site directory.
#
git clone -b master git@github.com:dmytro/dmytro.github.com.git _site
#
{% endhighlight %}


### Add publishing task

Include this code into your Rakefile. You'd need to change/add some shell commands accordingly. 

{% highlight ruby linenos=table %}

task :publish do

    # Just make sure we are generating from source branch
    sh "git checkout source"
    
    # I am using SASS for my CSS generation. You'd probably need to change this.
    #
    sh "scss sass/dmytro.sass:css/dmytro.css sass/style.sass:css/style.css"
    
    #
    sh "jekyll build"
    
    # 
    sh "cd _site && git add -A && git commit -m \"Publishing at $(date)\" && git push origin master"
    #
end
{% endhighlight %}

<!--  LocalWords:  jekyll plugins Github's LSI PDF's Gemfile endhighlight CSS
 -->


<!--  LocalWords:  scss cd
 -->
