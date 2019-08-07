##CARGOS

select e.codigo_jurisdiccional as Establecimiento, 
concat(p.apeynom ,' - ' ,p.nro_documento) as Persona ,
if( h.secuencia is not null, h.secuencia, "") as secuencia, 
concat(h.cargo, "-", f.descripcion ) as Cargo,
h.turno as Turno, 
h.anio as Año, 
h.division as Division,
h.grupo_id as Grupo, 
h.situacion_revista as SitRevista,
h.estado as Estado, 
h.fecha_alta as FechaAlta,
if (h.fecha_baja is not null, h.fecha_baja, "") as FechaBaja,
if ((select a.codigo from snpe.licencia as l, snpe.articulos as a 
where h.id = l.cargo_id and a.id=l.articulo_id and l.vigente = "Vigente" limit 1) is not null, (select a.codigo from snpe.licencia as l, snpe.articulos as a 
where h.id = l.cargo_id and a.id=l.articulo_id and l.vigente = "Vigente" limit 1), "") as Artículo,
if (h.obs_lic is not null, (select l.oficina from snpe.licencia as l, snpe.articulos as a
where p.nro_documento = l.nro_documento and a.id=l.articulo_id and a.descripcion like '%Reubi%' limit 1), "") as EscuelaOrigen
from snpe.cargos as h  ,
snpe.establecimientos as e ,
snpe.personas as p, 
snpe.funcions as f
where h.persona_id=p.id and h.establecimiento_id = e.id and f.categoria=h.cargo
and estado != 'LIC P/BAJ'and e.nivel_id=3 order by e.codigo_jurisdiccional, h.cargo, h.turno, h.anio, h.division, h.grupo_id;


##HORAS
select e.codigo_jurisdiccional as Establecimiento, 
concat(p.apeynom ,' - ' ,p.nro_documento) as Persona ,
if( h.secuencia is not null, h.secuencia, "") as secuencia, 
if ((select pl.descripcion from snpe.plans as pl where h.plan_id = pl.id) is not null,(select pl.descripcion from snpe.plans as pl 
where h.plan_id = pl.id), "")  as Plan, 
h.turno as Turno, 
h.anio as Año, 
h.division as Division,
m.descripcion as Materia, 
h.situacion_revista as SitRevista, 
h.horas as CantHoras,
h.estado as Estado, 
h.fecha_alta as FechaAlta, 
if (h.fecha_baja is not null, h.fecha_baja, "") as FechaBaja,
if ((select a.codigo from snpe.licencia as l, snpe.articulos as a 
where h.id = l.altas_bajas_hora_id and a.id=.l.articulo_id and l.vigente = "Vigente" limit 1) is not null, (select a.codigo from snpe.licencia as l, snpe.articulos as a 
where h.id = l.altas_bajas_hora_id and a.id=.l.articulo_id and l.vigente = "Vigente" limit 1), "") as Artículo
from snpe.altas_bajas_horas as h  ,
snpe.establecimientos as e ,
snpe.personas as p, 
snpe.materia as m
where h.persona_id=p.id and h.establecimiento_id = e.id and m.id= h.materium_id
and estado != 'LIC P/BAJ'and e.nivel_id=3 
order by e.codigo_jurisdiccional,  h.ciclo_carrera, h.turno, h.anio, h.division, h.materium_id, h.situacion_revista;