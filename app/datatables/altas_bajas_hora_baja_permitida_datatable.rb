class AltasBajasHoraBajaPermitidaDatatable < AjaxDatatablesRails::Base
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
        record.persona.nro_documento,
        record.persona.cuil,
        record.persona.apellidos,
        record.secuencia,
        record.establecimiento.codigo_jurisdiccional,
        record.establecimiento.cue,
        record.establecimiento.nombre,
        record.anio,
        record.division,
        '<span class="label label-info">'+Util.fecha_a_es(record.fecha_alta)+'</span>',
        '<a class="btn btn-sm btn-danger popup-fecha" id="'+record.id.to_s+'" data-value="'+Util.fecha_a_es(Date.today)+'" data-type="combodate" data-format="DD/MM/YYYY" data-viewformat="DD-MM-YYYY" data-template="D - MMMM - YYYY" data-container="body" data-placement="left" data-original-title="Seleccione la fecha de baja" data-resource="altas_bajas_hora" data-name="fecha_baja" data-url="'+Rails.application.routes.url_helpers.altas_bajas_horas_dar_baja_path(record.id.to_s)+'">
          <span class="glyphicon glyphicon-trash"></span>
          Baja
        </a>',
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
