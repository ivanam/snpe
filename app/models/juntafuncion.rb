class Juntafuncion < ActiveRecord::Base

  def to_s
  	"#{self.descripcion}"
  end
end
