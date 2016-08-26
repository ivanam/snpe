class LicenciaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['licencia.id']
  end

  def searchable_columns
    @searchable_columns ||= ['licencia.id']
  end

  private

  def data
    records.map do |record|
      [

        if record.altas_bajas_hora_id != nil  
          "Horas"
        elsif record.cargo_id != nil
          "Cargo"
        else
          "Cargo no docente"
        end,

        if record.altas_bajas_hora_id != nil  
          #AltasBajasHora.where(:id => record.altas_bajas_hora_id.to_i).first.cant_horas
          record.altas_bajas_hora_id
        elsif record.cargo_id != nil
            record.cargo_id
        else
            record.cargo_no_docente_id
        end,

        record.fecha_desde,
        record.fecha_hasta,
        record.articulo.codigo + record.articulo.descripcion[0..30].html_safe+"...",
        if record.vigente == true 
        '<center><div class="btn-acciones"><a class="btn btn-success btn-sm" data-toggle="modal" fecha_desde="'+Util.fecha_a_es(record.fecha_desde)+'" fecha_hasta="'+Util.fecha_a_es(record.fecha_hasta)+'" id_lic="'+record.id.to_s+'" id_art="'+record.articulo_id.to_s+'" data-target="#modal_licencia_final" title="Editar" ><span class=aria-hidden="true" >Vigente</span></a>' 
 
           else
        "Cerrada" 
        end,
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
