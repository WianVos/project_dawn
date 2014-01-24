#requires go here
require 'rufus-json/automatic'
require 'ruote'
require 'ruote/storage/fs_storage'
require 'net/http'
require 'fileutils'
require 'yaml'
require 'plugin'

# Description of the plugin

# task Description

# data emission Description


class Supervisor < Plugin

  @stages = ['check']
  @order = "100"
  @participant_matcher = 'Supervisor'
  @items = ['check_general']

  def on_workitem
    item =  workitem[:params]['item']
    plugins = workitem[:params]['plugins']

    p item
    done = false
    plugins.each { | plugin |
      p plugin
      p workitem.fields[item]['info']
      p workitem.fields[item]['info']["#{plugin}Done"]
        done = true if workitem.fields[item]['info']["#{plugin}Done"] == true || nil
    }


    workitem.command = 'rewind' unless done == true
    
    # hand the workitem back to the engine

    reply_to_engine(workitem)

  end
  



end