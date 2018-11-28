class AuxiliaresActivosDatatable < AjaxDatatablesRails::Base
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
        record.turno.to_s,
        record.establecimiento.codigo_jurisdiccional,
        record.establecimiento.nombre,
        record.observaciones,
        '<span class="label label-info">'+Util.fecha_a_es(record.fecha_alta)+'</span>',
        '<center><div class="btn-acciones"><a class="btn btn-primary btn-sm" id_cargo_no_docentes="'+record.id.to_s+'"href="'+Rails.application.routes.url_helpers.historial_agente_cargos_no_docentes_path(record.id.to_s)+'" title="Historial" ><span class=aria-hidden="true" >Historial</span></a>'

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