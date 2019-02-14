class CargoInscripDocDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def_delegators :@view, :link_to, :inscripcion_path, :edit_persona_path

    def sortable_columns
      @sortable_columns ||= ['Region.nombre', 'Juntafuncion.descripcion', 'Rubro.total', 'Rubro.promedio', 'CargoInscripDoc.opcion', 'Persona.nro_documento']
    end

    def searchable_columns
      @searchable_columns ||= ['Juntafuncion.descripcion', 'Persona.nro_documento']
    end

  private
  
  def data
    # Junta solo ve su region
    @user = options[:current_user]
    nombre = @user.get_nombre_region
    @region = Region.where(nombre: nombre).first
    _records = records
    if !@region.nil?
      _records = _records.where('inscripcions.region_id' => @region.id)
    end
    _records.map do |record|
      [
        record.inscripcion.region.to_s, 
        record.juntafuncion.to_s,
        record.inscripcion.persona.get_puntaje_para(record.juntafuncion).to_f,
        record.inscripcion.persona.get_puntaje_II_para(record.juntafuncion).to_f,
        record.opcion.to_i,
        record.inscripcion.persona.nro_documento,
        
        '<div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Acciones
            <span class="caret"></span>
         </button>
           <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
            <li role="presentation">'+ link_to("Ver Inscripcion", inscripcion_path(record.inscripcion)) +'</li>
            <li role="presentation"><a rel="nofollow" data-method="delete" data-confirm="Seguro desea eliminar" role="menuitem" tabindex="-1" href="cargo_inscrip_docs/'+record.id.to_s+'">Eliminar</a></li>

          </ul>
        </div>',
       ]
    end
  end

  def get_raw_records
    options[:query].joins(:juntafuncion, inscripcion: [{ persona: :rubros }, :region ])
      .distinct.order('regions.nombre', 'juntafuncions.descripcion','rubros.total desc', 'rubros.promedio desc',  :opcion)
  end

end
