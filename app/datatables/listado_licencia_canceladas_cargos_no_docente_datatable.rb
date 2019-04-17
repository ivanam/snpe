class ListadoLicenciaCanceladasCargosNoDocenteDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns    
    #@sortable_columns ||= ['establecimientos.codigo_jurisdiccional', 'personas.nro_documento','personas.apeynom','licencia.altas_bajas_hora_id','licencia.altas_bajas_hora_id','licencia.fecha_desde','licencia.fecha_hasta','licencia.articulo_id']
    @sortable_columns ||= ['Licencium.cargo_no_docente_id']
  end

  def searchable_columns
    #@searchable_columns ||= ['establecimientos.codigo_jurisdiccional','personas.nro_documento','personas.apeynom','licencia.altas_bajas_hora_id','licencia.altas_bajas_hora_id','licencia.fecha_desde','licencia.fecha_hasta','licencia.articulo_id']
    @searchable_columns ||= ['Licencium.cargo_no_docente_id']
  end

  private

  def data
    records.map do |record|
      [
            record.oficina,
            record.organismo,
            record.cargo_no_docente.secuencia,
            Cargosnd.where(CargoNoDocente.find(record.cargo_no_docente_id).cargo.to_i).first.to_s,
            CargoNoDocente.where(:id => record.cargo_no_docente_id.to_i).first.persona.to_s,
            record.cargo_no_docente.situacion_revista,
            record.articulo.codigo + " - " +record.articulo.descripcion[0..30].html_safe+"...",
            Util.fecha_a_es(record.fecha_desde),
            Util.fecha_a_es(record.fecha_hasta),
            record.vigente,
            record.obs_sin_goce_cancelacion, 

          
     ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
