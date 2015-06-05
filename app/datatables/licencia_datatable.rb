class LicenciaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['licencia.id']
  end

  def searchable_columns
    @searchable_columns ||= ['licencia.id']
  end

  private

  def data
    records.map do |record|
      [
        record.altas_bajas_hora,
        record.fecha_desde,
        record.fecha_hasta,
        record.articulo.to_s,
      ]
    end
  end

  def get_raw_records
    return options[:query]
  end

end
