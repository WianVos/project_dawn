require 'bundler/setup'
Bundler.require(:default)
require 'sinatra/namespace'
require 'sinatra/json'


# local requires
require 'data/datamanager'

class Application < Sinatra::Application





  # initialize the helpers
  helpers do
    Sinatra::JSON
  end

  # set contentype to json
  before do
    content_type 'application/json'
  end

  Dir[File.join(File.dirname(__FILE__), 'resources/*.rb')].each { |r| load r }
end