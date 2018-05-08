class CargosEspecial < ActiveRecord::Base
has_many :cargos

def to_s
	"#{ self.descripcion }"

end

end
