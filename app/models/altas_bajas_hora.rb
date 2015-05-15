class AltasBajasHora < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona

  TURNO = ["M", "T"]

  def ina_justificada(periodo)
    @asistencia = Asistencium.where(:altas_bajas_hora_id => self.id).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.ina_justificada.to_s
    end
  end

  def ina_injustificada(periodo)
    return 3
  end

end

#SELECT * FROM detalle d inner join recibos r on r.nume_docu = d.nume_docu where d.nume_docu = 30284359 and d.mes = 4 and d.anio = 2015 LIMIT 0,1000
#SELECT * FROM detalle d where d.nume_docu = 30284359 and d.mes = 4 and d.anio = 2015 LIMIT 0,1000
# TRAER CARGOS ACTIVOS DE UNA PERSONA SELECT * FROM paddoc p where nume_docu = 30284359 and estado = "ALT" LIMIT 0,1000
