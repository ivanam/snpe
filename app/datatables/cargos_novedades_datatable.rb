class CargosNovedadesDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['cargos.id']
  end

  def searchable_columns
    @searchable_columns ||= ['cargos.id', 'Cargo.fecha_alta']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.apellidos + " " + record.persona.nombres.to_s,
        record.situacion_revista,
        record.turno,
        record.anio,
        record.division,
        Util.fecha_a_es(record.fecha_alta),
        '<button class="btn btn-'+record.estados.last.color_estado+' btn-xs pepe" data-toggle="modal" data-target="#modal_novedades" alta-id="'+record.id.to_s+'"><b>'+record.estados.last.mensaje_estado+'</b></button>',
        if options[:tipo_tabla] == "novedades" then
          if (record.estado_actual != "Impreso") then
            '<a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Pasar a cola de impresión" href="'+Rails.application.routes.url_helpers.cargo_imprimir_path(record.id.to_s)+'"><span class="glyphicon glyphicon-print" aria-hidden="true" ></span></a>'
          end
        else
          '<a class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="top" title="Cancelar impresión" href="'+Rails.application.routes.url_helpers.cargo_cancelar_cola_path(id: record.id.to_s)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>'
        end,
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end