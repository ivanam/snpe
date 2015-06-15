class LoteImpresion < ActiveRecord::Base
  has_many :altas_bajas_horas

  has_many :impresion_bajas, class_name: "AltasBajasHora", foreign_key: "baja_lote_impresion_id"

  has_many :alta_cargos, class_name: "Cargo", foreign_key: "alta_lote_impresion_id"

  has_many :baja_cargos, class_name: "Cargo", foreign_key: "baja_lote_impresion_id"
end
