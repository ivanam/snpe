class AltasBajasHoraLicenciaPermitidaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['AltasBajasHora.fecha_alta', 'Persona.nro_documento']
  end

  def searchable_columns
    @searchable_columns ||= ['AltasBajasHora.id', 'Establecimiento.cue', 'Establecimiento.codigo_jurisdiccional', 'Persona.nro_documento', 'Persona.apellidos', 'Persona.nombres', 'Persona.cuil']
  end

  private

  def data
    records.map do |record|
      [
        record.secuencia,
        record.establecimiento.codigo_jurisdiccional,
        record.establecimiento.cue,
        record.establecimiento.nombre,
        record.anio,
        record.division,
        record.observaciones,
        '<span class="label label-info">'+Util.fecha_a_es(record.fecha_alta)+'</span>',
        '<center><div class="btn-acciones"><a class="btn btn-success btn-sm" data-toggle="modal"  id_horas="'+record.id.to_s+'" data-target="#dias" title="Editar" ><span class=aria-hidden="true" >Licenciar</span></a>', 
          
      ]
    end
  end


  def get_raw_records
    #return AltasBajasHora.all.includes(:establecimiento, :persona)
    return options[:query]
  end
  
  def sort_records(records)
    records
  end

end