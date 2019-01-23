class Materium < ActiveRecord::Base
  validates_uniqueness_of :codigo , message: 'debe ser unico'
  def to_s
	"#{ self.codigo } - #{self.descripcion}"
  end
end
