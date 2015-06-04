class AltasBajasHoraBajaEfectivaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['AltasBajasHora.id']
  end

  def searchable_columns
    @searchable_columns ||= ['AltasBajasHora.id', 'Establecimiento.cue', 'Establecimiento.codigo_jurisdiccional', 'Persona.nro_documento', 'Persona.apellidos', 'Persona.nombres', 'Persona.cuil']
  end

  private

  def data
    records.map do |record|
      [
        record.establecimiento.codigo_jurisdiccional,
        record.establecimiento.cue,
        record.persona.nro_documento,
        record.persona.apellidos,
        record.persona.nombres,
        record.persona.cuil,
        '<span class="label label-info">'+Util.fecha_a_es(record.fecha_alta)+'</span>',
        '<span class="label label-success">'+Util.fecha_a_es(record.fecha_baja)+'</span>',
        if record.estado_actual == "Notificado_Baja" then
          '<center><div class="btn-acciones">'+
            '<a class="btn btn-sm btn-danger" data-toggle="tooltip" data-placement="top" title="Cancelar baja" href="'+Rails.application.routes.url_helpers.altas_bajas_horas_cancelar_baja_path(record.id.to_s)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>'+
            '<a class="btn btn-success btn-sm" data-toggle="tooltip" data-placement="top" title="Marcar como chequeada" href="'+Rails.application.routes.url_helpers.altas_bajas_horas_chequear_baja_path(record.id.to_s)+'"><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>'+
          '</div></center>'
        else
          debugger
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
