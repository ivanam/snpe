class CargoNoDocentesLicenciaPermitidaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  # def sortable_columns
  #   @sortable_columns ||= ['CargoNoDocente.secuencia', 'Establecimiento.codigo_jurisdiccional', 'Establecimiento.cue','Establecimiento.nombre', 'CargoNoDocente.observaciones', 'CargoNoDocente.fecha_alta']
  # end

  # def searchable_columns
  #   @searchable_columns ||= ['CargoNoDocente.secuencia', 'Establecimiento.codigo_jurisdiccional', 'Establecimiento.cue','Establecimiento.nombre', 'CargoNoDocente.observaciones', 'CargoNoDocente.fecha_alta']
  # end

  private

  def data
    records.map do |record|
      [
        record.secuencia,
        record.establecimiento.codigo_jurisdiccional,
        record.establecimiento.nombre,
        record.observaciones,
        '<span class="label label-info">'+Util.fecha_a_es(record.fecha_alta)+'</span>',
          '<center><div class="btn-acciones"><a class="btn btn-success btn-sm" data-toggle="modal"  id_cargo_no_docentes="'+record.id.to_s+'" data-target="#modal_licencia_cargos_no_docentes" title="Editar" ><span class=aria-hidden="true" >Licenciar</span></a>', 
   
      ]
    end
  end


  def get_raw_records
    return options[:query]
  end
  
  def sort_records(records)
    records
  end

end