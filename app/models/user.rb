class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :first_name
  field :last_name
  field :user_name
  field :email
  validates_presence_of :first_name, :last_name, :user_name
  validates_uniqueness_of :user_name, :email, :case_sensitive => false
  attr_accessible(:user_name, :email, :password, :password_confirmation,
                  :remember_me, :first_name, :last_name)

  def remove_group group, continue = true
    self.group_ids.delete group.id
    self.save
    if continue
      group.remove_user self, false
    end
  end

  def isOwner? group
    self == group.owner
  end

  def isAdmin? group
    self == group.owner || group.admin_ids.include?(self.id)
  end

  def isMember? group
    self.in? group.users
  end

  def getFullName
    "#{self.first_name.capitalize} #{self.last_name.capitalize}"
  end

  has_and_belongs_to_many :groups
end

