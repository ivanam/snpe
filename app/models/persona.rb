class Persona < ActiveRecord::Base
  #attr_accessible :apellidos, :calle, :depto, :email, :estado_civil_id, :fecha_nacimiento, :localidad_id, :nombres, :nro_calle, :nro_documento, :piso, :sexo_id, :situacion_revista_id, :telefono_contacto, :tipo_documento_id

  belongs_to :estado_civil
  belongs_to :localidad
  belongs_to :sexo
  belongs_to :situacion_revistum
  belongs_to :tipo_documento
  has_many :altas_bajas_hora , inverse_of: :persona
  has_many :cargo , inverse_of: :persona
  has_many :cargo_no_docente , inverse_of: :persona
  has_many :titulos , inverse_of: :persona
  belongs_to :user
  has_many :rubros
  has_many :inscripcions
  accepts_nested_attributes_for :rubros
  validates :nro_documento, presence: true
  #validates :cuil, presence: true, length: { is: 11 }, numericality: { only_integer: true }




  def to_s
  	"#{ self.apeynom } - #{self.nro_documento} "
  end

  def cargos_d_activos
  end

  def cargos_nd_activos
  end

  def horas_activas
  end

  def get_antiguedad
    
    if self.anio == nil
      anio = "0000"
      dia = "00"
      mes = "00"
    else
      anio = self.anio
      if self.mes == nil or self.mes == 0
        mes = 01
      else
        mes = self.mes
      end
      if self.dia == nil  or self.dia == 0
        dia = 01
      else
        dia = self.dia
      end
    end
    
    "#{ anio }-#{ mes }-#{ dia }"
  end

  # retorna Cargo[] permitidos para inscripcion
  def get_cargos
    funciones = self.rubros.map do |rubro|
      rubro.juntafuncion
    end
    return funciones.uniq
  end
  
  def tiene_cargo_titular
    titulares = self.rubros.select do |rubro|
      return rubro.titular
    end 
    return titulares.size > 0
  end

  def esta_en_el_padron
    return self.rubros.size > 0
  end

  def get_puntaje_para(juntafuncion)
    return self.rubros.where(juntafuncion_id: juntafuncion.id).first.total
  end

  def get_puntaje_II_para(juntafuncion)
    return self.rubros.where(juntafuncion_id: juntafuncion.id).first.promedio
  end

end

