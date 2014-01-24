
require 'sinatra'
require 'sinatra/json'
require "sinatra/namespace"
require 'rufus-json/automatic'
require 'ruote'
require 'ruote/storage/fs_storage'
require 'stonebridge/template'
require 'stonebridge/order'




module StoneBridge
  autoload :PluginManager, "stonebridge/pluginmanager.rb"
  autoload :Plugin, "stonebridge/plugin.rb"
  autoload :Config, "stonebridge/config"

  class Application < Sinatra::Application

    #ruote
    # start a ruote dashboard/worker/storage combo
    RuoteEngine = Ruote::Dashboard.new(
      Ruote::Worker.new(
        Ruote::FsStorage.new('ruote_work')))

    # tell ruote to be nice and noisy
    RuoteEngine.noisy =  'true'



    config = Config.instance
    config.load_config


    PluginManager.load_plugins
    PluginManager.register_ruote_participants(RuoteEngine)

    helpers do
      Sinatra::JSON
    end


    before do
      content_type 'application/json'
    end


    Dir[File.join(File.dirname(__FILE__), 'resources/*.rb')].each { |r| load r }

  end
end