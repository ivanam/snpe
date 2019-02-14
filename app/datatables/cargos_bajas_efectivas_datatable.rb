class CargosBajasEfectivasDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Persona.nro_documento', 'Persona.cuil', 'Persona.apeynom','Cargo.secuencia', 'Cargo.cargo', 'Cargo.turno', 'Cargo.anio','Cargo.division', 'Cargo.grupo_id', 'Cargo.fecha_alta', 'Cargo.fecha_baja']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.cuil', 'Persona.apeynom','Cargo.secuencia', 'Cargo.cargo', 'Cargo.turno', 'Cargo.anio','Cargo.division']
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
        record.cargo,
        record.turno,
        record.anio,
        record.division,
        record.grupo_id,
        '<button class="btn btn-'+record.estados.last.color_estado+' btn-xs pepe" data-toggle="modal" data-target="#modal_bajas_efectivas" cargo-id="'+record.id.to_s+'"><b>'+record.estados.last.mensaje_estado+'</b></button>',
        '<span class="label label-info">'+Util.fecha_a_es(record.fecha_alta)+'</span>',
        '<span class="label label-success">'+Util.fecha_a_es(record.fecha_baja)+'</span>',
        if record.estado_actual == "Notificado_Baja" then
          if options[:rol] == "escuela" then
          '<center><div class="btn-acciones">'+
            '<a class="btn btn-sm btn-danger btn-ajax" data-toggle="tooltip" data-placement="top" title="Cancelar baja" data-url="'+Rails.application.routes.url_helpers.cargo_cancelar_baja_path(record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>'+
          '</div></center>'
          elsif options[:rol] == "personal" then
          '<center><div class="btn-acciones">'+
            '<a class="btn btn-success btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Marcar como chequeada" data-url="'+Rails.application.routes.url_helpers.cargo_chequear_baja_path(record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>'+
          '</div></center>'
          elsif options[:rol] == "sadmin"
          '<center><div class="btn-acciones">'+
            '<a class="btn btn-sm btn-danger btn-ajax" data-url="'+Rails.application.routes.url_helpers.cargo_cancelar_baja_path(record.id.to_s, :format => :json)+'" data-toggle="tooltip" data-placement="top" title="Cancelar baja" ><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>'+
            '<a class="btn btn-success btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Marcar como chequeada" data-url="'+Rails.application.routes.url_helpers.cargo_chequear_baja_path(record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>'+
          '</div></center>'
          end
        else
          '<button class="btn btn-'+record.estados.last.color_estado+' btn-xs pepe" data-toggle="modal" data-target="#modal_novedades" alta-id="'+record.id.to_s+'"><b>'+record.estados.last.mensaje_estado+'</b></button>'
        end,
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
