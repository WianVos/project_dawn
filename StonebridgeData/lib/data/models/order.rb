class Order
  include MongoMapper::Document

  key :order_id, String, :unique => true
  key :order_status, String, :default => "new"
  key :environment_id, Object_id
  key :action, String
  key :applicationserver, String
  key :template, String

  belongs_to :environment
  has_one :job
  has_many :order_items


end

