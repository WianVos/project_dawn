class Application
  # get all plugins
  namespace '/plugins' do

    get '' do
     json PluginManager.plugin_list
    end
  end
end