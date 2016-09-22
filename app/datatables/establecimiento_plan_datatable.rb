class EstablecimientoPlanDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['establecimientos.codigo_jurisdiccional', 'plans.codigo']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['establecimientos.codigo_jurisdiccional', 'plans.codigo']
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        "#{record.establecimiento.to_s}",
        record.plan.to_s,
        '<div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Acciones
            <span class="caret"></span>
          </button>
          <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
            <li role="presentation"><a role="menuitem" tabindex="-1" href="establecimiento_plans/'+record.id.to_s+'">Ver</a></li>
            <li role="presentation"><a role="menuitem" tabindex="-1" href="establecimiento_plans/'+record.id.to_s+'/edit">Editar</a></li>
            <li role="presentation"><a rel="nofollow" data-method="delete" data-confirm="Seguro desea eliminar" role="menuitem" tabindex="-1" href="establecimiento_plans/'+record.id.to_s+'">Eliminar</a></li>
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
