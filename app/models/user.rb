class User < ActiveRecord::Base
  has_many :user_roles, :foreign_key => 'user_id', :class_name => 'UserRole'
  has_many :roles, :through => :user_roles
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :role_ids, :apellidos, :nombres

  def to_s
    "#{ self.nombres } + #{ self.apellidos }"
  end


  def role?(role)
    return !!self.roles.find_by_description(role.to_s.camelize)
  end

  after_create :default_role

  private 
  def default_role    
    UserRole.create(:user_id => self.id, :role_id => Role.where(:description => 'User').first.id)
  end

end

