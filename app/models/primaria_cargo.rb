class PrimariaCargo < ActiveRecord::Base
  belongs_to :cargo_inscrip_doc
  belongs_to :inscripcion
  belongs_to :funcion
end
