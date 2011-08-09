class Group
  include Mongoid::Document
  field :name
  field :owner_id, type: BSON::ObjectId
  field :admin_ids, type: Array
  validates_presence_of :name
  #validates_uniqueness_of :name, case_sensitive: false
  attr_accessible :name, :owner_id, :admin_ids

  after_destroy do
    self.users.each do |user|
      if user.group_ids.include? self.id
        user.remove_group self.id
        user.save
      end
    end
  end

  def isSafeToLeave? user


  end


  def remove_user id, continue = true
    self.user_ids.delete id
    self.save
    if continue
      User.find(id).remove_group self.id, false
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

