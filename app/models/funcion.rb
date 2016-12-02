class Funcion < ActiveRecord::Base
  def to_s
  	"#{ self.categoria }  -  #{self.descripcion}"
  end
end
