class AltasBajasHoraDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['altas_bajas_horas.id']
  end

  def searchable_columns
    @searchable_columns ||= ['altas_bajas_horas.id', 'AltasBajasHora.fecha_alta']
  end

  private

  def data
    records.map do |record|
      [
        record.establecimiento.codigo_jurisdiccional,
        record.persona.nro_documento,
        record.persona.nombres + " " + record.persona.apellidos,        
        record.anio,
        record.division,
        record.ciclo_carrera,
        Util.fecha_a_es(record.fecha_alta),
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
