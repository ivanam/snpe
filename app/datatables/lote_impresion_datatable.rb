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
        record.fecha_impresion,
        record.observaciones,
        '<center><div class="btn-acciones"><a class="btn btn-primary btn-sm" data-toggle="tooltip" data-placement="top" title="Impresion" href="lote_impresions/'+record.id.to_s+'"><span class="glyphicon glyphicon-pencil" aria-hidden="true" ></span></a>',
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
