class AltasBajasHoraDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= [ 'Persona.nro_documento', 'Persona.apeynom','AltasBajasHora.fecha_alta','AltasBajasHora.fecha_baja','AltasBajasHora.situacion_revista','Establecimiento.localidad_id','AltasBajasHora.horas','AltasBajasHora.ciclo_carrera','AltasBajasHora.anio',
    'AltasBajasHora.division', 'AltasBajasHora.turno','AltasBajasHora.codificacion', ]
  end

  def searchable_columns
    @searchable_columns ||= [ 'Persona.nro_documento', 'Persona.apeynom','AltasBajasHora.fecha_alta','AltasBajasHora.fecha_baja','AltasBajasHora.situacion_revista','Establecimiento.localidad_id','AltasBajasHora.horas','AltasBajasHora.ciclo_carrera','AltasBajasHora.anio',
    'AltasBajasHora.division', 'AltasBajasHora.turno','AltasBajasHora.codificacion', ]
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento.to_s+' / '+record.persona.cuil.to_s,
        record.persona.to_s,
        Util.fecha_a_es(record.fecha_alta),
        Util.fecha_a_es(record.fecha_baja),
        record.situacion_revista,
        record.establecimiento.localidad.to_s,
        record.horas,        
        record.plan.to_s,        
        record.anio,
        record.division,
        record.turno,
        record.materium.codigo.to_s.rjust(AltasBajasHora::LONGITUD_CODIGO,'0'),        
        '<button class="btn btn-'+record.estados.last.color_estado+' btn-xs" data-toggle="modal" data-target="#modal_altas" alta-id="'+record.id.to_s+'"><b>'+record.estados.last.mensaje_estado+'</b></button>',
        '<center><div class="btn-acciones"><a class="btn btn-danger btn-sm" rel="nofollow" data-method="delete" data-confirm="Seguro desea eliminar?" role="menuitem" tabindex="-1" href="altas_bajas_horas/'+record.id.to_s+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>'+
        '<a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Editar alta" href="'+Rails.application.routes.url_helpers.altas_bajas_horas_editar_alta_path(record.id.to_s)+'"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></a>'+
        '<button class="btn btn-success btn-sm btn-ajax-realizadas" data-url="'+Rails.application.routes.url_helpers.altas_bajas_horas_notificar_path(record.id.to_s, :format => :json)+'" data-toggle="tooltip" data-placement="top" title="Notificar alta" "><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></button></div></center>',
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

  

end


      #    <% link_to '#new_servicio_modal', 'data-toggle'=>"tooltip", 'data-placement'=>"top", 'title'=>"Nuevo servicio", 'data-toggle' => 'modal', 'cant_horas' => p.asignatura_plan_estudio.horas, 'data-id' => p.id, 'fecha_desde' => p.fecha_desde_fun, 'fecha_hasta' => p.fecha_hasta_fun, :class => 'btn btn-sm btn-success' do %>
       #     <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
        #  <% end %>
