class ArticuloDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Articulo.codigo', 'Articulo.descripcion','Articulo.cantidad_maxima_dias','Articulo.con_goce', 'Articulo.permite_otro_organismo', 'TipoArticulo.descripcion']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['Articulo.codigo', 'Articulo.descripcion','Articulo.cantidad_maxima_dias','Articulo.con_goce', 'Articulo.permite_otro_organismo', 'TipoArticulo.descripcion']
  end

  private

  def data
    records.map do |record|
      [
        record.codigo,
        record.descripcion,
        record.cantidad_maxima_dias,
        (record.con_goce)? 'SI' : 'NO',
        (record.permite_otro_organismo)? 'SI' : 'NO',
        record.tipo_articulo.descripcion,
        '<div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Acciones
            <span class="caret"></span>
          </button>
          <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
            <li role="presentation"><a role="menuitem" tabindex="-1" href="articulos/'+record.id.to_s+'">Ver</a></li>
            <li role="presentation"><a role="menuitem" tabindex="-1" href="articulos/'+record.id.to_s+'/edit">Editar</a></li>
            <li role="presentation"><a rel="nofollow" data-method="delete" data-confirm="Seguro desea eliminar" role="menuitem" tabindex="-1" href="articulos/'+record.id.to_s+'">Eliminar</a></li>
          </ul>
        </div>',
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end
end
