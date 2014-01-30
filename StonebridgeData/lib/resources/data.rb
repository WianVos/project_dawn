class Application
  namespace '/data' do

    post '/project/:project' do
     json DataManager.add_project(params[:project])
    end

    post '/environment/:project/:environment' do
     json DataManager.add_environment(params[:environment], params[:project])
    end

    post '/asset/:project/:environment/:asset_name/:asset_type' do
     json DataManager.add_asset(params[:asset_name], params[:asset_type], params[:environment], params[:project])
    end

    get '/project/:project' do
      json DataManager.get_project(params[:project])
    end

    get '/environments/:project' do
      json DataManager.get_project_environments(params[:project])
    end
    get '/assets/:project' do
      json DataManager.get_project_assets(params[:project])
    end

    get '/assets/:project/:environment' do
      json DataManager.get_project_environment_assets(params[:project],params[:environment])
    end

  end

end
