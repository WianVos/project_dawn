curl -u dbkrtpzmm:kvk9kvk4 -i -H "Accept: application/json" -X GET  http://jira.k94.kvk.nl/jira/rest/api/latest/search

# search string example
http://dbkrtpzmm:kvk9kvk4@jira.k94.kvk.nl/jira/rest/api/latest/search?jql=project=ZMM%20AND%20reporter=%22Erwin%20Embsen%22&fields=id,key,status,project,reporter

