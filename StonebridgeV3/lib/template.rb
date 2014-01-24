require 'configatron'
require 'logging'
require 'erb'

class Template
    attr_accessor :template_path

    def initialize(order_hash)

      # initialize the bindings for use with the erb function
      loop_over(order_hash)
      @template_path = File.join(configatron.basedir, configatron.templatesdir)
    end



    def get_template_filename(template_name)
      template_filename = File.join(@template_path, "#{template_name}.yaml")
    end

    def list_templates
      template_list = Dir.entries(template_path).select {|f| !File.directory? f and f =~ /.yaml/ }

      template_list.map {|fn| fn.gsub('.yaml','')}
    end

    def get_template(template_name)
      YAML.load(ERB.new(File.read(get_template_filename(template_name))).result(get_binding))
    end

    private

    # create instance variables from a key value pair to be used in conjunction with get_bindings
    # to fuel erb parsing of Yaml files
    def loop_over(hash)
      hash.each do | k, v |
        if v.is_a?(Hash)
          v.each do |k1, v1|
            if v1.is_a?(Hash)
              v1.each { |k2, v2| seed_binding(k1 + '_' + k2, v2) }
            else
              seed_binding(k1, v1)
            end
          end
        else
          seed_binding(k, v)
        end
      end
    end

    def seed_binding(k,v)
      instance_variable_set('@' + k , v )
    end

    # Pass the current class bindings
    def get_binding
      binding
    end

end

