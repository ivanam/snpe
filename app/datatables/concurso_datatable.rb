class ConcursoDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['fecha_concurso']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= []
  end

  private

  def data
    records.map do |record|
      [
        record.fecha_concurso.to_s,
        record.fecha_inicio.to_s,
        record.fecha_fin.to_s,
        if record.es_activo
          '<span class="badge badge-primary">Activo</span>'
        else
          '<span class="badge badge-success">No activo</span>'
        end,
        '<div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Acciones
            <span class="caret"></span>
         </button>
           <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
             <li role="presentation"><a role="menuitem" tabindex="-1" href="concursos/'+record.id.to_s+'">Ver</a></li>
            <li role="presentation"><a role="menuitem" tabindex="-1" href="concursos/'+record.id.to_s+'/edit">Editar</a></li>
            <li role="presentation"><a rel="nofollow" data-method="delete" data-confirm="Seguro desea eliminar" role="menuitem" tabindex="-1" href="concursos/'+record.id.to_s+'">Eliminar</a></li>
          </ul>
        </div>',
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
