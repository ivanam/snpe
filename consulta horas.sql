SELECT r.nume_docu, r.tipo_docu, r.secuencia, r.apynom, r.escuela, r.mes, r.anio, r.empresa, d.importe FROM recibos  r
inner join detalle d on (r.nume_docu = d.nume_docu and r.secuencia = d.secuencia and r.escuela = d.escuela and d.codigo = 2808 and r.mes = d.mes and r.anio = d.anio)
where (r.mes = 5 and r.anio = 2015 and r.hab_c_apor != 0.00 and r.escu = 0 and r.nume_docu = 30284359)