class LicenciaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['licencia.id']
  end

  def searchable_columns
    @searchable_columns ||= ['licencia.id']
  end

  private

  def data
    records.map do |record|
      [
        if record.altas_bajas_hora_id != nil  
          record.altas_bajas_hora_id
        elsif record.cargo_id != nil
            record.cargo_id
        else
            record.cargo_no_docente_id
        end,

        if record.altas_bajas_hora_id != nil  
          "Horas"
        elsif record.cargo_id != nil
          "Cargo docente"
        else
          "Cargo no docente"
        end,

        
        record.fecha_desde,
        record.fecha_hasta,
        record.articulo.codigo + record.articulo.descripcion[0..30].html_safe+"...",
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
