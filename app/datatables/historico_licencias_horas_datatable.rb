class HistoricoLicenciasHorasDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns    
    #@sortable_columns ||= ['establecimientos.codigo_jurisdiccional', 'personas.nro_documento','personas.apeynom','licencia.altas_bajas_hora_id','licencia.altas_bajas_hora_id','licencia.fecha_desde','licencia.fecha_hasta','licencia.articulo_id']
    @sortable_columns ||= ['l.fecha_desde']
  end

  def searchable_columns
    #@searchable_columns ||= ['establecimientos.codigo_jurisdiccional','personas.nro_documento','personas.apeynom','licencia.altas_bajas_hora_id','licencia.altas_bajas_hora_id','licencia.fecha_desde','licencia.fecha_hasta','licencia.articulo_id']
    @searchable_columns ||= ['l.fecha_desde']
  end

  private

  def data
    records.map do |record|

      [    
        record.articulo.codigo + " - " +record.articulo.descripcion[0..30].html_safe+"...",
        Util.fecha_a_es(record.fecha_desde),
        Util.fecha_a_es(record.fecha_hasta),
        record.observaciones,
        if record.con_certificado == true
          "SI"
        elsif record.con_certificado == nil
          ""
        else
          "NO"
        end,
        if record.con_formulario == true
          "SI"
        elsif record.con_formulario == nil
          ""
        else
          "NO"
        end,
     ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end