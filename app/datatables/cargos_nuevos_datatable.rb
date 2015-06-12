class CargosNuevosDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['cargos.fecha_alta', 'Persona.nro_documento', 'Persona.apellidos']
  end

  def searchable_columns
    @searchable_columns ||= ['cargos.fecha_alta', 'Persona.nro_documento', 'Persona.apellidos']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.apellidos,
        record.situacion_revista,
        record.turno,
        record.anio,
        record.curso,
        Util.fecha_a_es(record.fecha_alta),
        '<button class="btn btn-'+record.estados.last.color_estado+' btn-xs" data-toggle="modal" data-target="#modal_altas" alta-id="'+record.id.to_s+'"><b>'+record.estados.last.mensaje_estado+'</b></button>',
        '<center><div class="btn-acciones"><a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Editar alta" href="'+Rails.application.routes.url_helpers.cargo_editar_alta_path(record.id.to_s)+'"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></a>'+
        '<a class="btn btn-success btn-sm btn-ajax" data-url="'+Rails.application.routes.url_helpers.cargo_notificar_path(record.id.to_s, :format => :json)+'" data-toggle="tooltip" data-placement="top" title="Notificar alta" "><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a></div></center>',
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end