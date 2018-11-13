class JuntafuncionDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def_delegators :@view, :link_to, :edit_juntafuncion_path, :edit_persona_path

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Juntafuncion.descripcion']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['Juntafuncion.descripcion']
  end

  private

  def data
    records.map do |record|
      [
        record.descripcion,
        '<div class="dropdown">
          <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown">
            Acciones
            <span class="caret"></span>
         </button>
           <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
             <li role="presentation">'+ link_to("Ver", record)+'</li>
          </ul>
        </div>',
      ]
    end
  end

  def get_raw_records
    Juntafuncion.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
