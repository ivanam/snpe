class AltasBajasHoraBajaEfectivaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['AltasBajasHora.id']
  end

  def searchable_columns
    @searchable_columns ||= ['AltasBajasHora.id', 'Establecimiento.cue', 'Establecimiento.codigo_jurisdiccional', 'Persona.nro_documento', 'Persona.apellidos', 'Persona.nombres', 'Persona.cuil']
  end

  private

  def data
    records.map do |record|
      [
        record.establecimiento.codigo_jurisdiccional,
        record.establecimiento.cue,
        record.persona.nro_documento,
        record.persona.apellidos,
        record.persona.nombres,
        record.persona.cuil,
        '<span class="label label-info">'+record.fecha_alta.to_s+'</span>',
        '<span class="label label-success">'+record.fecha_baja.to_s+'</span>',
      ]
    end
  end

  def get_raw_records
    #RelevamientoJardine.all.includes(:establecimiento, :localidad)
    return options[:query]
  end

end
