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
        record.situacion_revista,
        record.horas,    
        record.ciclo_carrera,     
        '<span style="color:red" class="anio" data-type="text" data-resource="put" data-name="anio" data-url="'+Rails.application.routes.url_helpers.altas_bajas_horas_editar_campos_path(:id => record.id.to_s)+'">'+record.anio.to_s+'</span>',
        '<span style="color:red" class="division" data-type="text" data-resource="put" data-name="division" data-url="'+Rails.application.routes.url_helpers.altas_bajas_horas_editar_campos_path(:id => record.id.to_s)+'">'+record.division.to_s+'</span>',
        '<span style="color:red" class="turno" data-type="text" data-resource="put" data-name="turno" data-url="'+Rails.application.routes.url_helpers.altas_bajas_horas_editar_campos_path(:id => record.id.to_s)+'">'+record.turno.to_s+'</span>',
        '<span style="color:red" class="codificacion form-control form-alta form-select solo_numerico" min="1" max="6" data-type="number" data-resource="put" data-name="codificacion" data-url="'+Rails.application.routes.url_helpers.altas_bajas_horas_editar_campos_path(:id => record.id.to_s)+'">'+record.codificacion.to_s+'</span>',   
        record.oblig,
        Util.fecha_a_es(record.fecha_alta),


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