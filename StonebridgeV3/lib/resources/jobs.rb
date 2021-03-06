require 'yaml'
require 'wfengine'
class Application

  namespace '/jobs' do

  get '' do
    json WfEngine.processes
  end

  get '/status' do
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "POST, OPTIONS"
    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin, Content-Type"
    jobs = WfEngine.processes
    @job_status = ReportManager.get_all_last_status
    json @job_status
  end

  get '/:jobid' do
   # json WfEngine.process(params[:jobid]).original_tree()
    json WfEngine.process(params[:jobid])

  end

  get '/ps/:jobid' do
    json WfEngine.process_status(params[:jobid])
  end



  delete '/:jobid' do
    json WfEngine.cancel_process(params[:jobid])
  end



  options '/order' do
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "POST, OPTIONS"
    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin, Content-Type"
  end

  post '/order'  do
    content_type 'application/json'
    headers['X-XSS-Protection'] = '1;'
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "POST, OPTIONS"
    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin, Content-Type"

    #get the request body good and ready

    request.body.rewind


    order_hash = JSON.parse(request.body.read)




    order = Order.new(order_hash)

    json order.run_proccess


  end



  get '/status/:jobid' do
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Allow-Methods'] = "POST, OPTIONS"
    headers['Access-Control-Allow-Headers'] ="accept, authorization, origin, Content-Type"
    status = "jobid not recognized"
    status = ReportManager.get_last_items_status(params[:jobid])
    json status
  end


 end
end
