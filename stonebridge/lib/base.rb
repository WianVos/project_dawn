require 'sinatra'

class Base < Sinatra::Base
    get '/' do
      "Welcome to stonebridge v0.1 untested"
    end

    get '/info' do
        "Stonebridge is the kick-ass zmm orchestration server on steroids\n
        written by :
            Bastiaan Schaap
            Sebastiaan van Steenis
            Wian Vos"
    end
end
