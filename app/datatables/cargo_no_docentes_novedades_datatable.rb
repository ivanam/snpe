class CargoNoDocentesNovedadesDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Persona.nro_documento', 'Persona.apeynom','CargoNoDocente.turno','CargoNoDocente.fecha_alta']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apeynom','CargoNoDocente.turno','CargoNoDocente.fecha_alta']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.to_s,
        record.turno,
        Util.fecha_a_es(record.fecha_alta),
        '<button class="btn btn-'+record.estados.last.color_estado+' btn-xs pepe" data-toggle="modal" data-target="#modal_cargos_no_docentes" cargo-no-docente-id="'+record.id.to_s+'"><b>'+record.estados.last.mensaje_estado+'</b></button>',
        if options[:tipo_tabla] == "novedades" then
          if (record.estado_actual != "Impreso") then
            '<a class="btn btn-primary btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Pasar a cola de impresión" data-url="'+Rails.application.routes.url_helpers.cargo_no_docentes_imprimir_path(record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-print" aria-hidden="true" ></span></a>'
          end
        else
          '<a class="btn btn-danger btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Cancelar impresión" data-url="'+Rails.application.routes.url_helpers.cargo_no_docentes_cancelar_cola_path(id: record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>'
        end,
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end