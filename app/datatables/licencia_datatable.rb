class LicenciaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Licencium.fecha_desde', 'Licencium.fecha_hasta', 'Licencium.articulo_id']
  end

  def searchable_columns
    @searchable_columns ||= ['Licencium.fecha_desde', 'Licencium.fecha_hasta','Licencium.articulo_id']
  end

  private

  def data
    records.map do |record|
      [        
         if record.altas_bajas_hora_id != nil
           Establecimiento.where(id: (AltasBajasHora.where(id: record.altas_bajas_hora_id).first.establecimiento_id)).first.codigo_jurisdiccional
         elsif record.cargo_id != nil
           Establecimiento.where(id: (Cargo.where(id: record.cargo_id).first.establecimiento_id)).first.codigo_jurisdiccional
         else
           Establecimiento.where(id: (CargoNoDocente.where(id: record.cargo_no_docente_id).first.establecimiento_id)).first.codigo_jurisdiccional
         end,

        if record.altas_bajas_hora_id != nil  
          "Horas"
        elsif record.cargo_id != nil
          "Cargo"
        else
          "Cargo no docente"
        end,

        if record.altas_bajas_hora_id != nil
           AltasBajasHora.find(record.altas_bajas_hora_id).secuencia.to_s
         elsif record.cargo_id != nil
           Cargo.find(record.cargo_id).secuencia.to_s
         else
           CargoNoDocente.find(record.cargo_no_docente_id).secuencia.to_s
         end,

         if record.altas_bajas_hora_id != nil
           AltasBajasHora.find(record.altas_bajas_hora_id).turno.to_s
         elsif record.cargo_id != nil
           Cargo.find(record.cargo_id).turno.to_s
         else
           CargoNoDocente.find(record.cargo_no_docente_id).turno.to_s
         end,
         
         if record.altas_bajas_hora_id != nil
           AltasBajasHora.find(record.altas_bajas_hora_id).ciclo_carrera.to_s+'/'+ AltasBajasHora.find(record.altas_bajas_hora_id).anio.to_s + '/' + AltasBajasHora.find(record.altas_bajas_hora_id).division.to_s
         elsif record.cargo_id != nil
            Cargo.find(record.cargo_id).anio.to_s + '-' + Cargo.find(record.cargo_id).division.to_s 
         end,

         if record.cargo_id != nil
           Cargo.find(record.cargo_id).situacion_revista.to_s
         elsif record.altas_bajas_hora_id != nil
           AltasBajasHora.find(record.altas_bajas_hora_id).situacion_revista.to_s
         elsif record.cargo_no_docente_id != nil
           CargoNoDocente.find(record.cargo_no_docente_id).situacion_revista.to_s
        end,

         if record.altas_bajas_hora_id != nil
           AltasBajasHora.find(record.altas_bajas_hora_id).grupo_id.to_s
         elsif record.cargo_id != nil
           Cargo.find(record.cargo_id).grupo_id.to_s
         end,

        if record.altas_bajas_hora_id != nil  
          "Cantidad de horas: #{AltasBajasHora.find(record.altas_bajas_hora_id).cant_horas}"
        elsif record.cargo_id != nil
          Funcion.where(categoria: Cargo.find(record.cargo_id).cargo).first.to_s
        else  
          Cargosnd.where(id: CargoNoDocente.find(record.cargo_no_docente_id).cargo).first.cargo_desc.to_s
        end,

        Util.fecha_a_es(record.fecha_desde),
        Util.fecha_a_es(record.fecha_hasta),
        record.articulo.codigo + " - " +record.articulo.descripcion[0..30].html_safe+"...",
        if record.con_certificado == true
          "SI"
        elsif record.con_certificado == nil
          ""
        else
          "NO"
        end,
        if record.con_formulario == true
          "SI"
        elsif record.con_formulario == nil
          ""
        else
          "NO"
        end,
        record.organismo,
        if record.vigente == "Vigente" 

          '<center><div class="btn-acciones"><a class="btn btn-success btn-sm" data-toggle="modal" fecha_desde="'+Util.fecha_a_es(record.fecha_desde)+'" fecha_hasta="'+Util.fecha_a_es(record.fecha_hasta)+'" id_lic="'+record.id.to_s+'" observaciones="'+CGI::escapeHTML(record.observaciones.to_s)+'" id_art="'+record.articulo_id.to_s+'" con_certificado="' +record.con_certificado.to_s+'" con_formulario="'+ record.con_formulario.to_s+'" data-target="#modal_licencia_final" title="Editar" ><span class=aria-hidden="true" >Vigente</span></a>' 
        else
          '<center><div class="btn-acciones"><a class="btn btn-danger btn-sm">'+record.vigente+'</a></center></div>' 
        end,
        if record.vigente == "Vigente" 
          if record.altas_bajas_hora_id != nil  and record.vigente == "Vigente"
            '<center><div class="btn-acciones"><a class="btn btn-primary btn-sm" data-toggle="modal" id_horas="'+record.altas_bajas_hora_id.to_s+'" id_lic="'+record.id.to_s+'" data-target="#modal_licencia_horas2" title="Editar" ><span class=aria-hidden="true" >Cerrar y Agregar Otra Lic</span></a>'
          elsif record.cargo_id != nil and record.vigente == "Vigente"
            '<center><div class="btn-acciones"><a class="btn btn-primary btn-sm" data-toggle="modal" id_cargos="'+record.cargo_id.to_s+'"  id_lic="'+record.id.to_s+'" data-target="#modal_licencia_cargos2" title="Editar" ><span class=aria-hidden="true" >Cerrar y Agregar Otra Lic</span></a>'
          elsif record.cargo_no_docente_id != nil  and record.vigente == "Vigente"
            '<center><div class="btn-acciones"><a class="btn btn-primary btn-sm" data-toggle="modal" id_cargo_no_docentes="'+record.cargo_no_docente_id.to_s+' "id_lic="'+record.id.to_s+'" data-target="#modal_licencia_cargos_no_docentes2" title="Editar" ><span class=aria-hidden="true" >Cerrar y Agregar Otra Lic</span></a>'
          end
        else
          if record.altas_bajas_hora_id != nil  and record.vigente == "Finalizada"
            '<center><div class="btn-acciones"><a class="btn btn-info btn-sm" data-toggle="modal" id_horas="'+record.altas_bajas_hora_id.to_s+'" id_lic="'+record.id.to_s+'" observaciones="'+CGI::escapeHTML(record.observaciones.to_s)+'" con_certificado="'+record.con_certificado.to_s+'" con_formulario="'+record.con_formulario.to_s+'" data-target="#modal_licencia_horas2_obs" title="Editar" ><span class=aria-hidden="true" >Agregar Observaciones</span></a>'
          elsif record.cargo_id != nil and record.vigente == "Finalizada"
            '<center><div class="btn-acciones"><a class="btn btn-info btn-sm" data-toggle="modal" id_cargos="'+record.cargo_id.to_s+'"  id_lic="'+record.id.to_s+'" observaciones="'+CGI::escapeHTML(record.observaciones.to_s)+'" con_certificado="'+record.con_certificado.to_s+'" con_formulario="'+record.con_formulario.to_s+'"  data-target="#modal_licencia_cargos2_obs" title="Editar" ><span class=aria-hidden="true" >Agregar Observaciones</span></a>'
          elsif record.cargo_no_docente_id != nil  and record.vigente == "Finalizada"
            '<center><div class="btn-acciones"><a class="btn btn-info btn-sm" data-toggle="modal" id_cargo_no_docentes="'+record.cargo_no_docente_id.to_s+' "id_lic="'+record.id.to_s+'" observaciones="'+CGI::escapeHTML(record.observaciones.to_s)+'" con_certificado="'+record.con_certificado.to_s+'" con_formulario="'+record.con_formulario.to_s+'" data-target="#modal_licencia_cargos_no_docentes2_obs" title="Editar" ><span class=aria-hidden="true" >Agregar Observaciones</span></a>'
          end
         end,
        '<a href="licencia/'+record.id.to_s+'"><span class="glyphicon glyphicon-search"></a></li>'
      ]
    end
  end

  def get_raw_records
    return options[:query].order('updated_at DESC')
  end

end
