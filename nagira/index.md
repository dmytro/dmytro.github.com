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
tags:
  - monitoring
  - ruby
  - open source
  - restful api
  - sinatra
description: |
  Nagira is Ruby/Sinatra light-weight web services API for retrieving status of Nagios application objects.

summary: |
  Nagios RESTful API. Access your Nagios server data via web.
---

### Users say

> *Nagira rocks!!*

> <em>I am deploying your Nagira on top of our Nagios infrastructure in our 5 dc. around the globe. So far i feel thankful that you created this bad boy.</em>

> <em>It's allow me to write checks in cluster point of view much easier, and I am able to combine host/cluster/service status from Nagios server around the globe into one dashboard!!!</em>
>> *Patai*

### News

* *Mar 15, 2013 - version 0.2.5* [See more](posts/2013-03-15-nagira_v0.2.5_release)
* *Jan 26, 2013* - Nagira presentation at TLUG (see below)

[Archive of the news](older_news)


## Description

{{ page.description }}
* Objects cache file: hosts, services, contacts, _(host|service|contact)_groups, escalations, etc.
* Status file: hoststatus, servicestatus, etc.

## Usage

Use HTTP client to get object configuration or status information:


    curl http://localhost:4567/objects/contact/list
    curl http://localhost:4567/status/list
    curl http://localhost:4567/status.json
    curl http://localhost:4567/status.xml


or submit passive checks to Nagios:
 

    
    curl -X PUT -H "Content-type: application/json;" \
        -d @host_check.json http://nagios.example.com:4567/_status/web_server
        
    {
      "status_code":"0",
      "plugin_output" : "ping OK"
     }



## Documenation

See [YARD documentation](doc)

### Monitoring patterns for Nagios with Nagira API 

* [Part I: Applications with HTTP RESTful API](/2012/12/12/monitoring-patterns-I.html)
* [Part II: Nagios Checks Aggregation](/2012/12/14/monitoring-patterns-II.html)

### Nagira presentation

This presentation was given and recorded live on Tokyo Linux Users Group (TLUG) on January 26th, 2013.

* [View](http://www.ustream.tv/recorded/28811269)
* [TLUG wiki](http://tlug.jp)
* [Slides of the presentation](tlug-2012-01-26)
