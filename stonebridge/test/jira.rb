#!/usr/bin/env ruby
require 'jira4r/jira4r'

jira = Jira::JiraTool.new(2, "http://jira.k94.kvk.nl/jira")

jira.login("dbkrtpzmm", "kvk9kvk4")

p jira.getProjectByKey("ZMM")

p getIssuesFromFilterWithLimit("ZMM")
