class Localidad < ActiveRecord::Base
  attr_accessible :cp, :nombre, :region_id
  belongs_to :region
  has_many :establecimiento
  def to_s
  	"#{ self.nombre }"
  end
end
