class CargosBajasDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['Persona.nro_documento', 'Persona.cuil', 'Persona.apeynom','Cargo.secuencia', 'Cargo.cargo', 'Establecimiento.nombre','Cargo.turno', 'Cargo.anio','Cargo.division', 'Cargo.grupo_id', 'Cargo.fecha_alta']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.cuil', 'Persona.apeynom','Cargo.secuencia', 'Establecimiento.nombre','Cargo.turno', 'Cargo.anio','Cargo.division']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.nro_documento,
        record.persona.cuil,
        record.persona.to_s,
        record.secuencia,
        record.cargo,
        record.establecimiento.nombre,
        record.turno,
        record.anio,
        record.division,
        record.grupo_id,
        '<span class="label label-info">'+Util.fecha_a_es(record.fecha_alta)+'</span>',
        '<a class="btn btn-sm btn-danger popup-fecha" id="'+record.id.to_s+'" data-value="'+Util.fecha_a_es(Date.today)+'" data-type="combodate" data-format="DD/MM/YYYY" data-viewformat="DD-MM-YYYY" data-template="D - MMMM - YYYY" data-container="body" data-placement="left" data-original-title="Seleccione la fecha de baja" data-resource="cargo" data-name="fecha_baja" data-url="'+Rails.application.routes.url_helpers.cargo_dar_baja_path(record.id.to_s)+'">
          <span class="glyphicon glyphicon-trash"></span>
          Baja
        </a>',
      ]
    end
  end


  def get_raw_records
    return options[:query]
  end

end
