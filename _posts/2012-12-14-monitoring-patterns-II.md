---
layout: post
title: Nagios Checks Aggregation
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
  Nagira &mdash; RESTful API for Nagios &mdash; simplifies Nagios checks aggregation  
  
---

[nagira]: http://dmytro.github.com/nagira
[doc]: http://dmytro.github.com/nagira/doc
[nagios]: http://nagios.sourceforge.net/docs/3_0/extcommands.html
[partI]:  /2012/12/12/monitoring-patterns-I.html
<p class='italic'><b>Summary:</b> {{ page.summary }}. {{ page.description }}. For second part of the series an easy way of combining several Nagios results into aggregated check is presented.</p>

Nagios Checks Aggregation
======================

This kind of setup is applicable in situations where there is a need to integrate several already existing Nagios checks, but you need to aggregate information from checks into combined metric. In this case all necessary information already exists in Nagios, there is no need to read it from monitored devices, API can fetch source information from Nagios status store and write back calculated output. See diagram below.

![Simplified diagram](/images/2012-12-14-nagira_nagios_checks_aggregation_flow.png)

Computer Rack Prower Monitoring
---------------------------------

An example of such setup is an electric current monitoring system.

Electric current of the power lines in a computer rack are monitored by Nagios. Information from power lines is collected by SNMP. Computer racks have two power inputs for redundancy; servers, having similarly two redundant power supplies each, are connected to both power inputs.

However, additional requirement exist for monitoring gross current consumed by each rack. For example, in the case of one side power source failure, the whole rack power can fail if sum total of currents is higher than power limit for the remaining source &mdash; even if each of the power lines before the failure is in a green zone.

In this case, to obtain data for the pair of power sources, data of each individual line is read from Nagios status database, instead of using SNMP. Data processed by script, and if total gross current of two power lines is greater than current limit for single line, status is marked as WARNING or CRITICAL. Resulting combined metric (sum of two currents) is written back to Nagios together with RAG status. All communication &mdash; reads and writes &mdash; are done only using web-services Nagira API.

Possible uses
-----------

Other examples where such kind of setup can be applied are:

- load balanced or DNS round-robin farm of web servers, to monitor total network traffic, not only traffic on individual servers;
- status of clustered application &mdash; if it is known, for example, that application execution requires `X` number of servers with `Y` CPU cores, each occupied by `Z%`.


See more
===========

* [Nagios External Commands interface][nagios]
* [Monitoring patterns for Nagios with Nagira API - Part I][partI]
* [Nagira Documentation][doc]
