class CargoNoDocenteAsistenciaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Persona.nro_documento', 'Persona.apeynom']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apeynom']

  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento.to_s + " -- " + record.persona.apeynom,
        Cargosnd.find(record.cargo).to_s,
        '<span class="ina_injustificada" data-type="text" data-resource="post" data-name="ina_injustificada" data-url="'+Rails.application.routes.url_helpers.asistencia_editar_asistencia_cargo_no_docente_path(record.id.to_s, anio: options[:anio], mes: options[:mes])+'">'+record.ina_injustificada(options[:anio], options[:mes])+'</span>',
        '<span class="licencia_d" data-type="text" data-resource="post" data-name="licencia_d" data-url="'+Rails.application.routes.url_helpers.asistencia_editar_asistencia_cargo_no_docente_path(record.id.to_s, anio: options[:anio], mes: options[:mes])+'">'+record.licencia_d(options[:anio], options[:mes])+'</span>',
        '<span class="paro" data-type="text" data-resource="post" data-name="paro" data-url="'+Rails.application.routes.url_helpers.asistencia_editar_asistencia_cargo_no_docente_path(record.id.to_s, anio: options[:anio], mes: options[:mes])+'">'+record.paro(options[:anio], options[:mes])+'</span>',
        '<span class="observaciones" data-type="text" data-resource="post" data-name="observaciones" data-url="'+Rails.application.routes.url_helpers.asistencia_editar_asistencia_cargo_no_docente_path(record.id.to_s, anio: options[:anio], mes: options[:mes])+'">'+record.observaciones(options[:anio], options[:mes])+'</span>',
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
