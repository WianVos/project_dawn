$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)+ '/lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)+ '/etc'))

require 'pp'
require 'rubygems'
require 'yaml'
require 'bundler/setup'

# stonebridge

require 'application'

# TODO: get the plugin architecture to take care of this
# force the yaml engine to psych
YAML::ENGINE.yamler = 'psych'

use Rack::CommonLogger
use Rack::Lint
use Rack::ShowExceptions

run Application