

class StoneBridge::Application

  namespace '/jobs' do
  get '/jobs' do
    json RuoteEngine.processes
  end

  get '/process/:jobid' , :provides => :json do
    content_type :json
    json RuoteEngine.process(params[:jobid]).original_tree()
  end




  options '/order' do
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "POST, OPTIONS"
    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin, Content-Type"
  end

  post '/order' do
    headers['X-XSS-Protection'] = '1;'
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "POST, OPTIONS"
    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin, Content-Type"

    #get the request body good and ready
    request.body.rewind



    #get the order_hash from the request
    order_hash =  YAML::load(request.body.read)
    order = StoneBridge::Order.new(order_hash['action'],
                                   order_hash['applicatienaam'],
                                   order_hash['applicatieserver'],
                                   order_hash['template'],
                                   order_hash['omgeving'],
                                   RuoteEngine)
    order.run_proccess


  end
 end
end