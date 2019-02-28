class EstablecimientoUserDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['establecimientos.codigo_jurisdiccional','establecimientos.nombre', 'establecimientos.cue', 'establecimientos.anexo']
  end

  def searchable_columns
    @searchable_columns ||= ['establecimientos.codigo_jurisdiccional','establecimientos.nombre', 'establecimientos.cue', 'establecimientos.anexo']
  end

  private

  def data
    records.map do |record|
      [
        record.codigo_jurisdiccional,
        record.nombre,
        record.cue,
        record.anexo,
        record.nivel.to_s,
        '<div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Acciones
            <span class="caret"></span>
          </button>
          <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
            <li role="presentation"><a role="menuitem" tabindex="-1" href="'+Rails.application.routes.url_helpers.establecimiento_seleccionar_path(record.id.to_s)+'">Seleccionar</a></li>
            <li role="presentation"><a role="menuitem" tabindex="-1" href="establecimientos/'+record.id.to_s+'">Ver</a></li>
          </ul>
        </div>',
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
