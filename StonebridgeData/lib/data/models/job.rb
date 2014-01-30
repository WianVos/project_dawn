class Job
  include MongoMapper::EmbeddedDocument

  key :job, String
  key :work_hash, Hash

  belongs_to :order


end