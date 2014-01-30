class OrderItem
  include MongoMapper::EmbeddedDocument

  key :type, String
  key :name, String
  key :config, Hash

  belongs_to :order
  has_many :status_entries

end