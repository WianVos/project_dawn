#requires go here
require 'plugin'

require 'rufus-json/automatic'
require 'ruote'
require 'ruote/storage/fs_storage'
require 'net/http'
require 'fileutils'
require 'yaml'

# Description of the plugin

# task Description

# data emission Description


class Loader < Plugin

  @stages = ['bootstrap']
  @order = "10"
  @participant_matcher = 'Loader'
  @items = ['all']

  def on_workitem

    @orders = workitem.fields['orders']
    # load the application stuff from the yaml

   
    # loop trough the order_hash and create the needed entry's in the workitem
    @orders['items'].each_key do | type |
        @orders['items'] [type].each do | instance , settings |
            workitem.fields["#{type}-#{instance}"] = {}
            workitem.fields["#{type}-#{instance}"]['settings'] = settings
            workitem.fields["#{type}-#{instance}"]['info'] = {'action' => "#{@orders['action']}" }
            workitem.fields["#{type}-#{instance}-done"] = false
         end
     end

    # hand the workitem back to the engine
    reply

  end
  



end