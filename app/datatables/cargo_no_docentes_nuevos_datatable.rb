class CargoNoDocentesNuevosDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Persona.nro_documento', 'Persona.apellidos','CargoNoDocente.turno','CargoNoDocente.fecha_alta']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apellidos','CargoNoDocente.turno','CargoNoDocente.fecha_alta']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.apellidos,
        record.turno,
        Util.fecha_a_es(record.fecha_alta),
        '<button class="btn btn-'+record.estados.last.color_estado+' btn-xs pepe" data-toggle="modal" data-target="#modal_cargos_no_docentes" cargo-no-docente-id="'+record.id.to_s+'"><b>'+record.estados.last.mensaje_estado+'</b></button>',
        '<center><div class="btn-acciones"><a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Editar alta" href="'+Rails.application.routes.url_helpers.cargo_no_docentes_editar_alta_path(record.id.to_s)+'"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></a>'+
        '<a class="btn btn-success btn-sm btn-ajax" data-url="'+Rails.application.routes.url_helpers.cargo_no_docentes_notificar_path(record.id.to_s, :format => :json)+'" data-toggle="tooltip" data-placement="top" title="Notificar alta" "><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a></div></center>',
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end