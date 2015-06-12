module LoteImpresionsHelper
  def lote_impresion_permitido
    LoteImpresion.where.not(fecha_impresion: nil)    
  end
end
