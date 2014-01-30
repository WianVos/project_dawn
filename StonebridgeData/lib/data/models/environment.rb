class Environment
  include MongoMapper::Document

  key :name, String
  key :project_id, ObjectId


  belongs_to :project, :foreign_key => :project_id, :class => Project
  many :assets
  many :orders

end