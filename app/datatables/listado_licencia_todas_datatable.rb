class ListadoLicenciaTodasDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  # def sortable_columns    
  #   #@sortable_columns ||= ['establecimientos.codigo_jurisdiccional', 'personas.nro_documento','personas.apeynom','licencia.altas_bajas_hora_id','licencia.altas_bajas_hora_id','licencia.fecha_desde','licencia.fecha_hasta','licencia.articulo_id']
  #   # @sortable_columns ||= ['Licenciasv.fecha_desde']
  # end

  # def searchable_columns
  #   #@searchable_columns ||= ['establecimientos.codigo_jurisdiccional','personas.nro_documento','personas.apeynom','licencia.altas_bajas_hora_id','licencia.altas_bajas_hora_id','licencia.fecha_desde','licencia.fecha_hasta','licencia.articulo_id']
  #   # @searchable_columns ||= ['Licenciasv.fecha_desde']
  # end

  private

  def data
    records.map do |record|
      [
            record.nro_documento,
            record.apeynom,
            record.descripcion,
            record.codigo_jurisdiccional,
            record.id,
            record.codigo,
            Util.fecha_a_es(record.fecha_desde),
            Util.fecha_a_es(record.fecha_hasta),
            record.vigente, 
     ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
