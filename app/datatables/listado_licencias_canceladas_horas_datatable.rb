class ListadoLicenciasCanceladasHorasDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns    
    @sortable_columns ||= ['Licencium.altas_bajas_hora_id']
  end

  def searchable_columns
    @searchable_columns ||= ['Licencium.altas_bajas_hora_id']
  end

  private

  def data
    records.map do |record|
      [    
            
            record.oficina,
            record.organismo,
            record.altas_bajas_hora.secuencia,
            record.altas_bajas_hora.horas,
            AltasBajasHora.where(:id => record.altas_bajas_hora_id.to_i).first.persona.to_s,
            record.altas_bajas_hora.situacion_revista,
            record.altas_bajas_hora.anio,
            record.altas_bajas_hora.division,
            record.altas_bajas_hora.codificacion,
            record.articulo.codigo.to_s + " - " +record.articulo.descripcion[0..30].html_safe+"...",
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
