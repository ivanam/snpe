class PrimariaCargoDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  # def sortable_columns
  #    @sortable_columns ||= ['primaria_cargo.id']
  #  end

  #  def searchable_columns
  #    @searchable_columns ||= ['primaria_cargo.id']
  #  end

  private
  
  def data
    records.map do |record|
      [
        record.descripcion,
        record.codigo_nomen,
        '<div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Acciones
            <span class="caret"></span>
         </button>
           <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
             <li role="presentation"><a role="menuitem" tabindex="-1" href="primaria_cargos/'+record.id.to_s+'">Ver</a></li>
            <li role="presentation"><a role="menuitem" tabindex="-1" href="primaria_cargos/'+record.id.to_s+'/edit">Editar</a></li>
            <li role="presentation"><a rel="nofollow" data-method="delete" data-confirm="Seguro desea eliminar" role="menuitem" tabindex="-1" href="primaria_cargos/'+record.id.to_s+'">Eliminar</a></li>
          </ul>
        </div>',
       ]
    end
  end

  def get_raw_records
    return options[:query]
    #PrimariaCargo.all
  end

end
