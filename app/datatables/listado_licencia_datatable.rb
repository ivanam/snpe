class ListadoLicenciaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns    
    #@sortable_columns ||= ['establecimientos.codigo_jurisdiccional', 'personas.nro_documento','personas.apeynom','licencia.altas_bajas_hora_id','licencia.altas_bajas_hora_id','licencia.fecha_desde','licencia.fecha_hasta','licencia.articulo_id']
    @sortable_columns ||= ['Persona.nro_documento','Persona.apeynom','Licencium.altas_bajas_hora_id', 'AltasBajasHora.persona_id', 'Articulo.codigo', 'Licencium.fecha_desde', 'Licencium.fecha_hasta', 'Licencium.vigente']
  end

  def searchable_columns
    #@searchable_columns ||= ['establecimientos.codigo_jurisdiccional','personas.nro_documento','personas.apeynom','licencia.altas_bajas_hora_id','licencia.altas_bajas_hora_id','licencia.fecha_desde','licencia.fecha_hasta','licencia.articulo_id']
    @searchable_columns ||= ['Persona.nro_documento','Persona.apeynom','Licencium.altas_bajas_hora_id', 'AltasBajasHora.persona_id', 'Articulo.codigo', 'Licencium.fecha_desde', 'Licencium.fecha_hasta',  'Licencium.vigente']
  end

  private

  def data
    records.map do |record|
      [    
            

            AltasBajasHora.where(:id => record.altas_bajas_hora_id.to_i).first.establecimiento.codigo_jurisdiccional,
            record.organismo,
            record.altas_bajas_hora.secuencia,
            record.altas_bajas_hora.horas,
            AltasBajasHora.where(:id => record.altas_bajas_hora_id.to_i).first.persona.to_s,
            record.altas_bajas_hora.situacion_revista,
            record.altas_bajas_hora.anio.to_s + " / " + record.altas_bajas_hora.division.to_s + " / " + record.altas_bajas_hora.codificacion.to_s,
            record.articulo.codigo.to_s + " - " +record.articulo.descripcion[0..30].html_safe+"...",
            Util.fecha_a_es(record.fecha_desde) + " / " + Util.fecha_a_es(record.fecha_hasta), 
            record.created_at.to_date,
            record.observaciones,
            record.altas_bajas_hora.fecha_baja, 
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
            '<a class="btn btn-primary btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Chequear finalizada" data-url="'+Rails.application.routes.url_helpers.licencias_chequear_finalizada_path(id: record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>'
            elsif record.vigente == "Finalizada" and record.finalizada == true then
              '<a class="btn btn-info btn-sm"
              <span class=aria-hidden="true" >Finalizada por ' + User.where(:id => record.user_cheq_finalizada_id).first.nombres + '</span>
              </a>'
            elsif record.vigente == "Vigente" and (record.cargada == false or record.cargada == nil )then
            '<a class="btn btn-primary btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Chequear cargada" data-url="'+Rails.application.routes.url_helpers.licencias_chequear_cargada_path(id: record.id.to_s, :format => :json)+'"><span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>'

            elsif record.vigente == "Vigente" and record.cargada == true then
              '<a class="btn btn-info btn-sm"
              <span class=aria-hidden="true" >Cargada por ' + User.where(:id => record.user_cheq_cargada_id).first.nombres + '</span>
              </a>'
            end,
            if (record.cargada == nil and record.cancelada_sin_goce == nil) and (record.finalizada == nil and record.cancelada_sin_goce == nil)
                '<a class="btn btn-danger btn-sm btn-ajax" data-toggle="modal" id_lic="'+record.id.to_s+'"observaciones="'+CGI::escapeHTML(record.observaciones.to_s)+'" title="cancelar" data-original-title="Observaciones" data-target="#modal_horas_obs"><span class="glyphicon glyphicon-remove" aria-hidden="true" ></span></a>'
            else
              ''
            end,
     ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
