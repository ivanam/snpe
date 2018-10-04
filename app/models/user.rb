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
         :recoverable, :rememberable, :trackable, :validatable , :confirmable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :role_id, :apellidos, :nombres, :documento

  def to_s
    "#{ self.nombres } + #{ self.apellidos }"
  end


  def role?(role)
    return !!self.roles.find_by_description(role.to_s.camelize)
  end

  after_create :default_role
  before_create :set_persona
  after_create :actualizar_persona
  after_create :set_nombre_y_apellido

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

  def actualizar_persona
      persona = Persona.where(:nro_documento => self.documento).first()
      if persona != nil 
        if persona.user_id == nil
          persona.user_id = self.id
          persona.save
        else
          errors.add(:base,"ya existe un usuario para la persona #{persona.to_s}")
          return false  
        end
      end
  end

  
  def set_persona
    #corroborar que la opersona existe en el padrón
    if (self.nombres == nil or self.nombres == "")
      errors.add(:base, "Debe completar el nombre")
      return false
    end
    if (self.apellidos == nil or apellidos == "")
      errors.add(:base, "Debe completar el apellido")
      return false
    end
    if Persona.where(:nro_documento => self.documento).first() != nil
      persona = Persona.where(:nro_documento => self.documento).first()
      #agregar linea, pregunmtando si existe en la tabla rubros
      if Rubro.where(:persona_id => persona.id).first != nil 
        #corroborar que la persona no tiene un user asignado
        if (persona.user_id != nil or persona.user_id != 0) 
          #corroborar que el user existe
          if (User.where(:id => persona.user_id).first != nil)
            user = User.where(:id => persona.user_id).first
             #corroborar que el user no este confirmado
             
            if user.confirmed_at != nil
              #agregar mensaje de error
              errors.add(:base,"ya existe un usuario para la persona #{persona.to_s}")
              return false  
            end
          end
        else
          #agregar mensaje de error
          errors.add(:base,"ya existe un usuario para la persona #{persona.to_s}")
          return false 
        end
      else
        errors.add(:base,"la persona no existe en el padrón")
        return false
      end
    else
      #no existe en el padrón
      errors.add(:base,"la persona no existe")
      return false  
    end
  end  

  def set_nombre_y_apellido
    self.nombres
    self.apellidos
  end

  def default_role    
    #una vex creado el user steo el user_role
    UserRole.create(:user_id => self.id, :role_id => Role.where(:description => 'UserJunta').first.id)

  end

end

