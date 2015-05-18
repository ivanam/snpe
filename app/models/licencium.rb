class Licencium < ActiveRecord::Base
  belongs_to :altas_bajas_hora
  belongs_to :altas_bajas_cargo
  belongs_to :articulo
end
