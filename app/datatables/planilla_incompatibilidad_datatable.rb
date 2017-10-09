class PlanillaIncompatibilidadDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['PlanillaIncompatibilidad.id']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['PlanillaIncompatibilidad.dni','PlanillaIncompatibilidad.apellido','PlanillaIncompatibilidad.nombre']
  end

  private

  def data
    records.map do |record|
      [
        record.numero,
        record.nota_ingreso,
        record.dni.to_s + ' - ' + record.apellido + ', ' + record.nombre,
        record.observaciones_inc,
        record.observaciones_suel,
        '<div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Acciones
            <span class="caret"></span>
          </button>
          <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
            <li role="presentation"><a role="menuitem" tabindex="-1" href="planilla_incompatibilidads/'+record.id.to_s+'">Ver</a></li>
            <li role="presentation"><a role="menuitem" tabindex="-1" href="planilla_incompatibilidads/'+record.id.to_s+'/edit">Editar</a></li>
            <li role="presentation"><a rel="nofollow" data-method="delete" data-confirm="Seguro desea eliminar" role="menuitem" tabindex="-1" href="planilla_incompatibilidads/'+record.id.to_s+'">Eliminar</a></li>
          </ul>
        </div>',
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end
end
