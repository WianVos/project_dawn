#!/usr/bin/env ruby
require 'rest-client'
require 'yaml'
require 'json'
require 'uri'

module Stonebridge
  class Jira

    def initialize
      config_path = "../../etc"
      config_filename = File.join(config_path, "jira.yaml")
      config = YAML::load(File.open(config_filename))
      config.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def getCollection(path)
      request = RestClient::Request.new(
        :method => :get,
        :url => "#{@jira_url}/#{path.to_s}",
        :user => @username,
        :password => @password,
        :headers => { :accept => :json,
        :content_type => :json }
      )
      response = request.execute

      # puts JSON.pretty_generate(JSON.parse(response.to_str))

      results = JSON.parse(response.to_str)
      
    end

    def postCollection(path, postData)

      request = RestClient::Request.new(
        :method => :post,
        :url => "#{@jira_url}/#{path.to_s}",
        :user => @username,
        :password => @password,
        :headers => { :accept => :json,
        :content_type => :json },
        :payload => postData.to_json
      )

      response = request.execute
      
      results = JSON.parse(response.to_str)
      
    end


    def getIssue(id)
        getCollection("issue/#{id}")
    end

    def getSearch(queryParams)
        getCollection("search?jql=#{encodeSearchUri(queryParams)}")
    end

    def getIssueStatus(id)
        getIssue(id)['fields']['status']['name']
    end   
    def encodeSearchUri(jqlString)
         URI.escape(jqlString)
    end

    def createIssue(description="autogenerated",summary="autogenerated")
        # returns issue key
        postCollection("issue", getJiraIssue(description, summary) )['key']
    end

    def getJiraIssue(description,summary,project=@project)  
        {"fields" => 
            {"project" => 
                {"key" => "ZMM"}, 
                "summary" => "rest Test", 
                "description" => "creating an issue to test the rest interface", 
                "issuetype" => { "name" => "Taak"}
            }
        }
    end
      
    
  end
end

p Stonebridge::Jira.new.getIssueStatus('ZMM-535')


