Dir[File.join(File.dirname(__FILE__), 'models/*.rb')].each { |r| require r }

class DataManager

  @settings = YAML.load(File.read(File.expand_path('../../etc/mongo.yaml', File.dirname(__FILE__))))["production"]
  MongoMapper.connection = Mongo::Connection.new(@settings['host'], @settings['port'])
  MongoMapper.database = @settings['database']


  # add a project to mongo if it does not exist
  def self.add_project(project_name)
     Project.find_or_create_by_name(project_name)
  end


  # add an environment to mongo if it does not exist and associate a project with it
  def self.add_environment(environment_name, project_name)
    project = add_project(project_name)
    Environment.find_or_create_by_name_and_project_id(environment_name, project.id)
  end

  # add an asset to mongo if it does not exist and associate it with the correct environment
  def self.add_asset(asset_name,asset_type,environment_name, project_name)
    environment = add_environment(environment_name, project_name)
    asset = Asset.find_or_create_by_name_and_environment_id(asset_name, environment.id)
    asset.asset_type = asset_type
    asset.save!
    return asset
  end


  ## querying
  def self.get_project(project)
    Project.find_by_name(project)
  end

  def self.get_project_environments(project)
    Project.find_by_name(project).environments
  end

  def self.get_project_assets(project)
    Project.find_by_name(project).assets
  end

  def self.get_project_environment_assets(project, environment)
    get_project(project).find_assets_by_environment(environment)
  end



end