require 'yaml'
require 'singleton'

module StoneBridge
  class Config

    include Singleton

    attr_reader :plugindir

    def initialize
      @configured = false
    end

    def load_config

      final_config = get_merged_config
      final_config.each_key do |cat|

        if cat == 'defaults'
          final_config[cat].each { |key, val| create_attr_methods( key, val ) }
        else
          final_config[cat].each { |key, val| create_attr_methods("#{cat}_#{key}", val) }
        end
      end
    end

    def read_config_file
      config = {}
      globdir = File.join(File.expand_path('../../etc/', File.dirname(__FILE__)), '*.yaml' )
      Dir.glob(globdir).each {|file| config[File.basename(file).gsub('.yaml','')] = YAML.load_file(file)}
      return config
    end

    def config_defaults
      { 'defaults'=> {
          'config_dir' => File.expand_path('../../etc/', File.dirname(__FILE__)),
          'base_dir' => File.expand_path('../../', File.dirname(__FILE__)),
      }}
    end

    def get_merged_config
      config = read_config_file

      config.merge(config_defaults) { |k, x, y| x.merge(y) }

    end

    def get_item_hash(item)
      get_merged_config[item]
    end

    # adds getter and setter methods for name and assigns val to it
    def create_attr_methods(name, val)
      self.instance_variable_set "@#{name}", val
      self.class.class_eval do
        define_method("#{name}") { val }
      end
    end

  end
end