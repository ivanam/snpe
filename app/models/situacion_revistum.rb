class SituacionRevistum < ActiveRecord::Base
  #attr_accessible :nombre
  has_many :persona

  validates :codigo, :presence => true
  validates :descripcion, :presence => true
  validates :planta_pre, :presence => true
  validates :tipo_emp, :presence => true

  def to_s
  	"#{ self.codigo }"
  end
end
