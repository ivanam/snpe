class EstablecimientoPlan < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :plan
end
