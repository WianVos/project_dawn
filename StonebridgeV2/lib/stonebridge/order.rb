module StoneBridge
  class Order

    # create getters and setters for the various instance variables
    attr_accessor :action, :application, :type, :template, :environment

    # initialize the order class with the orderhash we recieved
    # it should contain
    def initialize(action, applicatienaam, applicatieserver, template, omgeving, engine)
       @action = action
       @application = applicatienaam
       @type = applicatieserver
       @template_name = template
       @environment = omgeving
       @template_hash = StoneBridge::Template.new.get_template("#{@type}-#{@template_name}")
       @engine = engine
       # compose the order hash. This will get passed to the process later on
       @order_hash = {
           'application' => @application,
           'environment' => @environment,
           'items'       => @template_hash,
          }

       @pdef = get_ruote_pdef

    end

    def get_plugin_stages(plugin)
       PluginManager.get_stages(plugin).to_a
    end

    # get plugins associated with the requested item type
    def get_applicable_plugins(type)
       PluginManager.get_plugins_by('items', type)
    end

    # get plugins the should run always
    def get_general_plugins
       PluginManager.get_plugins_by('items', 'all')
    end

    # get all the plugins associated with the bootstrap stage
    def get_bootstrap_plugins
      PluginManager.get_plugins_by('stages', 'bootstrap')

    end


    # sort the plugins on order setting
    def order_plugins(plugins)
      return plugins if plugins.length < 2
      plugins.sort! { |a,b| PluginManager.get_order(a) <=> PluginManager.get_order(b) }
    end


    def run_proccess
       wfid = @engine.launch(
           @pdef,
           'orders' => @order_hash
       )
    end


    def get_subprocess_config
      subproc = {}

      # loop over the order hash to find all items we need to address
      @order_hash['items'].each do |type, types_hash |
        # get all instances for each type
        types_hash.each do |instance, values|
          stage_hash = {}
          # loop over an ordered array of the plugins for each type
          order_plugins(get_applicable_plugins(type) + get_general_plugins).each do |plugin|
            # get the stages for each plugin and add them to the stage hash
            get_plugin_stages(plugin).each do |stage|
              (stage_hash[stage] ||= []) << plugin unless stage == 'bootstrap'
            end
          end
          # dump the stage hash into the subproccess hash at the right subproccess
          subproc["#{type}-#{instance}"] = {'stages' => stage_hash, 'config' => Config.instance.get_item_hash(type) }
          # empty out the stage hash

        end
      end
      return subproc
    end

    def get_ruote_pdef

      # get the subproccesses and bootstrap plugin
      subproc = get_subprocess_config
      bootstrap_plugins =  order_plugins(get_bootstrap_plugins)

      pdef = Ruote.process_definition do

        # start the sequence
        sequence do

          # this is the bootstrap
          # let's get all the bootstrap plugins
          # the bootstrap stage takes care of general stuff we need to setup the rest of the process
          bootstrap_plugins.each do |plugin|
            participant :ref => plugin
          end

          # everything else we do should be concurrent
          concurrence :merge_type => :concat do
            subproc.keys.each do |sub|
              subprocess sub
            end #subprocess
          end #concurrence
        end #sequence

        # create the subproccesses . One for each item from the template
        subproc.each do |subproccess, config|
          define "#{subproccess}" do
            # handle the create stage
            # this is a sequence because it will only go over all the plugins once
            sequence :tag => 'create' do
              config['stages']['create'].each do |plugin|
                participant :ref => "#{plugin}", :item => "#{subproccess}", :task => 'create'
              end # end config
            end # end sequence
            # handle the check stage
            # this stage exhibits a looping behaviour untill all components have status done
            cursor :tag => 'check' do
              config['stages']['check'].each do |plugin|
                participant :ref => "#{plugin}", :item => "#{subproccess}", :task => 'create'
              end
              # the check stage has two special plugins : the supervisor and sleeper . they organize the step and need to be left untouched
              participant :ref => "sleeper", :sleep => '10'
              participant :ref => "supervisor", :item => "#{type}-#{instance}", :plugins => plugins
            end # end cursor
          end # end define
        end # end subproc
      end # end pdef

    end

    # calculate what plugins we need for each step
    def get_step_plugins
      plugin_step_list = {}

      # get the full plugin list
      plugin_list = get_general_plugins + get_applicable_plugins

      plugin_list.each {|plugin|
        plugin_config = PluginManager.get_plugin_config(plugin)
        plugin_config['stages'].each {|stage|
            plugin_step_list[stage] = [] unless plugin_step_list.has_key?(stage)
            plugin_step_list[stage] << plugin }
      }
      p plugin_step_list
    end



  end
end