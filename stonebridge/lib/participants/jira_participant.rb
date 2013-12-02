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

class Jira 
    include Ruote::LocalParticipant
      
      def on_workitem
         p workitem[:params]
        # hand the workitem back to the engine
        reply
      end



end
