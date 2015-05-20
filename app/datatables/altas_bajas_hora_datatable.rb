class AltasBajasHoraDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['altas_bajas_horas.id']
  end

  def searchable_columns
    @searchable_columns ||= ['AltasBajasHora.fecha_alta', 'Persona.nro_documento', 'Persona.apellidos', 'Persona.nombres']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.nombres,
        record.persona.apellidos,
        record.situacion_revista,
        record.horas,        
        record.ciclo_carrera,        
        record.anio,
        record.division,
        record.turno,
        record.codificacion,
        record.oblig,
        Util.fecha_a_es(record.fecha_alta),
        '<a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Editar alta" href="'+Rails.application.routes.url_helpers.altas_bajas_horas_editar_alta_path(record.id.to_s)+'"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></a>'+
        '<a class="btn btn-success btn-sm" data-toggle="tooltip" data-placement="top" title="Notificar alta" href="'+Rails.application.routes.url_helpers.altas_bajas_horas_notificar_path(record.id.to_s)+'"><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>',
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end

# => '<a class="btn btn-default" onClick="editar_alta('+record.id.to_s+')"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></a>'