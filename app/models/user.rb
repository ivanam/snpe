class User < ActiveRecord::Base
  has_many :user_roles, :foreign_key => 'user_id', :class_name => 'UserRole'
  has_many :roles, :through => :user_roles
  belongs_to :persona, :foreign_key => 'user_id', :class_name => 'persona'
  belongs_to :licencia
  has_many :establecimientos_users, :foreign_key => 'user_id', :class_name => 'EstablecimientosUsers'
  has_many :establecimientos, :through => :establecimientos_users 
  
  accepts_nested_attributes_for :establecimientos_users, allow_destroy: true
  
  validate :validar_documento, :validar_cuenta_usuario
  after_create :default_role
  after_create :actualizar_persona

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable , :confirmable

  
  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :role_id, :apellidos, :nombres, :documento

  def to_s
    "#{ self.nombres } + #{ self.apellidos }"
  end


  def role?(role)
    return !!self.roles.find_by_description(role.to_s.camelize)
  end

  def tiene_rol(rol) 
    roles = self.roles.map do |rol|
      rol.description
    end
    return roles.include? rol
  end

  # refactorizar esto. geberia ser User.pesona
  def get_persona
    persona = Persona.where(:nro_documento => self.documento).first()
    return persona
  end

 private

  def validar_documento
    documento = self.documento
    persona = Persona.where(:nro_documento => self.documento).first
    if !persona.nil?
      rubro = Rubro.where(:persona_id => persona.id).first
      if rubro.nil?
        errors.add(:base,"DNI ingresado no se encuentra en el padron")
      end
    else
      errors.add(:base,"DNI ingresado no se encuentra en el padron")
    end
  end

  def validar_cuenta_usuario
    documento = self.documento
    persona = Persona.where(:nro_documento => self.documento).first
    if !persona.nil? && !persona.user.nil? && !persona.user.confirmed_at.nil?
      errors.add(:base,"Ya existe una cuenta para el dni ingresado.")
    end
  end

  def actualizar_persona
    persona = Persona.where(:nro_documento => self.documento).first()
    if !persona.user.nil?
      persona.user.destroy
    end
    persona.user = self
    persona.save
  end

   def default_role    
    UserRole.create(:user_id => self.id, :role_id => Role.where(:description => 'UserJunta').first.id)
  end

end

