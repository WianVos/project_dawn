class StoneBridge::Application

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

  get '/status' do
    headers['X-XSS-Protection'] = '1;'
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "POST, OPTIONS"
    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin, Content-Type"
  end

end