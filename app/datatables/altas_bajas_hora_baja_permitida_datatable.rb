class AltasBajasHoraBajaPermitidaDatatable < AjaxDatatablesRails::Base
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
        '<span class="label label-info">'+Util.fecha_a_es(record.fecha_alta)+'</span>',
        '<div class="dropdown">
          <a class="btn btn-danger" type="button" data-confirm="Seguro desea confirmar la baja?" href="'+Rails.application.routes.url_helpers.altas_bajas_horas_dar_baja_path(record.id.to_s)+'">
            <span class="glyphicon glyphicon-trash"></span>
            Baja
          </a>
        </div>',
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
