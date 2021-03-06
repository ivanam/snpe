class ListadoLicenciaCargos2Datatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns    
    #@sortable_columns ||= ['establecimientos.codigo_jurisdiccional', 'personas.nro_documento','personas.apeynom','licencia.altas_bajas_hora_id','licencia.altas_bajas_hora_id','licencia.fecha_desde','licencia.fecha_hasta','licencia.articulo_id']
    @sortable_columns ||= ['Persona.nro_documento','Persona.apeynom','Licencium.cargo_id', 'Cargo.persona_id', 'Articulo.codigo', 'Licencium.fecha_desde', 'Licencium.fecha_hasta']
  end

  def searchable_columns
    #@searchable_columns ||= ['establecimientos.codigo_jurisdiccional','personas.nro_documento','personas.apeynom','licencia.altas_bajas_hora_id','licencia.altas_bajas_hora_id','licencia.fecha_desde','licencia.fecha_hasta','licencia.articulo_id']
    @searchable_columns ||= ['Persona.nro_documento','Persona.apeynom','Licencium.cargo_id', 'Cargo.persona_id', 'Articulo.codigo', 'Licencium.fecha_desde', 'Licencium.fecha_hasta']
  end

  private

  def data
    records.map do |record|
       [

      
            "Cargo",
            Funcion.where(categoria: Cargo.where(id: record.cargo_id).first.cargo.to_i).first.to_s,
            Cargo.where(:id => record.cargo_id.to_i).first.persona.to_s,
            record.articulo.codigo + " - " +record.articulo.descripcion[0..30].html_safe+"...",
            Util.fecha_a_es(record.fecha_desde),
            Util.fecha_a_es(record.fecha_hasta),
            if record.vigente == "Vigente" 
              '<center>
                <div class="btn-acciones">
                <a class="btn btn-success btn-sm" data-toggle="modal" fecha_desde="'+Util.fecha_a_es(record.fecha_desde)+'" fecha_hasta="'+Util.fecha_a_es(record.fecha_hasta)+'" id_lic="'+record.id.to_s+'" id_art="'+record.articulo_id.to_s+'" data-target="#modal_licencia_final" title="Editar" >
                  <span class=aria-hidden="true" >Vigente</span>
                </a>'  
            else
              '<center><div class="btn-acciones"><a class="btn btn-danger btn-sm">'+record.vigente+'</a></center></div>' 
            end,
              if record.altas_bajas_hora_id != nil  
              AltasBajasHora.where(:id => record.altas_bajas_hora_id.to_i).first.persona.calle
              
            elsif record.cargo_id != nil
              Cargo.where(:id => record.cargo_id.to_i).first.persona.calle
            else
              CargoNoDocente.where(:id => record.cargo_no_docente_id.to_i).first.persona.calle
            end,

            if record.altas_bajas_hora_id != nil  
              AltasBajasHora.where(:id => record.altas_bajas_hora_id.to_i).first.persona.nro_calle
            elsif record.cargo_id != nil
              Cargo.where(:id => record.cargo_id.to_i).first.persona.nro_calle
            else
              CargoNoDocente.where(:id => record.cargo_no_docente_id.to_i).first.persona.nro_calle
            end,

            
            if record.altas_bajas_hora_id != nil  
              AltasBajasHora.where(:id => record.altas_bajas_hora_id.to_i).first.persona.piso
            elsif record.cargo_id != nil
              Cargo.where(:id => record.cargo_id.to_i).first.persona.piso
            else
              CargoNoDocente.where(:id => record.cargo_no_docente_id.to_i).first.persona.piso
            end,

            record.observaciones,
     ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
