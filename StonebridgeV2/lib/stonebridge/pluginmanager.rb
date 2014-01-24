module PluginManager
    @plugins = []

    def self.<<(plugin)
      @plugins << plugin
    end

    def self.load_plugins
      glob = File.join(File.dirname(__FILE__), "plugins", "*plugin.rb" )
      Dir.glob(glob).each {|filename| require filename }

    end

    def self.plugin_list
      @plugins
    end

    def self.get_order(plugin)
      return Object.const_get(plugin).order
    end

    def self.get_stages(plugin)
      return Object.const_get(plugin).stages
    end

    def self.get_plugin_hash
      output = {}
      @plugins.each { |plugin| output[plugin] = Object.const_get(plugin).config_hash}
      return output
    end

    def self.get_plugin_config(item)
      plugin = get_plugin_hash.select{ |p| p == item }
      return plugin[item]
    end


    def self.get_plugins_by(item, value)
      get_plugin_hash.select {|p, v| p if v[item].include? value }.keys
    end

    def self.register_ruote_participants(ruote_engine)
      @plugins.each { |plugin| Object.const_get(plugin).ruote_register_participant(ruote_engine) }
    end


end

