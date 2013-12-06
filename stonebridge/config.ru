#require the goodies we need
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '/lib')
puts $LOAD_PATH
require 'rubygems'
require 'sinatra'
require 'rufus-json/automatic'
require 'ruote'
require 'ruote/storage/fs_storage'
require 'net/http'
require 'fileutils'
require 'yaml'
require 'Stonebridge.rb'


# include default participants
#require participants
Dir["#{File.dirname(__FILE__)}/lib/participants/*.rb"].each { |f|  
p f
load(f) }

# require the sinatra modules
require File.dirname(__FILE__) + "/lib/base.rb"
require File.dirname(__FILE__) + "/lib/jobs.rb"

map "/base" do
    run Base
end

map "/jobs" do
    run Jobs
end

#set the sinatra basics
set :root, File.dirname(__FILE__)
set :bind, 'localhost'
set :port, 9292

# start a ruote dashboard/worker/storage combo
RuoteEngine = Ruote::Dashboard.new(
Ruote::Worker.new(
Ruote::FsStorage.new('/tmp/ruote_work')))

# tell ruote to be nice and noisy
RuoteEngine.noisy =  'true'

# Registering participants

# TODO: get the plugin architecture to take care of this

# Mapping participant names to participant classes. These classes must be present in ../lib for now.
RuoteEngine.register /^loader_/, Loader
RuoteEngine.register /^jira_*/, Jira_participant
RuoteEngine.register /^supervisor_*/, Supervisor
RuoteEngine.register /sleeper/, Sleeper


use Rack::CommonLogger
use Rack::Lint
use Rack::ShowExceptions

run Sinatra::Application
