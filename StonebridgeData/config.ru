$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)+ '/lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)+ '/etc'))

# stonebridge

require 'application'

# TODO: get the plugin architecture to take care of this
# force the yaml engine to psych

use Rack::CommonLogger
use Rack::Lint
use Rack::ShowExceptions

run Application