class Empresa < ActiveRecord::Base
  def to_s
  	"#{ self.nombre }"
  end
end