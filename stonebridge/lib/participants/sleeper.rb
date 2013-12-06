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


class Sleeper < Ruote::Participant

  def on_workitem
    sleep_in_seconds =  workitem[:params]['sleep'] 
    
    sleep(sleep_in_seconds.to_i)

    reply
  end
  



end