class LicenciaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Licencium.altas_bajas_hora_id', 'Licencium.altas_bajas_hora_id', 'Licencium.fecha_desde', 'Licencium.fecha_hasta', 'Licencium.articulo_id']
  end

  def searchable_columns
    @searchable_columns ||= ['Licencium.altas_bajas_hora_id', 'Licencium.altas_bajas_hora_id', 'Licencium.fecha_desde', 'Licencium.fecha_hasta','Licencium.articulo_id']
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
          "Cantidad de horas: #{AltasBajasHora.where(:id => record.altas_bajas_hora_id.to_i).first.cant_horas}"
          #record.altas_bajas_hora_id
        elsif record.cargo_id != nil
            Funcion.where(categoria: Cargo.find(record.cargo_id).cargo.to_i).first.to_s
        else
            Cargosnd.where(CargoNoDocente.find(record.cargo_no_docente_id).cargo).to_s
        end,

        Util.fecha_a_es(record.fecha_desde),
        Util.fecha_a_es(record.fecha_hasta),
        record.articulo.codigo + " - " +record.articulo.descripcion[0..30].html_safe+"...",
        if record.vigente == "Vigente" 
        '<center><div class="btn-acciones"><a class="btn btn-success btn-sm" data-toggle="modal" fecha_desde="'+Util.fecha_a_es(record.fecha_desde)+'" fecha_hasta="'+Util.fecha_a_es(record.fecha_hasta)+'" id_lic="'+record.id.to_s+'" id_art="'+record.articulo_id.to_s+'" data-target="#modal_licencia_final" title="Editar" ><span class=aria-hidden="true" >Vigente</span></a>' 
 
           else
          '<center><div class="btn-acciones"><a class="btn btn-danger btn-sm">'+record.vigente+'</a></center></div>' 
        end,
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
