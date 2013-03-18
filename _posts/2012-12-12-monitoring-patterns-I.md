---
layout: post
title: Monitoring Applications with RESTful API
series: Monitoring patterns for Nagios with Nagira API
github_project: nagira
tags:
  - monitoring
  - nagios
  - nagira
  - RESTful API
  - ruby
published: true
summary: |
  Reviewed several patterns for integrated monitoring with Nagios and Nagira
description: |
  Nagira &mdash; RESTful API for Nagios simplifies integration of distributed Nagios systems
  
---

[nagira]: http://dmytro.github.com/nagira
[couchbase]: http://couchbase.com "Couchbase"
[jquery]: http://jquery.com/ "jQuery"
[nagios]: http://nagios.sourceforge.net/docs/3_0/extcommands.html

<p class='italic'><b>Summary:</b> {{ page.summary }}. {{ page.description }}. This is first installation of the series.</p>

Nagios is great system. Many features in Nagios are superior to many open source and commercial monitoring system. Adding HTTP based API for Nagios opens new possibilities for simpler architectures of distributed monitoring with Nagios. 

[Nagira API][nagira] provides access to system status, objects configuration in Nagios as well as provides an interface for submitting passive check results using the same HTTP protocol. This opens wider capabilities for monitoring system architecture modularity and integration.

Applications with HTTP RESTful API
=================================

Here I want to review one of the simplest patterns with Nagira - monitoring applications that have built-in HTTP API (RESTful API in our case). This pattern was implemented recently in new project [Nagios For Couchbase](/NagiosForCouchbase). Similar approach can be adopted for any kind of application, that provides access to application metrics via HTTP API.

Nagios For Couchbase
======================


[Couchbase][couchbase] is advanced memory based NoSQL key-value database. It has its own management RESTful API and API for data access. The API provides access to most if not all of the Couchbase operational metrics. Couchbase also has nice web console with multiple graphs displaying server metrics in real time. Actually web user interface in Couchbase is implemented as [jQuery][jquery] interface built directly on top of JSON RESTful API. 

Given Couchbase API combined with [Nagira API][nagira], setting a monitoring system becomes a simple task. Architecture of such setup is presented on the diagram below.

System Architecture
----------------------

1. Script connects to Couchbase API and retrieves server metrics as JSON data object (via HTTP GET request)
1. Script process data and
1. Sends data to Nagira API (HTTP PUT)
1. Nagira writes to [Nagios external command][nagios] interface
1. Results are then processed internally by Nagios

![Nagios For Couchbase Diagram](/images/2012-12-12-nagios_for_couchbase.png)


Advantages of this architecture as far as one can see are:

- Since only HTTP protocol involved for both retrieving data and registering results, script that runs the checks, can be in any location &mdash; on Couchbase server, or on Nagios server or any other host on the network.
- List of couchbase servers can be retrieved from Nagios configuration itself, if corresponding host-group is configured (for example `'hostgroup couchbase'`). Configuration becomes completely data driven and requires no additional changes when adding/removing Couchbase servers to the pool.
- JSON object containing multiple metrics can be read as with single HTTP GET request to Couchbase server, status for multiple checks can be updated similarly with single HTTP PUT to Nagira API, which produces multiple writes to Nagios command file. This reduces load on Nagios server, which is not dealing with scheduling and executing checks.

Executing Checks
----------------------

How actually checks are performed will be reviewed in some of the following posts. Please come again!
