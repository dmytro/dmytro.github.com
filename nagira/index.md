---
layout: default
featured: true
github_project: nagira
license: MIT
date: 2012-06-08
title: "Nagira: RESTful API for Nagios"
categories:
  - monitoring
  - ruby
  - open-source
toc_headers: "'h1,h2,h3'"
# float_toc: right
tags:
  - monitoring
  - ruby
  - open source
  - restful api
  - sinatra
description: |
  Nagira is Ruby/Sinatra light-weight web services API for accessing and operating data of Nagios hosts and services, accessing Nagios configuration.

summary: |
  Nagios RESTful API. Access your Nagios server data via web.
---

<div class="float right">
<h3><em>Users say</em></h3>

<em><b>Nagira rocks!!</b><br>

I am deploying your Nagira on top of our Nagios infrastructure in our
5 dc. around the globe. So far i feel thankful that you created this
bad boy.<br>

It's allow me to write checks in cluster point of view much easier,
and I am able to combine host/cluster/service status from Nagios
server around the globe into one dashboard!!!<br>

&nbsp;&nbsp;&nbsp;Patai</em>
</div>

### News
* *Mar 27, 2013 -- Nagira 0.2.6 released*
    See details in [Release history](https://github.com/dmytro/nagira/blob/v0.2.6/History.md)
* *Mar 18, 2013 -- Ruby 2.0.0 support*
   Nagira tested with Ruby 2.0.0 RVM installation and added to Travis CI configuration. All tests passing.
* *Mar 15, 2013 - Released version 0.2.5* [See more](posts/2013-03-15-nagira_v0.2.5_release)

[Older news &raquo;](older_news.html)


## Description

{{ page.description }}
Nagira works with following data:

* Objects cache file: hosts, services, contacts, hostgroups, servicegroups, contactgroups, escalations, etc.
* Status file: hoststatus, servicestatus, etc.
* Submit passive check results to Nagios.
* Read Nagios server configuration.

## Usage

#### *Use HTTP client to get object configuration or status information:*


{% highlight bash %}
    curl http://localhost:4567/objects/contact/list
    curl http://localhost:4567/status/list
    curl http://localhost:4567/status.json
    curl http://localhost:4567/status.xml
{% endhighlight %}


#### *Submit passive checks to Nagios*
 
{% highlight bash %}
    curl -X PUT -H "Content-type: application/json;" \
        -d @host_check.json http://nagios.example.com:4567/_status/web_server
        
    {
      "status_code":"0",
      "plugin_output" : "ping OK"
     }
{% endhighlight %}

#### *Or use Nagira as data source for Rails application with ActiveResource*

{% highlight ruby %}
class Service < ActiveResource::Base
  self.site = "http://localhost:4567/_status/"
  self.element_name = "service"
end

...

@services = Service.all

{% endhighlight %}


## Documenation

See [YARD documentation](doc)

### Monitoring patterns for Nagios with Nagira API 

* [Part I: Applications with HTTP RESTful API](/2012/12/12/monitoring-patterns-I.html)
* [Part II: Nagios Checks Aggregation](/2012/12/14/monitoring-patterns-II.html)

### Nagira presentation

This presentation was given and recorded live on Tokyo Linux Users Group (TLUG) on January 26th, 2013.

* [View](http://www.ustream.tv/recorded/28811269)
* [TLUG wiki](http://tlug.jp)
* [Slides of the presentation](/presentations/nagira_tlug.html)

