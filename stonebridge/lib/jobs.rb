require 'rubygems'

require 'sinatra'
require 'ruote'
require 'yaml'
require 'json'


class Jobs < Sinatra::Base
    get '/', :provides => 'html' do
        p  RuoteEngine.processes
        
    end

    get  '/participants', :provides => 'html' do

    end
    
    get '/status' do
       headers['X-XSS-Protection'] = '1;'
       headers['Access-Control-Allow-Origin'] = "*" 
       headers['Access-Control-Allow-Methods'] = "POST, OPTIONS"
       headers['Access-Control-Allow-Headers'] ="accept, authorization, origin, Content-Type"
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
       headers['Access-Control-Allow-Methods'] = "POST, OPTIONS"
       headers['Access-Control-Allow-Headers'] ="accept, authorization, origin, Content-Type"
    end


    post '/order' do 
       headers['X-XSS-Protection'] = '1;'
       headers['Access-Control-Allow-Origin'] = "*"
       headers['Access-Control-Allow-Methods'] = "POST, OPTIONS"
       headers['Access-Control-Allow-Headers'] ="accept, authorization, origin, Content-Type"

      #get the body good and ready
      request.body.rewind

      # fill the order hash with the uploaded document
      order_hash = YAML::load(request.body.read)

      # get the template
       template_path = "etc/templates"
       template_filename = File.join(template_path, "#{order_hash['applicatieserver']}-#{order_hash['template']}.yaml")
       template = YAML::load(File.open(template_filename))
       
       application = order_hash['applicatienaam']
       action = order_hash['action']
        # add the template to the order_hash
       order_hash['items']  = template

      
       ## compose the process
       # what plugins do we need to add
       plugins = ["jira"]

       # define the process
       pdef = Ruote.process_definition do

        #start the sequence
        sequence do

          # bootstrap the workitem
          participant :ref => "loader_general"

          # everything else should be concurrent
          concurrence :merge_type => :concat do
           # loop trough the order_hash and setup a sub-process per instance
            order_hash['items'].each  do | type, types_hash| 
              types_hash.each  do |instance, values| 
                subprocess "#{type}-#{instance}"
              end # instance loop
            end # end items
          end # end concurrency
        end #sequence
            # loop through  the items again and setup the sub-processes with on participant per plugin
        order_hash['items'].each do  | type, types_hash|  
           types_hash.each_key do |instance|
             define "#{type}-#{instance}" do
               sequence :tag => 'create_stage' do 
                 plugins.each do |plugin|
                   participant :ref => "#{plugin}_#{type}-#{instance}", :item => "#{type}-#{instance}", :application =>  "#{application}", :task => 'create', :type => "#{type}"
                 end #plugins
               end # sequence
                
                  cursor :tag => 'check_stage' do
                  plugins.each do |plugin|
                   participant :ref => "#{plugin}_#{type}-#{instance}", :item => "#{type}-#{instance}", :application =>  "#{application}", :task => 'check', :type => "#{type}"
                   end #plugins
                   participant :ref => "sleeper", :sleep => '10'
                   participant :ref => "supervisor_#{type}-#{instance}", :item => "#{type}-#{instance}", :plugins => plugins 
                   
                 end # cursor
            
             end # define
           end # loop over types_hash
         end # loop over items
          
      end # process definition

   
     wfid = RuoteEngine.launch(
        pdef,
        'orders' => order_hash )  
     p wfid
  end
end
