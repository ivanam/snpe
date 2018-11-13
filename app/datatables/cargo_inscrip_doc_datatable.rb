class CargoInscripDocDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def_delegators :@view, :link_to, :inscripcion_path, :edit_persona_path

    def sortable_columns
      @sortable_columns ||= ['Persona.nro_documento', 'Region,nombre', 'Juntafuncion.descripcion', 'Rubro.total', 'CargoInscripDoc.opcion']
    end

    def searchable_columns
      @searchable_columns ||= ['cargo_inscrip_docs.id']
    end

  private


  
  def data
    records.map do |record|
      [
        record.inscripcion.persona.nro_documento,
        record.inscripcion.region.to_s, 
        record.juntafuncion.to_s,
        record.inscripcion.persona.get_puntaje_para(record.juntafuncion).to_f,
        
        record.opcion.to_i,
        
        '<div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Acciones
            <span class="caret"></span>
         </button>
           <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
            <li role="presentation">'+ link_to("Ver Inscripcion", inscripcion_path(record.inscripcion)) +'</li>
          </ul>
        </div>',
       ]
    end
  end

  def get_raw_records
    CargoInscripDoc.joins(:juntafuncion, inscripcion: [{ persona: :rubros }, :region])
  end

end
