class HorasNovedadesDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Persona.nro_documento', 'Persona.apellidos','AltasBajasHora.situacion_revista','AltasBajasHora.horas','AltasBajasHora.ciclo_carrera','AltasBajasHora.anio',
    'AltasBajasHora.division', 'AltasBajasHora.turno','AltasBajasHora.codificacion', 'AltasBajasHora.oblig', 'AltasBajasHora.fecha_alta']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apellidos','AltasBajasHora.situacion_revista','AltasBajasHora.horas','AltasBajasHora.ciclo_carrera','AltasBajasHora.anio',
    'AltasBajasHora.division', 'AltasBajasHora.turno','AltasBajasHora.codificacion', 'AltasBajasHora.oblig', 'AltasBajasHora.fecha_alta']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.apellidos + " " + record.persona.nombres.to_s,
        record.situacion_revista,
        record.horas,        
        record.ciclo_carrera,        
        record.anio,
        record.division,
        record.turno,
        Materium.find(record.materia_id).codigo.to_s.rjust(AltasBajasHora::LONGITUD_CODIGO,'0'),                
        record.oblig,
        Util.fecha_a_es(record.fecha_alta),
        '<button class="btn btn-'+record.estados.last.color_estado+' btn-xs pepe" data-toggle="modal" data-target="#modal_novedades" alta-id="'+record.id.to_s+'"><b>'+record.estados.last.mensaje_estado+'</b></button>',
        if options[:tipo_tabla] == "novedades" then
          if (record.estado_actual != "Impreso") then
            '<a class="btn btn-primary btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Pasar a cola de impresión" data-url="'+Rails.application.routes.url_helpers.altas_bajas_horas_imprimir_path(record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-print" aria-hidden="true" ></span></a>'
          end
        else
          '<a class="btn btn-danger btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Cancelar impresión" data-url="'+Rails.application.routes.url_helpers.horas_cancelar_cola_path(id: record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>'
        end,
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end

#en cola de impresion: relacionado con lote y ese lote no tiene fecha de impresion
#impreso: estado impreso y ademas lote de impresion tiene fecha
