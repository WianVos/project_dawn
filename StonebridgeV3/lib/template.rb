require 'configatron'
require 'logging'
class Template
    attr_accessor :template_path

    def initialize
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
      YAML.load_file(get_template_filename(template_name))
    end

    def get_collected_template(order_hash)
      p order_hash

    end
end

