class ListadoLicenciaCargosDatatable < AjaxDatatablesRails::Base
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

            Cargo.where(:id => record.cargo_id.to_i).first.establecimiento.codigo_jurisdiccional,
            record.cargo.secuencia,
            "Cargo",
            Funcion.where(categoria: Cargo.where(id: record.cargo_id).first.cargo.to_i).first.to_s,
            Cargo.where(:id => record.cargo_id.to_i).first.persona.to_s,
            record.cargo.situacion_revista,
            record.cargo.anio,
            record.cargo.division,
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
            if record.vigente == "Finalizada" and (record.finalizada == false or record.finalizada == nil) then
            '<a class="btn btn-primary btn-sm btn-ajax2" data-toggle="tooltip" data-placement="top" title="Chequear finalizada" data-url="'+Rails.application.routes.url_helpers.licencias_chequear_finalizada_path(id: record.id.to_s, :format => :json)+'">Chequear Finalizada<span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>'
            elsif record.vigente == "Finalizada" and record.finalizada == true then
              '<a class="btn btn-info btn-sm"
              <span class=aria-hidden="true" >Finalizada</span>
              </a>'
            elsif record.vigente == "Vigente" and (record.cargada == false or record.cargada == nil )then
            '<a class="btn btn-primary btn-sm btn-ajax2" data-toggle="tooltip" data-placement="top" title="Chequear cargada" data-url="'+Rails.application.routes.url_helpers.licencias_chequear_cargada_path(id: record.id.to_s, :format => :json)+'">Chequear Cargada<span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>'

            elsif record.vigente == "Vigente" and record.cargada == true then
              '<a class="btn btn-info btn-sm"
              <span class=aria-hidden="true" >Cargada</span>
              </a>'
            end,

  
     ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
