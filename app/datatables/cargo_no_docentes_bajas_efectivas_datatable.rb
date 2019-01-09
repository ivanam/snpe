class CargoNoDocentesBajasEfectivasDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['CargoNoDocente.id']
  end

  def searchable_columns
    @searchable_columns ||= ['CargoNoDocente.id', 'Establecimiento.cue', 'Establecimiento.codigo_jurisdiccional', 'Persona.nro_documento', 'Persona.apellidos', 'Persona.nombres', 'Persona.cuil']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.cuil,
        record.persona.to_s,
        record.secuencia,
        record.situacion_revista,
        record.establecimiento.codigo_jurisdiccional,
        record.establecimiento.cue,
        record.establecimiento.nombre,
        '<span class="label label-info">'+Util.fecha_a_es(record.fecha_alta)+'</span>',
        '<span class="label label-success">'+Util.fecha_a_es(record.fecha_baja)+'</span>',
        if record.estado_actual == "Notificado_Baja" then
          if options[:rol] == "escuela" then
          '<center><div class="btn-acciones">'+
            '<a class="btn btn-sm btn-danger btn-ajax" data-toggle="tooltip" data-placement="top" title="Cancelar baja" data-url="'+Rails.application.routes.url_helpers.cargo_no_docente_cancelar_baja_path(record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>'+
          '</div></center>'
          elsif options[:rol] == "personal" then
          '<center><div class="btn-acciones">'+
            '<a class="btn btn-success btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Marcar como chequeada" data-url="'+Rails.application.routes.url_helpers.cargo_no_docente_chequear_baja_path(record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>'+
          '</div></center>'
          elsif options[:rol] == "sadmin"
          '<center><div class="btn-acciones">'+
            '<a class="btn btn-sm btn-danger btn-ajax" data-url="'+Rails.application.routes.url_helpers.cargo_no_docente_cancelar_baja_path(record.id.to_s, :format => :json)+'" data-toggle="tooltip" data-placement="top" title="Cancelar baja" ><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>'+
            '<a class="btn btn-success btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Marcar como chequeada" data-url="'+Rails.application.routes.url_helpers.cargo_no_docente_chequear_baja_path(record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>'+
          '</div></center>'
          end
        else
          '<center><div class="btn-acciones">'+
            '<a class="btn btn-sm"><span class="label label-success">Chequeada</span></a>'+
          '</div></center>'
        end,
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
