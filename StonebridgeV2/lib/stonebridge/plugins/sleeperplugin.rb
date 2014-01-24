#requires go here
require 'rufus-json/automatic'
require 'ruote'
require 'ruote/storage/fs_storage'
require 'net/http'
require 'fileutils'
require 'yaml'

# Description of the plugin

# task Description

# data emission Description


class Sleeper < Plugin
  @stages = ['check']
  @order = "95"
  @participant_matcher = 'Sleeper'
  @items = ['check_general']

  def on_workitem
    sleep_in_seconds =  workitem[:params]['sleep'] 
    
    sleep(sleep_in_seconds.to_i)

    reply
  end
  



end