class CargoNoDocenteDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
     @sortable_columns ||= ['Persona.nro_documento', 'Persona.apeynom','CargoNoDocente.situacion_revista','CargoNoDocente.division', 'CargoNoDocente.turno']
  end

  def searchable_columns
    @searchable_columns ||= ['Persona.nro_documento', 'Persona.apeynom', 'CargoNoDocente.situacion_revista','CargoNoDocente.division', 'CargoNoDocente.turno']
  end

  private

  def data 
    records.map do |record|
      [ 

        record.persona.nro_documento,
        record.persona.to_s,
<<<<<<< HEAD
        record.situacion_revista,

     ]
=======
        record.situacion_revista,     
        Util.fecha_a_es(record.fecha_alta)
      ]
>>>>>>> e99fc81acb22b6d20a4c488f4484a07a918412fd
    end
  end

  def get_raw_records
    return options[:query]
  end

end
