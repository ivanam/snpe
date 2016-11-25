class TituloPersona < ActiveRecord::Base
  belongs_to :persona
  belongs_to :titulo
end
