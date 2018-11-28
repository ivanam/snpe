class HorasActivasDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['AltasBajasHora.secuencia', 'Establecimiento.codigo_jurisdiccional', 'Establecimiento.nombre', 'AltasBajasHora.ciclo_carrera', 'AltasBajasHora.anio', 'AltasBajasHora.division', 'AltasBajasHora.turno', 'Materium.codigo', 'AltasBajasHora.fecha_alta']
  end

  def searchable_columns
    @searchable_columns ||= ['AltasBajasHora.secuencia', 'Establecimiento.codigo_jurisdiccional', 'Establecimiento.nombre', 'AltasBajasHora.ciclo_carrera', 'AltasBajasHora.anio', 'AltasBajasHora.division', 'AltasBajasHora.turno', 'Materium.codigo', 'AltasBajasHora.fecha_alta']
  end

  private

  def data
    records.map do |record|
      [
        '<center><div class="btn-acciones"><a  target="_blank" href="'+Rails.application.routes.url_helpers.altas_bajas_hora_path(record.id)+'"><span class=aria-hidden="true" >'+record.secuencia.to_s+'</span></a>',
        record.establecimiento.codigo_jurisdiccional.to_s + " -- " + record.establecimiento.nombre,    
        record.plan.to_s,
        record.materium.to_s,        
        record.anio,
        record.division,
        record.turno,
        #record.materium.codigo.to_s.rjust(AltasBajasHora::LONGITUD_CODIGO,'0'),        
        '<center><span class="label label-info">'+Util.fecha_a_es(record.fecha_alta)+'</span></center>',
        '<center><div class="btn-acciones"><a class="btn btn-primary btn-sm" id_horas="'+record.id.to_s+'"href="'+Rails.application.routes.url_helpers.historial_agente_path(record.id.to_s)+'" title="Historial" ><span class=aria-hidden="true" >Historial</span></a>'
      ]
    end
  end


  def get_raw_records
    #return AltasBajasHora.all.includes(:establecimiento, :persona)
    return options[:query]
  end

end