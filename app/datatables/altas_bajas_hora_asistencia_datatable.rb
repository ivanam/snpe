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
        record.persona.nombres.to_s + " " + record.persona.apellidos.to_s,
        record.anio.to_s + '/' + record.division.to_s,
        record.codificacion,
        '<span class="ina_injustificada" data-type="text" data-resource="post" data-name="ina_injustificada" data-url="'+Rails.application.routes.url_helpers.asistencia_editar_asistencia_path(record.id.to_s, anio: options[:anio], mes: options[:mes])+'">'+record.ina_injustificada(options[:anio], options[:mes])+'</span>',
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
