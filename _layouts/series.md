---
layout: default
float_toc: right
title: Series Index
toc_headers: "'h2'"
---
{% assign count = '0' %}
<h1>Series: {{ page.file }}</h1>
<a class="subtitle" href="/series/">Back to index &raquo;</a>
<hr>

{% for post in page.series[page.file] %}
{% capture count %}{{ count | plus: '1' }}{% endcapture %}

<h2><a href="{{ post.url }}">{{ post.title }}</a></h2>

<p class="subtitle">{% case post.language %}{% when 'ukrainian'  %} Це стаття {{ count }}-а з {{ page.total }} статей серії.{% else %} This article is Part {{ count }} in a {{ page.total }}-Part Series.{% endcase %} ({{ post.date | date: "%-d %B %Y" }})</p>

<p><em>{{ post.description }} </em></p>

<a href="">Top &uarr;</a>
<hr class="thin">

{% endfor %}
