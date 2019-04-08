class CargosNovedadesDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Establecimiento.codigo_jurisdiccional', 'Persona.nro_documento', 'Persona.apeynom', 'Cargo.situacion_revista','Cargo.turno','Cargo.anio','Cargo.division','Cargo.fecha_alta']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apeynom', 'Cargo.situacion_revista','Cargo.turno','Cargo.anio','Cargo.division','Cargo.fecha_alta']
  end

  private

  def data
    records.map do |record|
      [
        record.establecimiento.to_s,
        record.persona.to_s,
        record.situacion_revista,
        Funcion.where(categoria: record.cargo).first.to_s,
        record.turno,
        record.anio,
        record.division,
        Util.fecha_a_es(record.fecha_alta),
        Util.fecha_a_es(record.fecha_baja),
        record.observaciones,
        '<button class="btn btn-'+record.estados.last.color_estado+' btn-xs pepe" data-toggle="modal" data-target="#modal_novedades" alta-id="'+record.id.to_s+'"><b>'+record.estados.last.mensaje_estado+'</b></button>',
        if options[:tipo_tabla] == "novedades" then
          if (record.estado_actual != "Impreso" and record.estado_actual != "Cobrado") then
            '<a class="btn btn-primary btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Pasar a cola de impresión" data-url="'+Rails.application.routes.url_helpers.cargo_imprimir_path(record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-print" aria-hidden="true" ></span></a>'
          end
        else
          '<a class="btn btn-danger btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Cancelar impresión" data-url="'+Rails.application.routes.url_helpers.cargo_cancelar_cola_path(id: record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>'
        end,
        if record.estado.to_s == "LIC" then
        '<a class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="top" onclicK=licbaj('+record.id.to_s+') title="Lic/Baja"><strong>Lic/Baja</strong></a>'
        end
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end