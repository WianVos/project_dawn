class StoneBridge::Application
  # get all plugins
  get '/plugins' do
   json PluginManager.plugin_list
  end
end