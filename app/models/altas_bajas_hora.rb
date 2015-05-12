class AltasBajasHora < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona

  TURNO = ["M", "T"]

end

#SELECT * FROM detalle d inner join recibos r on r.nume_docu = d.nume_docu where d.nume_docu = 30284359 and d.mes = 4 and d.anio = 2015 LIMIT 0,1000
#SELECT * FROM detalle d where d.nume_docu = 30284359 and d.mes = 4 and d.anio = 2015 LIMIT 0,1000
# TRAER CARGOS ACTIVOS DE UNA PERSONA SELECT * FROM paddoc p where nume_docu = 30284359 and estado = "ALT" LIMIT 0,1000
