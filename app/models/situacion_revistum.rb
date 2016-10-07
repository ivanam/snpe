class SituacionRevistum < ActiveRecord::Base
  #attr_accessible :nombre
  has_many :persona
  def to_s
  	"#{ self.codigo }"
  end
end
