class Group
  include Mongoid::Document
  field :name
  field :owner, type: BSON::ObjectId
  field :admin, type: Array
  attr_accessible :name, :owner, :admin

  def owner
    User.find(self[:owner])
  end

  def admins
    User.find(self[:admin])
  end

  has_and_belongs_to_many :users
end

