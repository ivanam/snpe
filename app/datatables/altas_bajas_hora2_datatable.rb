class AltasBajasHora2Datatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Persona.nro_documento', 'Persona.apeynom','AltasBajasHora.situacion_revista','AltasBajasHora.horas','AltasBajasHora.ciclo_carrera','AltasBajasHora.anio',
    'AltasBajasHora.division', 'AltasBajasHora.turno','AltasBajasHora.codificacion', 'AltasBajasHora.fecha_alta', 'Persona.cuil', 'AltasBajasHora.estado']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apeynom','AltasBajasHora.situacion_revista','AltasBajasHora.horas','AltasBajasHora.ciclo_carrera','AltasBajasHora.anio',
    'AltasBajasHora.division', 'AltasBajasHora.turno','AltasBajasHora.codificacion', 'AltasBajasHora.fecha_alta', 'Persona.cuil', 'AltasBajasHora.estado']
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
        record.horas,   
        if  record.ciclo_carrera.to_s == "60" then
         '<a style="color:red">''</a>'
        elsif record.ciclo_carrera.to_s == "" then
          if record.plan_id.to_s == "" then
          '<a style="color:red">''</a>'
          elsif record.plan_id.to_s != "" then
            '<a style="color:red">'+Plan.where(id: record.plan_id).first.codigo.to_s+'</a>'
          end
        elsif record.ciclo_carrera.to_s != "" then
             '<a style="color:red">'+ record.ciclo_carrera.to_s+ '</a>'         
        end,
        '<a style="color:red">'+record.anio.to_s+'</a>',
        '<a style="color:red">'+record.division.to_s+'</a>',
        '<a style="color:red">'+record.turno.to_s+'</a>',
        '<a style="color:red">'+record.codificacion.to_s+'</a>',   
        '<a style="color:red">'+record.estado+'</a>',
        Util.fecha_a_es(record.fecha_alta),
        Util.fecha_a_es(record.fecha_baja),
        #'<a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Ver" href="/soft/snpe/altas_bajas_horas/'+record.id.to_s+'"><strong>Ver</strong></a>',
        '<a class="btn btn-success btn-sm" data-toggle="tooltip" data-placement="top" onclicK=editar('+record.id.to_s+') title="Editar"><strong>Editar</strong></a>',
        if record.estado.to_s == "LIC" then
        '<a class="btn btn-danger btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Lic/Baja" data-url="/soft/snpe/altas_bajas_horas/guardar_edicion3/?id_lic='+record.id.to_s+'"><strong>Lic/Baja</strong></a>'
        end
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