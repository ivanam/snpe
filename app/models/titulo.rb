class Titulo < ActiveRecord::Base
  belongs_to :persona
  has_many :inscripcion
end
