module LoteImpresionsHelper
  def lote_impresion_permitido
    LoteImpresion.where.not(fecha_impresion: nil).order('fecha_impresion DESC , id DESC')
  end
end
