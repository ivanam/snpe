class AltasBajasHoraAsistenciaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['altas_bajas_horas.id']
  end

  def searchable_columns
    @searchable_columns ||= ['altas_bajas_horas.id']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.apellidos,
        record.anio.to_s + '/' + record.division.to_s,
        record.codificacion,
        record.ina_justificada(1),
        record.ina_justificada(1),
        record.ina_justificada(1),
        record.ina_justificada(1),
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
