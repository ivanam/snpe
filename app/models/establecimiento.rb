class Establecimiento < ActiveRecord::Base
  attr_accessible :ambito, :anexo, :codigo_jurisdiccional, :cue, :cue_anexo, :domicilio, :localidad_id, :nombre, :sector
  belongs_to :localidad
  def to_s
  	"#{ self.nombre }"
  end
  
end
