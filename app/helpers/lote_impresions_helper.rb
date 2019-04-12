module LoteImpresionsHelper
  def lote_impresion_permitido
  	 if current_user.role? :delegacion
       if (current_user.region == '2') 
  	      @loteH = LoteImpresion.select('lote_impresions.id').from('lote_impresions, altas_bajas_horas, establecimientos, localidads, regions').where('lote_impresions.id = altas_bajas_horas.baja_lote_impresion_id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where.not(fecha_impresion: nil).order('fecha_impresion DESC , id DESC').where('altas_bajas_horas.baja_lote_impresion_id is not null').where('regions.nombre = "II"').order('fecha_impresion DESC') 
  	      @loteC = LoteImpresion.select('lote_impresions.id').from('lote_impresions, cargos, establecimientos, localidads, regions').where('lote_impresions.id = cargos.baja_lote_impresion_id AND cargos.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where.not(fecha_impresion: nil).order('fecha_impresion DESC , id DESC').where('cargos.baja_lote_impresion_id is not null').where('regions.nombre = "II"').order('fecha_impresion DESC')
  	      @loteids = @loteH | @loteC
  	      return  LoteImpresion.select('lote_impresions.*').from('lote_impresions').where(id: @loteids)
  	    #return @lote = LoteImpresion.select('lote_impresions.*').from('lote_impresions, altas_bajas_horas, cargos, establecimientos, localidads, regions').where('lote_impresions.id = altas_bajas_horas.baja_lote_impresion_id AND lote_impresions.id = cargos.baja_lote_impresion_id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND cargos.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where.not(fecha_impresion: nil).order('fecha_impresion DESC , id DESC').where('altas_bajas_horas.baja_lote_impresion_id is not null').where('cargos.baja_lote_impresion_id is not null').where('regions.nombre = "II"')
       end
       if (current_user.region == '6')
  	      @loteH = LoteImpresion.select('lote_impresions.id').from('lote_impresions, altas_bajas_horas, establecimientos, localidads, regions').where('lote_impresions.id = altas_bajas_horas.baja_lote_impresion_id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where.not(fecha_impresion: nil).order('fecha_impresion DESC , id DESC').where('altas_bajas_horas.baja_lote_impresion_id is not null').where('regions.nombre = "VI"').order('fecha_impresion DESC') 
  	      @loteC = LoteImpresion.select('lote_impresions.id').from('lote_impresions, cargos, establecimientos, localidads, regions').where('lote_impresions.id = cargos.baja_lote_impresion_id AND cargos.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where.not(fecha_impresion: nil).order('fecha_impresion DESC , id DESC').where('cargos.baja_lote_impresion_id is not null').where('regions.nombre = "VI"').order('fecha_impresion DESC')
          @loteids = @loteH | @loteC
  	      return  LoteImpresion.select('lote_impresions.*').from('lote_impresions').where(id: @loteids)
  	     #LoteImpresion.select('lote_impresions.*').from('lote_impresions, altas_bajas_horas, cargos, establecimientos, localidads, regions').where('lote_impresions.id = altas_bajas_horas.baja_lote_impresion_id AND lote_impresions.id = cargos.baja_lote_impresion_id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND cargos.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where.not(fecha_impresion: nil).order('fecha_impresion DESC , id DESC').where('altas_bajas_horas.baja_lote_impresion_id is not null').where('cargos.baja_lote_impresion_id is not null').where('regions.nombre = "VI"') 
  	     #LoteImpresion.select('lote_impresions.*').from('lote_impresions, altas_bajas_horas, establecimientos, localidads, regions').where('lote_impresions.id = altas_bajas_horas.baja_lote_impresion_id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where.not(fecha_impresion: nil).order('fecha_impresion DESC , id DESC').where('altas_bajas_horas.baja_lote_impresion_id is not null').where('regions.nombre = "VI"')
       end
     end
     if (current_user.role? :sadmin) || (current_user.role? :personal)
       LoteImpresion.where.not(fecha_impresion: nil).order('fecha_impresion DESC , id DESC')
     end
  end
end
