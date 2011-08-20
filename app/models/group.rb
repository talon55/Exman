class Group
  include Mongoid::Document
  field :name
  field :owner_id, type: BSON::ObjectId
  field :admin_ids, type: Array
  validates_presence_of :name
  #validates_uniqueness_of :name, case_sensitive: false
  attr_accessible :name

  after_destroy do
    self.users.each do |user|
      if user.group_ids.include? self.id
        user.remove_group self, false
      end
    end
  end

  def isSafeToLeave? user
    !user.isOwner? self
  end

  def remove_user user, continue = true
    self.user_ids.delete user.id
    self.save
    if continue
      user.remove_group self, false
    end
  end

  def owner
    User.find(self[:owner_id])
  end

  def owner= user
    case user
    when User
      self.owner_id = user.id
    when String, BSON::ObjectId
      self.owner_id = User.find(user).id
    end
    #self.save
  end

  def admins
    User.find(self[:admin_ids])
  end

  # This method replaces the existing admin_ids Array. To add an Admin without
  # removing the others, use pushAdmins
  def admins= users
    case users
    when User
      self.admin_ids = [users.id]
    when String, BSON::ObjectId
      self.admin_ids = [User.find(users).id]
    when Array
      self.admin_ids = []
      users.each do |user|
        self.pushAdmins user, false
      end
    end

    self.save
  end

  # This method and admins= are left deliberately inefficient to facilitate
  # checking that every user passed into admin_ids is a valid user. It is also
  # expected that setting the admin array is something that will be done
  # infrequently and with a relatively small array
  def pushAdmins users, persist = true
    case users
    when User
      self.admin_ids << users.id
    when String, BSON::ObjectId
      self.admin_ids << User.find(users).id
    when Array
      users.each do |user|
        self.pushAdmins user, false
      end
    end

    if persist
      self.save
    end
  end

  has_and_belongs_to_many :users
end

