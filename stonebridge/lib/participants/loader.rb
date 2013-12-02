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



class Loader
     include Ruote::LocalParticipant

      def on_workitem
        @orders = workitem
        p @orders 
      
        File.open('/tmp/test1.yml', 'w') {|f| f.write @orders.to_yaml }
        # hand the workitem back to the engine
        reply

      end
      



    end
