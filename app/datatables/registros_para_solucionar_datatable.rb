class RegistrosParaSolucionarDatatable < AjaxDatatablesRails::Base
    include AjaxDatatablesRails::Extensions::Kaminari

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= []
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= []
  end

  private

  def data
    records.map do |record|
      [
        if record.horas_registro == true
          "Horas"
        elsif record.cargos_registro == true
          "Cargo"
        elsif record.auxiliar_registro == true
          "auxiliar"
        else
          ""
        end,
        Establecimiento.where(:id => record.establecimiento_id).first.codigo_jurisdiccional.to_s,
        (Persona.where(id: record.persona_id).first).to_s,
        record.secuencia,
        record.fecha_alta,
        record.fecha_baja,
        record.situacion_revista,
        record.horas,
        record.ciclo_carrera,
        record.anio.to_s + "/"+  record.division.to_s + "/" + record.turno.to_s + "/"+  record.codificacion.to_s,
        record.estado,
        record.cargo,
        if record.chequeada == "" or record.chequeada == false or record.chequeada == nil
          '<a class="btn btn-primary btn-sm btn-ajax" data-toggle="tooltip" data-placement="top" title="Chequear" data-url="'+ Rails.application.routes.url_helpers.registros_para_solucionar_chequear_registro_path(id: record.id.to_s , :format => :json)+'">Chequear<span class="glyphicon glyphicon-ok" aria-hidden="true" ></span></a>' 
        else
          '<span class=aria-hidden="true" style="color:green" >Chequeada por '+User.where(:id => record.user_chequeada_id).first.nombres+'</span>'
        end,
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
