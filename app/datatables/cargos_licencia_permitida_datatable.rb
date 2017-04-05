class CargosLicenciaPermitidaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Cargo.secuencia', 'Establecimiento.codigo_jurisdiccional', 'Establecimiento.cue','Establecimiento.nombre','Cargo.anio', 'Cargo.division', 'Cargo.observaciones', 'Cargo.fecha_alta']
  end

  def searchable_columns
    @searchable_columns ||= ['Cargo.secuencia', 'Establecimiento.codigo_jurisdiccional', 'Establecimiento.cue','Establecimiento.nombre','Cargo.anio', 'Cargo.division', 'Cargo.observaciones', 'Cargo.fecha_alta']
  end

  private

  def data
    records.map do |record|
      [
        record.establecimiento.codigo_jurisdiccional.to_s + ' ' +  record.establecimiento.nombre,
        Funcion.where(categoria: record.cargo).first.to_s,
        record.turno.to_s,
        record.anio,
        record.division,
        record.observaciones,
        '<span class="label label-info">'+Util.fecha_a_es(record.fecha_alta)+'</span>',
          '<center><div class="btn-acciones"><a class="btn btn-success btn-sm" data-toggle="modal"  id_cargos="'+record.id.to_s+'" data-target="#modal_licencia_cargos" title="Editar" ><span class=aria-hidden="true" >Licenciar</span></a>', 
   
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
