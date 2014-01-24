require 'yaml'
require 'wfengine'
class Application

  namespace '/jobs' do
  get '' do
    json WfEngine.processes
  end

  get '/:jobid' do
   # json WfEngine.process(params[:jobid]).original_tree()
    json WfEngine.process(params[:jobid])

  end

  get '/status/:jobid' do
    json WfEngine.process_status(params[:jobid])
  end

  delete '/:jobid' do
    json WfEngine.cancel_process(:jobid)
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

    p request.body
    request.body.rewind



    #get the order_hash from the request
    order_hash =  YAML::load(request.body.read)
    p order_hash

    #order = Order.new(order_hash['action'],
    #                               order_hash['applicatienaam'],
    #                               order_hash['applicatieserver'],
    #                               order_hash['template'],
    #                               order_hash['omgeving'])
    #order.run_proccess


  end
 end
end