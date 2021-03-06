class DespliegueDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['plans.descripcion','despliegues.anio','plans.codigo','materia.codigo','despliegues.carga_horaria','despliegues.cant_docentes', 'despliegues.observacion']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['plans.codigo',  'despliegues.anio','plans.descripcion','materia.descripcion','despliegues.carga_horaria','despliegues.cant_docentes', 'despliegues.observacion']
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.anio,
        record.plan.to_s,
        record.materium.to_s,
        record.carga_horaria,
        record.cant_docentes,
        record.observacion,
        '<div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Acciones
            <span class="caret"></span>
          </button>
          <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
            <li role="presentation"><a role="menuitem" tabindex="-1" href="despliegues/'+record.id.to_s+'">Ver</a></li>
            <li role="presentation"><a role="menuitem" tabindex="-1" href="despliegues/'+record.id.to_s+'/edit">Editar</a></li>
          </ul>
        </div>',
      ]
    end
  end

  def get_raw_records
    # insert query here
    return options[:query]
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
