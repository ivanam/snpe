class User < ActiveRecord::Base
  has_many :user_roles, :foreign_key => 'user_id', :class_name => 'UserRole'
  has_many :roles, :through => :user_roles
  belongs_to :persona, :foreign_key => 'user_id', :class_name => 'persona'
  belongs_to :licencia


  has_many :establecimientos_users, :foreign_key => 'user_id', :class_name => 'EstablecimientosUsers'
  has_many :establecimientos, :through => :establecimientos_users 
  accepts_nested_attributes_for :establecimientos_users, allow_destroy: true
  
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable# , :confirmable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :role_ids, :apellidos, :nombres

  def to_s
    "#{ self.nombres } + #{ self.apellidos }"
  end


  def role?(role)
    return !!self.roles.find_by_description(role.to_s.camelize)
  end

  #after_create :default_role

  #private 
  #def default_role    
  #  UserRole.create(:user_id => self.id, :role_id => Role.where(:description => 'User').first.id)
  #end

end

