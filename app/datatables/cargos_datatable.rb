class CargosDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
     @sortable_columns ||= ['Persona.nro_documento', 'Persona.apeynom','Cargo.situacion_revista','Cargo.horas', 'Cargo.anio',
     'Cargo.division', 'Cargo.turno']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apeynom', 'Cargo.situacion_revista','Cargo.horas','Cargo.anio',
    'Cargo.division', 'Cargo.turno']
  end

  private

  def data 
    records.map do |record|
      [ 

        record.persona.nro_documento,
        record.persona.to_s,
        record.situacion_revista,     
        '<span style="color:red" class="anio" data-type="text" data-resource="post" data-name="anio" data-url="'+Rails.application.routes.url_helpers.cargo_editar_campos_path(:id => record.id.to_s)+'">'+record.anio.to_s+'</span>',
        '<span style="color:red" class="division" data-type="text" data-resource="post" data-name="division" data-url="'+Rails.application.routes.url_helpers.cargo_editar_campos_path(:id => record.id.to_s)+'">'+record.division.to_s+'</span>',
        '<span style="color:red" class="codificacion solo_numerico" maxlength="8" data-type="text" data-resource="post" data-name="codificacion" data-url="'+Rails.application.routes.url_helpers.cargo_editar_campos_path(:id => record.id.to_s)+'">'+record.materium_id.to_s+'</span>',   
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