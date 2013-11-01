---
layout: post
title: Speeding up your Jekyll site
series: "Github & Jekyll"
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
  - blog
  - configuration
  - css
  - github
  - jekyll
  - ruby
published: false
summary: |
  Recently I've added some optimizations to my Jekyll setup for faster page loading.
description: |
  As was stated Google and other search engines consider page load speed when building their ratings. Meaning that, improving load speed can boost your SEO rating too, not only your users happiness.
  
---

<em>{{ page.summary }}. {{ page.description }}.</em>


# Understanding the problem

Most of the optimizations in my case was about shrinking CSS, Javascript and images, removing blank spaces from HTML and reducing number of HTTP request by joining assets into single asset file.

But before doing optimization it is better to understand where do you stand and what do you want to optimize.

Good page speed analyzer can be help with the task, I've found decent one at [http://gtmetrix.com/](http://gtmetrix.com/). There are others as well, for example [https://www.site24x7.com/web-page-analyzer.html](https://www.site24x7.com/web-page-analyzer.html), Google has some too.

GTMetrics analyzer is pretty good, it grades the page by relative standing of your page to average page stats on the net, and can grade importance of each metric and recommendations for speed improvements. is Whatever comes red on their report is probably worth your attention.

In my case the most critical things where decreasing number of HTTP request for CSS and Javascript files and reducing size of the hosted images.


-------------------------------------------------------------------------------

# Assets pipeline

## Javascript and CSS handling

I was quite pleased to find for the assets handling `jekyll-assets` gem that works with Jekyll out of the box, and it handles assets very similar to the way Rails does it, so less learning for me. There are other solutions as well, obviously I haven't tested all of them, but mapong tested ones this one is on of the better ones.

Adding the gem to Jekyll setup is quite simple, just include lines into `Gemfile` and `_plugins/ext.rb` accordingly:

{% highlight ruby %}
gem 'jekyll-assets'
    ...
require 'jekyll-assets'
{% endhighlight %}


Next step is a bit of reorganizing of how Javascript and CSS (or SASS) files are laid out in your working directory.

In my setup JS and SASS files are in `./js/` and `./sass/` directories. Sass saves generated CSS's in `./css`. For generating CSS files during local testing and when publishing I had sass command in my Rake task &mdash; in more details this was described in [previos post](/2013/08/13/more_about_jekyll.html) &mdash; but with introducing assets pipeline this became redundant.

Examples of the new Rake tasks are given below.

### Refactoring assets ###

`Jekyll-assets` introduces new directory `_assets` with subdirectories `stylesheets` and `javascripts`. I've moved all my .js and .sass files to the new location and replaced all `style` and `script` references from the code with just 2 lines:

{% raw %}
    {% javascript app %}
    {% stylesheet app %}
{% endraw %}

`Jekyll-assets` uses similar to Rails assets declaration, so to include all of my JS and CSS, what I had to do is to create two new files &mdash; one in each directory.

* File `_assets/stylesheets/app.css`
        #= require cssnormalize-min
        #= require dmytro
        #= require pygments
        #= require fancybox
* File `_assets/javascripts/app.js`
        #= require jquery
        #= require jquery.tagcloud
        #= require fancybox
        #= require tag_cloud

Resulting parsed JS and CSS tags look like:

{% highlight html %}
<link rel="stylesheet" href="/assets/app-e4c2b9c81e41368c0fcc779280bd5530.css">
<script src="/assets/app-b80c4942bb62b4e63380a8693c39923c.js"></script>
{% endhighlight %}

## Optimizing images

Another important aspect of optimization is reducing file size of the images. There are two parts in it: reducing geometry of the (mainly) photos, and second is adding some optimization to reduce file of the image. Both JPEG's and PNG's can be reduced quite significantly.

### Reduce geometry of JPEG files ###

First of all, files exported from iPhoto or such, can end up in a lot of various sizes. Sometimes you just forget to select proper reduction and have image files of impractical for the web sizez. ImageMagick can handle this quite easy, only needed is to add simple Rake task for it.


