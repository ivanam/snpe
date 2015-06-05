class AltasBajasHoraNotificadaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['altas_bajas_horas.id']
  end

  def searchable_columns
    @searchable_columns ||= ['altas_bajas_horas.id', 'AltasBajasHora.fecha_alta']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.apellidos,
        record.situacion_revista,
        record.horas,        
        record.ciclo_carrera,        
        record.anio,
        record.division,
        record.turno,
        record.codificacion,
        Util.fecha_a_es(record.fecha_alta),           
        '<button class="btn btn-'+record.estados.last.color_estado+' btn-xs pepe" data-toggle="modal" data-target="#modal_altas" alta-id="'+record.id.to_s+'"><b>'+record.estados.last.mensaje_estado+'</b></button>',
        if (options[:rol] == "escuela") then
          if record.estado_actual == "Notificado" then
            '<a class="cancelar_notificacion btn btn-sm btn-danger data-type="text" data-container="body" data-placement="left" data-original-title="Observaciones" data-resource="altas_bajas_hora" data-name="observaciones" data-url="'+Rails.application.routes.url_helpers.altas_bajas_horas_cancelar_path(record.id.to_s)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></a>'
          end
        else
          if record.estado_actual == "Notificado" then
            '<center><div class="btn-acciones">'+
              '<a class="cancelar_notificacion btn btn-sm btn-danger" data-type="text" data-container="body" data-placement="left" data-original-title="Observaciones" data-resource="altas_bajas_hora" data-name="observaciones" data-url="'+Rails.application.routes.url_helpers.altas_bajas_horas_cancelar_path(record.id.to_s)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></a>'+
              '<a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Editar notificación" href="'+Rails.application.routes.url_helpers.altas_bajas_horas_editar_alta_path(record.id.to_s)+'"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></a>' +
              '<a class="btn btn-success btn-sm btn-ajax" data-url="'+Rails.application.routes.url_helpers.altas_bajas_horas_chequear_path(record.id.to_s, :format => :json)+'" data-toggle="tooltip" data-placement="top" title="Marcar como chequeada"><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>' +
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