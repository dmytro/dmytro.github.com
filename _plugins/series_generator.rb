# -*- coding: utf-8 -*-
# Series Generator is a Jekyll plugin that generates a TOC pages for
# series of articles/posts.
#
#
# How To Use: 
#   1.) Copy source file into your _plugins folder within your Jekyll project.
# ... TBD ...
# Customizations:
# ... TBD ...
# 
# Notes:
#   1.) The last modified date is determined by the latest from the following:
#       system modified date of the page or post, system modified date of
#       included layout, system modified date of included layout within that
#       layout, ... 
#
# Author: Dmytro Kovalov
# Site: http://dmytro.github.io
#
module Jekyll
  class SeriesGenerator < Generator

    def generate(site)
      series = {}
      site.posts.each do |post|

        if post.data['series']
          series[post.data['series']] ||= []
          series[post.data['series']]  << post

          # 
        end
      end

      series.keys.each do |file|
        f_name = Jekyll::UA.transliterate(file, 'md')
        total = series[file].length
        File.open(File.join(site.source, 'series',f_name), 'w') do |f|
          f << <<-EOF
---
layout: series
file: #{file}
total: #{total}
summary: Index of the Series
title: Index of the Series
tags:
  - blog
---
EOF
          f.close
        end
        site.pages <<  SeriesPage.new(site, site.source, "series", f_name, series)
      end
      site.pages <<  SeriesPage.new(site, site.source, "series", "index.html", series)

    end
  end
  
  class SeriesPage < Page
    def initialize(site, base, dir, name, series)
      super(site, base, dir, name)
      self.data['series'] = series
    end
  end
end
