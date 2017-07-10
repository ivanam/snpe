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
           AltasBajasHora.find(record.altas_bajas_hora_id).ciclo_carrera.to_s
         end,
         
         if record.altas_bajas_hora_id != nil
           AltasBajasHora.find(record.altas_bajas_hora_id).anio.to_s
          elsif record.cargo_id != nil
           Cargo.find(record.cargo_id).anio.to_s
         end,

         if record.altas_bajas_hora_id != nil
           AltasBajasHora.find(record.altas_bajas_hora_id).division.to_s
         elsif record.cargo_id != nil
           Cargo.find(record.cargo_id).division.to_s
         end,

         if record.cargo_id != nil
           Cargo.find(record.cargo_id).curso.to_s
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
