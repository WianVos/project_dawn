
require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/json'
require 'rufus-json/automatic'
require 'ruote'
require 'ruote/storage/fs_storage'
require 'template'
require 'order'
require 'configatron'
require 'yaml'
require 'logging'

autoload :PluginManager, "pluginmanager.rb"
autoload :Plugin, "plugin.rb"
autoload :WfEngine, "wfengine.rb"



class Application < Sinatra::Application
  set :protection, :except => [:json_csrf]




  # initialize config. whe use configatron for that
  configatron.basedir = File.expand_path( '../', File.dirname(__FILE__))
  config_dir = File.join(configatron.basedir, '/etc')
  configatron.configure_from_hash(YAML.load_file("#{config_dir}/config.yaml"))

  # initialize logging

  Logging.logger.root.add_appenders(
      Logging.appenders.stdout,
      Logging.appenders.file(configatron.logging.logfile)
  )

  Logging.logger.root.level = configatron.logging.loglevel.to_s

  logger = Logging.logger(self.to_s)

  logger.debug 'Stonebridge logging initialized'
  logger.debug 'Configuration loaded'

  # Load the plugins
  PluginManager.load_plugins

  # start the Workflow engine
  WfEngine.start

  # initialize the helpers
  helpers do
    Sinatra::JSON
  end

  # set contentype to json
  before do
    content_type 'application/json'
  end

  # load the stuff in resources to keep seperate parts of the interface seperate
  Dir[File.join(File.dirname(__FILE__), 'resources/*.rb')].each { |r| load r }

end
