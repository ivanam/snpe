class Nivel < ActiveRecord::Base
  attr_accessible :nombre
  def to_s
  	"#{ self.nombre }"
  end
end
