class RubroDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

    def_delegators :@view, :link_to, :edit_rubro_path, :edit_persona_path

    def sortable_columns
      @sortable_columns ||= ['Persona.apeynom', 'Region.nombre', 'Juntafuncion.descripcion', 'total']
    end

    def searchable_columns
      @searchable_columns ||= ['Persona.apeynom', 'Region.nombre', 'Juntafuncion.descripcion', 'Persona.nro_documento']
    end

  private
  
  def data
      records.map do |record|
      [
        link_to(record.persona.to_s, edit_persona_path(record.persona)),
        record.region.nombre,
        record.juntafuncion.descripcion,
        record.total,
          '<div class="dropdown">
            <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
              Acciones
              <span class="caret"></span>
           </button>
             <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
               <li role="presentation">'+ link_to("Ver", record) +'</li>
              <li role="presentation">'+ link_to("Editar", edit_rubro_path(record)) +'</li>
              <li role="presentation">'+ link_to('Eliminar', record, method: :delete, data: { confirm: 'Seguro que desea eliminar?' }) +'</li>
            </ul>
          </div>',
       ]
    end
  end

  def get_raw_records
    return options[:query].joins(:region, :persona, :juntafuncion)
  end

end
