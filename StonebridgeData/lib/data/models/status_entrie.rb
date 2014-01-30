class Status_entrie
  include MongoMapper::EmbeddedDocument

  key :plugin, String
  key :stage, String
  key :status, Hash

  belongs_to :order_item


end