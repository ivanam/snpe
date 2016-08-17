class Licencium < ActiveRecord::Base
  belongs_to :altas_bajas_hora
  belongs_to :altas_bajas_cargo
  belongs_to :articulo

 
 def ash_id
 
 	return self.altas_bajas_hora_id
 end
 def c_id
 
 	return self.cargo_id
 end
  
end
