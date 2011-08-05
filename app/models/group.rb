class Group
  include Mongoid::Document
  field :name
  field :owner, type: BSON::ObjectId
  field :admin, type: Array
  attr_accessible :name, :owner, :admin


  has_and_belongs_to_many :users
end

