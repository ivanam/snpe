class CargoNoDocente2Datatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
     @sortable_columns ||= ['Persona.nro_documento', 'Persona.apeynom','CargoNoDocente.situacion_revista','CargoNoDocente.division', 'CargoNoDocente.turno']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apeynom', 'CargoNoDocente.situacion_revista','CargoNoDocente.division', 'CargoNoDocente.turno']
  end

  private

  def data 
    records.map do |record|
      [ 

        record.persona.nro_documento,
        record.persona.to_s,
        record.secuencia,
        record.cargo.to_s,
        record.situacion_revista, 
        record.turno,  
        record.estado,
        Util.fecha_a_es(record.fecha_alta),
        '<a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Ver" href="/soft/snpe/cargos_no_docentes/'+record.id.to_s+'"><strong>Ver</strong></a>',
        '<a class="btn btn-success btn-sm" data-toggle="tooltip" data-placement="top" onclicK=editar('+record.id.to_s+') title="Editar"><strong>Editar</strong></a>',


      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
