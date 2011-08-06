class Group
  include Mongoid::Document
  field :name
  field :owner_id, type: BSON::ObjectId
  field :admin_ids, type: Array
  validates_presence_of :name
  #validates_uniqueness_of :name, case_sensitive: false
  attr_accessible :name, :owner_id, :admin_ids, :user_ids

  after_destroy do
    self.users.each do |user|
      if user.group_ids.include? self.id
        puts "test"
        user.remove_group self.id
        user.save
      end
    end
  end

  def owner
    User.find(self[:owner_id])
  end

  def admins
    User.find(self[:admin_ids])
  end

  has_and_belongs_to_many :users
end

