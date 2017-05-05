class AltasBajasHoraAsistenciaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Persona.nro_documento', 'Persona.apeynom', 'AltasBajasHora.anio', 'AltasBajasHora.division', 'AltasBajasHora.codificacion']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apeynom', 'AltasBajasHora.anio', 'AltasBajasHora.division', 'AltasBajasHora.codificacion']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.to_s,
        record.anio.to_s + '/' + record.division.to_s,
        record.codificacion.to_s.rjust(AltasBajasHora::LONGITUD_CODIGO,'0'),        
        '<span class="oblig" data-type="text" data-resource="post" data-name="ina_injustificada" data-url="'+Rails.application.routes.url_helpers.asistencia_editar_asistencia_path(record.id.to_s, anio: options[:anio], mes: options[:mes])+'">'+record.ina_injustificada(options[:anio], options[:mes])+'</span>',
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
