class CargoNoDocenteAsistenciaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['cargo_no_docentes.id']
  end

  def searchable_columns
    @searchable_columns ||= ['cargo_no_docentes.id']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.apeynom,
        # '<span class="ina_injustificada" data-type="text" data-resource="post" data-name="ina_injustificada" data-url="'+Rails.application.routes.url_helpers.asistencia_editar_asistencia_cargo_no_docente_path(record.id.to_s, anio: options[:anio], mes: options[:mes])+'">'+record.ina_injustificadas(options[:anio], options[:mes])+'</span>',
        ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
