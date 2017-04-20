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
        record.turno,  
        record.estado,
        record.resolucion,
        record.decreto,
        Util.fecha_a_es(record.fecha_alta),
        '<a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Ver" href="/soft/snpe/cargo_no_docentes/'+record.id.to_s+'"><strong>Ver</strong></a>',
        '<center><div class="btn-acciones"><a class="btn btn-danger btn-sm" rel="nofollow" data-method="delete" data-confirm="Seguro desea eliminar?" role="menuitem" tabindex="-1" href="cargo_no_docentes/'+record.id.to_s+'"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>'+
        '<a class="btn btn-success btn-sm" data-toggle="tooltip" data-placement="top" onclicK=editar('+record.id.to_s+') title="Editar"><strong>Editar</strong></a>',


      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
