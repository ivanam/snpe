class Articulo < ActiveRecord::Base
  belongs_to :tipo_articulo

  def to_s_descripcion
  	"#{ self.codigo }  -  #{self.descripcion}"
  end
end
