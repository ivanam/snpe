class Despliegue < ActiveRecord::Base
  belongs_to :plan
  belongs_to :materia
end
