class Articulo < ActiveRecord::Base

def to_s_descripcion
  	"#{ self.codigo }  -  #{self.descripcion}"
  end
end
