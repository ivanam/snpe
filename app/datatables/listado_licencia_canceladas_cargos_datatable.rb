class ListadoLicenciaCanceladasCargosDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns    
    @sortable_columns ||= ['Licencium.cargo_id']
  end

  def searchable_columns
    @searchable_columns ||= ['Licencium.cargo_id']
  end

  private

  def data
    records.map do |record|
       [

            record.oficina,
            record.organismo,
            record.cargo.secuencia,
            Funcion.where(categoria: Cargo.where(id: record.cargo_id).first.cargo.to_i).first.to_s,
            Cargo.where(:id => record.cargo_id.to_i).first.persona.to_s,
            record.cargo.situacion_revista,
            record.cargo.anio,
            record.cargo.division,
            record.articulo.codigo + " - " +record.articulo.descripcion[0..30].html_safe+"...",
            Util.fecha_a_es(record.fecha_desde),
            Util.fecha_a_es(record.fecha_hasta),
            record.vigente,
            record.obs_sin_goce_cancelacion, 
  
     ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
