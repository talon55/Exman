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

  def remove_group id, continue = true
    self.group_ids.delete id
    self.save
    if continue
      Group.find(id).remove_user self.id, false
    end
  end

  has_and_belongs_to_many :groups
end

