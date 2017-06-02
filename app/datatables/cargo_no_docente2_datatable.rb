class CargoNoDocente2Datatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
     @sortable_columns ||= ['Persona.nro_documento', 'Persona.apeynom', 'CargoNoDocente.situacion_revista', 'CargoNoDocente.turno','CargoNoDocente.fecha_alta', 'Persona.cuil', 'CargoNoDocente.estado']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apeynom', 'CargoNoDocente.situacion_revista', 'CargoNoDocente.turno','CargoNoDocente.fecha_alta', 'Persona.cuil', 'CargoNoDocente.estado']
  end

  private

  def data 
    records.map do |record|
      [ 

        record.persona.nro_documento,
        record.persona.cuil,
        record.persona.to_s,
        record.secuencia,
        Cargosnd.where(id: record.cargo).first.to_s,
        record.situacion_revista, 
        '<a style="color:red">'+record.turno.to_s+'</a>', 
        '<a style="color:red">'+record.estado+'</a>',
        record.resolucion,
        record.decreto,
        Util.fecha_a_es(record.fecha_alta),
        Util.fecha_a_es(record.fecha_baja),
        '<a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Ver" href="/soft/snpe/cargo_no_docentes/'+record.id.to_s+'"><strong>Ver</strong></a>',
        '<a class="btn btn-success btn-sm" data-toggle="tooltip" data-placement="top" onclicK=editar('+record.id.to_s+') title="Editar"><strong>Editar</strong></a>',


      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
