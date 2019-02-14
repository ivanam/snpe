class AltasBajasHoraBajaPermitidaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Persona.apeynom','AltasBajasHora.secuencia', 'AltasBajasHora.turno', 'AltasBajasHora.anio','AltasBajasHora.division','AltasBajasHora.fecha_alta']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento','Persona.cuil', 'Persona.apeynom','AltasBajasHora.secuencia']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.to_s + ' -- ' + record.persona.cuil.to_s,
        record.secuencia,
        record.turno,
        record.anio,
        record.division,
        record.plan_materia,
        '<span class="label label-info">'+Util.fecha_a_es(record.fecha_alta)+'</span>',
        record.horas,
        '<center><div class="btn-acciones"><a class="btn btn-danger btn-sm" data-toggle="modal" id_horas="'+record.id.to_s+'" motivo_baja="'+record.motivo_baja.to_s+'" data-target="#modal_baja_horas" title="Editar" >
        <span class="glyphicon glyphicon-trash"></span>
        <span class=aria-hidden="true" >Baja</span></a>',
      ]
    end
  end


  def get_raw_records
    #return AltasBajasHora.all.includes(:establecimiento, :persona)
    return options[:query]
  end

end
