class AltasBajasHoraMateriaDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= ['AltasBajasHora.id']
  end

  def searchable_columns
    @searchable_columns ||= ['AltasBajasHora.id']
  end

  private

  def data
    records.map do |record|
      [
        record.persona.cuil,
        record.persona.to_s,
        record.situacion_revista,
        
        
      ]
    end
  end


  def get_raw_records
    #return AltasBajasHora.all    
    return options[:query]
  end
  
  def sort_records(records)
    records
  end

end
