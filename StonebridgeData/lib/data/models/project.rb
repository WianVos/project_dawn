class Project
  include MongoMapper::Document

  key :name, String, :unique => true
  key :owner, String

  many :environments, :foreign_key => :project_id

  # loop over all the environments and get the associated assets in a array
  # returns a hash with assets per environment
  def assets
    environments.collect {|e|  e.assets }
  end

  def find_assets_by_environment(environment_name)
    p environments.find_by_name(environment_name)
    environments.find_by_name(environment_name).assets
  end
end