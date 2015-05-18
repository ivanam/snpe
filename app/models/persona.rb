class Persona < ActiveRecord::Base
  #attr_accessible :apellidos, :calle, :depto, :email, :estado_civil_id, :fecha_nacimiento, :localidad_id, :nombres, :nro_calle, :nro_documento, :piso, :sexo_id, :situacion_revista_id, :telefono_contacto, :tipo_documento_id
  belongs_to :estado_civil
  belongs_to :localidad
  belongs_to :sexo
  belongs_to :situacion_revistum
  belongs_to :tipo_documento
  

  validates :nro_documento, :presence => true
  validates :nombres, :presence => true
  validates :apellidos, :presence => true
  validates :cuil, :presence => true, length: { is: 11 }, numericality: { only_integer: true }

  def to_s
  	"#{ self.nombres } #{ self.apellidos }"
  end
end
