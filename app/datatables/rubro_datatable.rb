class RubroDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

    def sortable_columns
      @sortable_columns ||= ['rubros.total']
    end

    def searchable_columns
      @searchable_columns ||= ['rubros.persona_id']
    end

  private
  
  def data
      records.map do |record|
      [
      record.persona_id,
      record.nombre_apellido,
      record.rubro_titulo,
      record.promedio,
      record.ant_doc,
      record.rubro_gestion,
      record.rubro_ser_prest,
      record.rubro_residencia,
      record.rubro_cursos,
      record.rubro_concepto,
      record.total,
        '<div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Acciones
            <span class="caret"></span>
         </button>
           <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
             <li role="presentation"><a role="menuitem" tabindex="-1" href="rubros/'+record.id.to_s+'">Ver</a></li>
            <li role="presentation"><a role="menuitem" tabindex="-1" href="rubros/'+record.id.to_s+'/edit">Editar</a></li>
            <li role="presentation"><a rel="nofollow" data-method="delete" data-confirm="Seguro desea eliminar" role="menuitem" tabindex="-1" href="rubros/'+record.id.to_s+'">Eliminar</a></li>
          </ul>
        </div>',
       ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
