class LoteImpresionDatatable < AjaxDatatablesRails::Base
    include AjaxDatatablesRails::Extensions::Kaminari

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['lote_impresions.fecha_impresion']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['lote_impresions.fecha_impresion']
  end

  private

  def data
    records.map do |record|
      [
        Util.fecha_a_es(record.fecha_impresion),
        if record.tipo_id == 1
          'Horas'
        else
          if record.tipo_id == 2
            'Cargos'
          else
            'Cargos no docentes'
          end
        end,
        record.observaciones,
        '<center><div class="btn-acciones"><a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Ver Impresión" href="lote_impresions/'+record.id.to_s+'"><span class="glyphicon glyphicon-print" aria-hidden="true" ></span></a>',
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

    # Esto sirve momentaneamente para el ordenar
  def sort_records(records)
    records
  end
end
