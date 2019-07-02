
#todas 
SELECT h.fecha_alta, p.nro_documento, h.secuencia, e.codigo_jurisdiccional, h.ciclo_carrera, h.anio, h.division, m.codigo , h.turno, count(*)
FROM (select * from snpe.altas_bajas_horas as d order by d.created_at desc) as h , snpe.establecimientos as e, snpe.personas as p, snpe.plans as pl, snpe.materia as m

where p.id=h.persona_id and e.id=h.establecimiento_id and pl.id=h.plan_id and h.materium_id=m.id

and h.ciclo_carrera is not null and h.ciclo_carrera != 60 and h.materium_id is not null and h.materium_id != 1348 and h.materium_id != 1346 and h.materium_id != 1994

and e.sede is null and h.estado = 'ALT' and year(h.created_at) > 2018 and (h.lote_impresion_id is null)

group by  establecimiento_id, ciclo_carrera, anio, division, materium_id, turno having count(*) > 1 order by count(*) desc;


#todas por persona
SELECT h.fecha_alta, p.nro_documento, h.secuencia, e.codigo_jurisdiccional, h.ciclo_carrera, h.anio, h.division, m.codigo , h.turno, count(*)
FROM (select * from snpe.altas_bajas_horas as d order by d.created_at desc) as h , snpe.establecimientos as e, snpe.personas as p, snpe.plans as pl, snpe.materia as m

where p.id=h.persona_id and e.id=h.establecimiento_id and pl.id=h.plan_id and h.materium_id=m.id

and h.ciclo_carrera is not null and h.ciclo_carrera != 60 and h.materium_id is not null and h.materium_id != 1348 and h.materium_id != 1346 and h.materium_id != 1994

and e.sede is null and h.estado = 'ALT' and year(h.created_at) > 2018 and (h.lote_impresion_id is null)

group by persona_id, establecimiento_id, ciclo_carrera, anio, division, materium_id, turno having count(*) > 1 order by count(*) desc;






#creadas desde el sistema

SELECT h.fecha_alta, p.nro_documento, h.secuencia, e.codigo_jurisdiccional, pl.codigo , h.anio, h.division, m.codigo , h.turno, count(*)
FROM (select * from snpe.altas_bajas_horas as d order by d.created_at desc) as h , snpe.establecimientos as e, snpe.personas as p, snpe.plans as pl, snpe.materia as m
where p.id=h.persona_id and e.id=h.establecimiento_id and pl.id=h.plan_id and h.materium_id=m.id
and plan_id is not null
and h.materium_id != 1348 and h.materium_id != 1346 and h.materium_id != 1994
and e.sede is null and h.estado = 'ALT' and h.lote_impresion_id is not null
and year(h.created_at) = 2019 and month(h.created_at) = 4
group by establecimiento_id, ciclo_carrera, anio, division, materium_id, turno having count(*) > 1 order by e.codigo_jurisdiccional;


#creada spor sistema y por persona

SELECT h.fecha_alta, p.nro_documento, h.secuencia, e.codigo_jurisdiccional, pl.codigo , h.anio, h.division, m.codigo , h.turno, count(*)
FROM (select * from snpe.altas_bajas_horas as d order by d.created_at desc) as h , snpe.establecimientos as e, snpe.personas as p, snpe.plans as pl, snpe.materia as m
where p.id=h.persona_id and e.id=h.establecimiento_id and pl.id=h.plan_id and h.materium_id=m.id
and plan_id is not null
and h.materium_id != 1348 and h.materium_id != 1346 and h.materium_id != 1994
and e.sede is null and h.estado = 'ALT' and h.lote_impresion_id is not null
and year(h.created_at) = 2019 and month(h.created_at) = 4
group by h.persona_id, establecimiento_id, ciclo_carrera, anio, division, materium_id, turno having count(*) > 1 order by e.codigo_jurisdiccional;





