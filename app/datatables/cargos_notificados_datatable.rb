class CargosNotificadosDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Persona.nro_documento', 'Persona.apeynom','Cargo.situacion_revista','Cargo.turno','Cargo.anio','Cargo.division','Cargo.fecha_alta']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apeynom','Cargo.situacion_revista','Cargo.turno','Cargo.anio','Cargo.division','Cargo.fecha_alta']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.to_s,
        record.situacion_revista,
        Funcion.where(categoria: record.cargo).first.to_s,
        record.turno,        
        record.anio.to_s + "/" + record.division.to_s,
        record.grupo_id,
        Util.fecha_a_es(record.fecha_alta),           
        Util.fecha_a_es(record.fecha_baja),           
        '<button class="btn btn-'+record.estados.last.color_estado+' btn-xs pepe" data-toggle="modal" data-target="#modal_cargos" cargo-id="'+record.id.to_s+'"><b>'+record.estados.last.mensaje_estado+'</b></button>',
        if (options[:rol] == "escuela") then
          if record.estado_actual == "Notificado" then
            '<a class="cancelar_notificacion btn btn-sm btn-danger data-type="text" data-container="body" data-placement="left" data-original-title="Observaciones" data-resource="cargo" data-name="observaciones" data-url="'+Rails.application.routes.url_helpers.cargo_cancelar_path(record.id.to_s)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></a>'
          end
        else
          if record.estado_actual == "Notificado" then
            '<center><div class="btn-acciones">'+
              '<a class="cancelar_notificacion btn btn-sm btn-danger" data-type="text" data-container="body" data-placement="left" data-original-title="Observaciones" data-resource="cargo" data-name="observaciones" data-url="'+Rails.application.routes.url_helpers.cargo_cancelar_path(record.id.to_s)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></a>'+
              '<a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Editar notificación" href="'+Rails.application.routes.url_helpers.cargo_editar_alta_path(record.id.to_s)+'"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></a>' +
              '<a class="btn btn-success btn-sm btn-ajax-realizadas" data-url="'+Rails.application.routes.url_helpers.cargo_chequear_path(record.id.to_s, :format => :json)+'" data-toggle="tooltip" data-placement="top" title="Marcar como chequeada"><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>' +
            '</div></center'
          end
        end,
      ]
    end
  end

  def get_raw_records    
    return options[:query]
  end


end