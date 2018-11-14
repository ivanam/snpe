class Inscripcion < ActiveRecord::Base
  belongs_to :persona
  belongs_to :region
  belongs_to :concurso
  # para el cargo actual
  belongs_to :ambito
  belongs_to :establecimiento

  has_many :cargo_inscrip_doc, :foreign_key => 'inscripcion_id', :class_name => 'CargoInscripDoc'
  accepts_nested_attributes_for :cargo_inscrip_doc, allow_destroy: true

  validates :persona, :presence => true, uniqueness: { message: "Ya existe una inscripcion para el docente." }
  validates :region, :presence => true
  validates :fecha_incripcion, :presence => true
  validates :cargo_inscrip_doc, presence: { message: "Debe agregar al menos un cargo" }
  validates :concurso, :presence => true

  validate :concurso_es_activo, 
    :ambito_y_establecimiento, 
    :validacion_prioridades,
    :validacion_cargo_permitido,
    :validacion_cargos_no_repetidos

  validate :validacion_persona_unica_inscripcion, 
           :on => :create, 
           :if => :persona_id?

  def tiene_cargo
    return !self.ambito.nil? && !self.establecimiento.nil?
  end

  def ambito_y_establecimiento
    if !self.ambito.nil? && self.establecimiento.nil? || self.ambito.nil? && !self.establecimiento.nil?
      errors.add(:base, "Complete establecimiento y ambito.")
    end
  end

  def concurso_es_activo
  	if !self.concurso.nil? && !self.concurso.es_activo
  		if self.created_at.nil?
		  	errors.add(:base, "Debe inscribirse a un concurso activo.")
		  else
			 errors.add(:base, "Ya cerro la inscripcion, no puede editarla.")
  		end
  	end  	
  end
  
  def validacion_persona_unica_inscripcion
    if self.persona.present? && !Inscripcion.where(persona_id: persona.id).first.nil?
      errors.add(:persona, "Persona ya tiene una inscripcion")
    end
  end

  def validacion_cargo_permitido
    cargo_inscrip_doc.each do |cargoInscripcion|
      if (!cargoInscripcion.marked_for_destruction?) &&
        (!cargoInscripcion.juntafuncion.nil?) && 
        (!persona.get_cargos.include? cargoInscripcion.juntafuncion)
        errors.add(:base, "Cargo ingresado no esta permitido")
      end
    end
  end

  def validacion_prioridades
    prioridades = self.cargo_inscrip_doc.map { |cargoIinscripcion| 
      if !cargoIinscripcion.marked_for_destruction? then
        cargoIinscripcion.opcion 
      end
    }
    prioridades.delete(nil)
    if (!prioridades.include? nil) && (prioridades.sort != Array(1..prioridades.length))
      errors.add(:inscripcion, "Las prioridades ingresadas son incorrectas")
    end
  end

  def validacion_cargos_no_repetidos
    cargos = self.cargo_inscrip_doc.map { |cargoIinscripcion| 
      if !cargoIinscripcion.marked_for_destruction? then
        cargoIinscripcion.juntafuncion 
      end
    }
    cargos.delete(nil)
    if (cargos.uniq.length != cargos.length)
      errors.add(:inscripcion, "Cargos ingresados repetidos")
    end
  end
  
end