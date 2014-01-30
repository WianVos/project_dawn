class Asset
  include MongoMapper::Document

  key :name, String
  key :asset_type, String
  key :environment_id, ObjectId

  belongs_to :environment, :foreign_key => :environment_id , :class => Environment

end