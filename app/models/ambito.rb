class Ambito < ActiveRecord::Base
  
  def to_s
	"#{ self.nombre }"
  end
end
