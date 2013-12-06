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


class Supervisor < Ruote::Participant

  def on_workitem
    item =  workitem[:params]['item'] 
    plugins = workitem[:params]['plugins']

    done = false
    plugins.each { | plugin |  
        done = true unless workitem.fields[item]['info']["#{plugin}Done"] == false
    }
    
    workitem.command = 'rewind' unless done == true
    
    # hand the workitem back to the engine
    p workitem
    reply_to_engine(workitem)

  end
  



end