class CargosDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
     @sortable_columns ||= ['Persona.nro_documento', 'Persona.apeynom','Cargo.situacion_revista','Cargo.anio', 'Cargo.division', 'Cargo.turno', 'Cargo.fecha_alta', 'Persona.cuil', 'Cargo.estado']
 
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apeynom','Cargo.situacion_revista','Cargo.anio', 'Cargo.division', 'Cargo.turno', 'Cargo.fecha_alta', 'Persona.cuil', 'Cargo.estado']
  end

  private

  def data 
    records.map do |record|
      [ 

        record.persona.nro_documento,
        record.persona.cuil,
        record.persona.to_s,
        record.secuencia,
        Funcion.where(categoria: record.cargo).first.to_s,
        record.situacion_revista,  
        '<a style="color:red">'+record.anio.to_s+'</a>',
        '<a style="color:red">'+record.division.to_s+'</a>',
        '<a style="color:red">'+record.turno.to_s+'</a>', 
        '<a style="color:red">'+record.estado+'</a>',
        Util.fecha_a_es(record.fecha_alta),
        '<a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Ver" href="/soft/snpe/cargos/'+record.id.to_s+'"><strong>Ver</strong></a>',
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