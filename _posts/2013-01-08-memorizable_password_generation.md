---
layout: post
title: Memorizable password generation
# series: 
# github_project: 
tags:
  - ruby
  - tips
  - development
published: true
summary: |
  Script to generate memorizable random strings
description: |
  Small function to generate random string of syllables, easier to remember and enter for humans
  
---

I was in need to write function to generate pseudo-random strings that are easier to remember and type for a human. To use either for passwords or let's say random coupon codes.

In my search I came across [this solution](http://snipplr.com/view/1247/). It sure works, but does not look pretty enough.


{% highlight ruby %}
def self.random_password
  c = %w( b c d f g h j k l m n p qu r s t v w x z ) +
      %w( ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr )
  v = %w( a e i o u y )
  f, r = true, ''
  6.times do
    r << ( f ? c[ rand * c.size ] : v[ rand * v.size ] )
    f = !f
  end
  2.times do
    r << ( rand( 9 ) + 1 ).to_s
  end
  r
end

{% endhighlight %}


So I decided to do my own. After few modifications I came up with example below:

{% highlight ruby %}
class Array
  def rand
    self[Random.rand(self.size)]
  end
end

def random_password size=4
    c = %w(b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr) 
    v = %w(a e i o u y) 
    (0...size).reduce('') { |r| r << c.rand << v.rand }
end
{% endhighlight %}

All together it's not really any shorter, but function itself is less than half the size of the original, and as a side effect, there's also `Array.rand` method.
