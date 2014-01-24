$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)+ '/lib'))
require 'pp'
require 'rubygems'
require 'bundler/setup'

# stonebridge

require 'stonebridge/application.rb'

# TODO: get the plugin architecture to take care of this

use Rack::CommonLogger
use Rack::Lint
use Rack::ShowExceptions

run StoneBridge::Application