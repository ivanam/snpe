class AltasBajasHora2Datatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Persona.nro_documento', 'Persona.apellidos','AltasBajasHora.situacion_revista','AltasBajasHora.horas','AltasBajasHora.ciclo_carrera','AltasBajasHora.anio',
    'AltasBajasHora.division', 'AltasBajasHora.turno','AltasBajasHora.codificacion', 'AltasBajasHora.fecha_alta']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apellidos','AltasBajasHora.situacion_revista','AltasBajasHora.horas','AltasBajasHora.ciclo_carrera','AltasBajasHora.anio',
    'AltasBajasHora.division', 'AltasBajasHora.turno','AltasBajasHora.codificacion', 'AltasBajasHora.fecha_alta']
  end

  private

  def data
    records.map do |record|
      [ 

        record.persona.nro_documento,
        record.persona.to_s,
        record.secuencia,
        record.situacion_revista,
        record.horas,    
        record.ciclo_carrera,     
        record.anio,
        record.division,
        record.turno,
        record.codificacion,   
        record.estado,
        Util.fecha_a_es(record.fecha_alta),
        '<a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Ver" href="/soft/snpe/altas_bajas_horas/'+record.id.to_s+'+"><strong>Ver</strong></a>',
        '<a class="btn btn-success btn-sm" data-toggle="tooltip" data-placement="top" onclicK=editar('+record.id.to_s+') title="Editar"><strong>Editar</strong></a>',


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