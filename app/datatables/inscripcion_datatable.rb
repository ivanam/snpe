class InscripcionDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :link_to, :edit_inscripcion_path, :edit_persona_path
  
  def sortable_columns
     @sortable_columns ||= ['Inscripcion.fecha_incripcion', 'Region.nombre', 'Persona.apeynom']
   end

   def searchable_columns
     @searchable_columns ||= ['Inscripcion.fecha_incripcion', 'Region.nombre', 'Persona.apeynom', 'Persona.nro_documento']
   end

  private
  
  def data
    records.map do |record|
      [
        record.fecha_incripcion,
        record.region.to_s,
        link_to(record.persona.to_s, edit_persona_path(record.persona)),
        '<div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Acciones
            <span class="caret"></span>
         </button>
           <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
             <li role="presentation">'+ link_to("Ver", record)+'</li>
             <li role="presentation">'+ link_to("Editar", edit_inscripcion_path(record)) +'</li>
            <li role="presentation">'+ link_to('Eliminar', record, method: :delete, data: { confirm: 'Seguro que desea eliminar?' }) +'</li>
          </ul>
        </div>',
       ]
    end
  end

  def get_raw_records
    Inscripcion.joins(:persona, :region)
    #return options[:query]
    #Inscripcion.all
  end

end
