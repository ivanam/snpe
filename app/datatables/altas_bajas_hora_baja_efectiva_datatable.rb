class AltasBajasHoraBajaEfectivaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['altas_bajas_horas.id']
  end

  def searchable_columns
    @searchable_columns ||= ['altas_bajas_horas.id']
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
    return options[:query]
  end

end
