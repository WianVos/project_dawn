require 'rubygems'
require 'sinatra'
require 'ruote'
require 'yaml'

class Jobs < Sinatra::Base
    get '/', :provides => 'html' do
        p  RuoteEngine.processes
        
    end

    get  '/participants', :provides => 'html' do

    end
    
    get '/testjob' do
        pdef = Ruote.define do
            jira
        end

      wfid = RuoteEngine.launch(pdef)
      p wfid

    end

    get '/status/:[jobid]' do
        "not yet implemented"
    end

    get '/template/:template_name', :provides => 'yaml' do
        template_path = "etc/templates"
        template_filename = File.join(template_path, "#{params[:template_name] }.yaml")
        template = YAML::load(File.open(template_filename))
    end

    get '/template/:template_name', :provides => 'html' do
        template_path = "etc/templates"
        template_filename = File.join(template_path, "#{params[:template_name] }.yaml")
        template = YAML::load(File.open(template_filename))
    end

    get '/templates' , :provides => 'yaml' do
        p 'not yet implemented'
    end
    

    options '/order' do
        headers['Access-Control-Allow-Origin'] = "*"
        headers['Access-Control-Allow-Methods'] = "GET, POST, PUT, DELETE, OPTIONS"
        headers['Access-Control-Allow-Headers'] ="accept, authorization, origin, Content-Type"
    end


    post '/order' do 

      #get the body good and ready
      request.body.rewind

      # fill the order hash with the uploaded document
      order_hash = YAML::load(request.body.read)

      # get the template
       template_path = "etc/templates"
       template_filename = File.join(template_path, "#{order_hash['applicatieserver']}-#{order_hash['template']}.yaml")
       template = YAML::load(File.open(template_filename))
      
        # add the template to the order_hash
       order_hash['items'] = template

       # compose the process
        plugins = ["aws", "puppet","reporter"]

       # define the process
       pdef = Ruote.process_definition do

        #start the sequence
        sequence do

          # bootstrap the workitem
          participant :ref => "loader_general"

          concurrence :merge_type => :concat do

            order_hash['items'].each{|t,  d| 
                d.each_key {|i| participant :ref => "jira_#{t}_#{i}", :task => "#{t}" }}


          end
        end
     end

     wfid = RuoteEngine.launch(
        pdef,
        'orders' => order_hash )  
     RuoteEngine.wait_for(wfid,:timeout => 6)
     p wfid
  end
end
