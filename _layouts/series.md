---
layout: default
float_toc: right
title: Series Index
---

<a href="/series/">Back to index &raquo;</a>

{% assign count = '0' %}
<h1>Series: {{ page.file }}</h1>

{% for post in page.series[page.file] %}
{% capture count %}{{ count | plus: '1' }}{% endcapture %}

<hr class="thin">
<h2> <a href="{{ post.url }}"> {{ post.title }} </a>  </h2>

<p class="smaller">{% case post.language %}{% when 'ukrainian'  %} Це стаття {{ count }}-а з {{ page.total }} статей серії.{% else %} This article is Part {{ count }} in a {{ page.total }}-Part Series.{% endcase %} <em>({{ post.date | date: "%-d %B %Y" }})</em></p>

<p><em>{{ post.description }} </em></p>

<a href="">Top &uarr;</a>

{% endfor %}
<hr class="thin">

