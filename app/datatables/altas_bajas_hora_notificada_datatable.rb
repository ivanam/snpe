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
        if (options[:rol] == "escuela") then
          if record.estado_actual == "Chequeado" then
            '<a class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="top" title="Cancelar notificación" href="'+Rails.application.routes.url_helpers.altas_bajas_horas_cancelar_path(record.id.to_s)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>' +
            '<span class="label label-success">Aceptado por personal</span>'
          elsif record.estado_actual == "Impreso" then
            '<span class="label label-success">Pasado a sueldo</span>'
          else
            '<span class="label label-warning">Esperando aprobación</span>'
          end
        else
          if record.estado_actual == "Chequeado" then
            '<center><span class="label label-success">Aceptado por personal</span></center>'
          elsif record.estado_actual == "Impreso" then
            '<center><span class="label label-success">Pasado a sueldo</span><center>'
          else
            '<center><div class="btn-acciones">'+
              '<a class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="top" title="Cancelar notificación" href="'+Rails.application.routes.url_helpers.altas_bajas_horas_cancelar_path(record.id.to_s)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>' +
              '<a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Editar notificación" href="'+Rails.application.routes.url_helpers.altas_bajas_horas_editar_alta_path(record.id.to_s)+'"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></a>' +
              '<a class="btn btn-success btn-sm" data-toggle="tooltip" data-placement="top" title="Marcar como chequeada" href="'+Rails.application.routes.url_helpers.altas_bajas_horas_chequear_path(record.id.to_s)+'"><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>' +
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