{% highlight ruby linenos=table %}
    def resize name, w, h
        sh %{mogrify -resize #{MAX_GEOMETRY[:w]}x#{MAX_GEOMETRY[:h]} '#{name}'}
    end
    
    MAX_GEOMETRY = { w: 1280.0, h: 960.0 }
    namespace :jpeg do
    
        task :list do 
          @jpgs = Dir.glob("**/*.jpg") - Dir.glob("_site/**/*.jpg")
        end
    
        desc "Scale down images to max geometry allowed"
        task :resize => :list do 
          files= { }
    
          @jpgs.each do |jpg|
            IO.popen "identify '#{jpg}'" do |p|
              f = p.read
              name,bla,size = f.split(/ /)
              name.sub!(/jpg\[\d+\]$/, 'jpg')
              w,h = size.split('x').map(&:to_i)
              next unless name && w && h
              resize(name, w, h) if w > MAX_GEOMETRY[:w] || h > MAX_GEOMETRY[:h]
            end
          end
        end
    

{% endhighlight %}

### Optimize JPEG's and PNG's ###

Additionally to geometry reduction significant size reduction can be gained by optimizing imgages: removing unnecessary Exif tags and comments from JPEG's or applying various deflating algorythms. For PNG's optimizations are lossless, but for JPEG's you can select to reduce image quality or do lossless optimization.

Binaries for image optimizations are available for both MacOS and Lnux. On MacOSX `jpegoptim` is available as part of Homebrew and is installed simply by `brew install jpegoptim`. As for the PNG optimization `pngout` binary is downladable from [Ken Silverman's Utilities page](http://www.jonof.id.au/kenutils).


{% highlight ruby linenos=table %}
desc "Compress JPEG images"
    task :minimize => :list do 
      @jpgs.each do |f|
        sh "jpegoptim --strip-all --totals -o '#{f}'"
      end
end

namespace :png do
[... taks list omitted ...]

desc "Compress PNG images"
task :minimize => :list do 
  @pngs.each do |png|
    before = File.size png
    sh "./bin/pngout #{png} -q | true"
    puts "#{png} : #{before - File.size(png)} bytes smaller "
  end
{% endhighlight %}


-------------------------------------------------------------------------------
    
# HTML compression

For further reduction of the web page(s) size stripping all excessive white spaces and html comments can help too. There's a Jekyll plugin (more than one) for that too. I've tried couple of them and stopped on `jekyll-minify-html`.

It is also installable as gem. To start using in, just add `require 'jekyll-minify-html'` statement in `_plugins/ext.rb` and `env: production` in `_config.yml`. That's it.

However I find it quite heave and usually comment out when previewing page locally. That's brings another topic of Jekyll slowness, see below.

-------------------------------------------------------------------------------

# Rake tasks

Finally, these are new Rake tasks for publishing site to Github and for building it locally for preview.

### Rake run

This task starts locally Jekyll for previewing site on the local machine.

{% highlight ruby linenos=table %}
desc "compile and run the site locally"
task :run do
  pids = [ spawn("jekyll serve --watch --drafts") ]
 
  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end
 
  loop { sleep 1 }
end
{% endhighlight %}


### Rake publish

Build site and pubish it to Github. In this task I also use `jpegoptim` to optimize all thumbnails from [Jekyll GalleryTag plugin](https://github.com/redwallhp/JekyllGalleryTag) which are generated automatically on page build (on line 6).

{% highlight ruby linenos=table %}
desc "compile and publish the site to Github"
task :publish do
  sh "git checkout source"
  comment = %x{ git log -n 1 --no-merges --format=%s%b }.chomp.strip
  sh "jekyll build"
  sh "jpegoptim --strip-all --totals -o _site/images/galleries/*-thumb*"
  sh "cd _site && git add -A && git commit -m \"Publishing at $(date): #{comment}\" && git push origin master"
end
{% endhighlight %}


--------------------------------------------

# Some stats ... #

Just some stats about size reduction as result of these experiments. There numbers are far from being precise. During all these changes I kept adding posts and images to the site, so it's hard to tell exactly how much space each one have saved. I only can roll back my git repo and see how size changed between commits.


<table>
<tr><th>&nbsp;<th>Before <th> After
<tr><td><em>Full page generated size (kB's)</em>
    <td> 483,524
    <td> 478,324
<tr><td><em>Number of image files</em>
    <td> 375
    <td> 878
<tr><td><em>Assets size (kB's)</em>
    <td> 88(css) + 184(js)
    <td> 188 <em class='smaller'>(JS+CSS together, including GZ'ipped copies)</em>
<tr><td><em>GTmetrix Y Slow grade</em>
    <td> C
    <td> B
</table>

Even with number of photos (main size factor on this site) increase about twince overall size went a bit down, and as for JS and CSS total size reduced by about 40%, not mentioning that instead of about dozen HTTP requests there are only 2 now.

# ... and problems #

## Jekyll is slow ##

After I started playing with multiple Jekyll plugins, I've started noticing significant slowing of the page generation. Even for small page changes it takes multiple tens of seconds to recreate file and page reload often show missing file or not regenerated CSS's.

Full page build with CSS/JSS/HTML compression tames more than 2 minutes, and this is only for 48 blog posts (this one is 49's). 

## Liquid is quite limiting ##

Another problem is that Liquid templating used by Jekyll is, while easy to learn one, is quite limited and a bit hard to extend.

I am finding that doing even simple (not-supported) things in Liquid is virtually impossibe without writing custom plugin. Things, that in ERB would be done with 2-3 ruby commands, requires a lot of jumping through the loops.

### Middleman? ###

Time to look for something new?

Recently I've read some intros to [Middleman](http://middlemanapp.com/).

So far my impressions are:
- ERB vs Liquid is *GOOD THING*. I can compare this relationship to that one of Puppet vs Chef, i.e. custom configuration language plus some added on top of it Ruby DSL vs clean from the start DSL;
- lot of things, that require a lot of plumbing in Jekyll are by default in Middleman (one example, being [Asset Pipeline](http://middlemanapp.com/asset-pipeline/)).

Oh wel...


<!--  LocalWords:  SEO GTMetrics
 -->
