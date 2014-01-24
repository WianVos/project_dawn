require 'pluginmanager.rb'
require 'rufus-json/automatic'
require 'ruote'
require 'ruote/storage/fs_storage'
require 'net/http'
require 'fileutils'
require 'yaml'
require 'erb'

class Plugin < Ruote::Participant

 def self.inherited(klass)
  PluginManager << klass.to_s
 end

 def self.order
   @order
 end

 def self.stages
   @stages
 end

 def self.items
   @items
 end

 def self.participant_matcher
   @participant_matcher
 end

 def self.config_hash
   {
    'order' => @order,
    'stages' => @stages,
    'items' => @items,
    'participant_matcher' => @participant_matcher
   }
 end

 def self.ruote_register_participant(ruote_engine)
   ruote_engine.register /#{@participant_matcher}/, self.name
 end



end
