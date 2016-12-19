
#CONSULTA CARGAR CARGOS DOCENTES#
select e.id as 'establecimiento_id', e.codigo_jurisdiccional, c.id as 'cargo', pe.id as 'persona_id', p.nume_docu, p.secuencia, 
CONCAT(p.planta_pre,'-', p.tipo_emp) as 'situacion rev', p.fecha_alta, p.fecha_baja, p.estado, em.id as 'empresa_id'
from snpe.funcions as c, snpe.paddoc as p, snpe.establecimientos as e, snpe.personas as pe, snpe.empresas as em
where p.nume_docu =pe.nro_documento and em.nombre=p.empresa and c.categ;
a = (IF(LENGTH(p.cargo_r)=1,CONCAT('0', p.agrup_r, p.cargo_r),CONCAT('', p.agrup_r, p.cargo_r))) 
and e.codigo_jurisdiccional = p.escuela group by e.id, e.codigo_jurisdiccional, c.descripcion, p.nume_docu, c.categoria



#CONSULTA CARGAR CARGOS NO DOCENTES#
select e.id as 'establecimiento_id', pe.id as 'persona_id', c.id as 'cargo',  p.secuencia, 
 p.fecha_alta, p.fecha_baja, em.id as 'empresa_id', CONCAT(p.planta_pre,'-', p.tipo_emp) as 'situacion rev',   p.aa_antig, p.mm_antig, p.dd_antig, p.agrup_r, p.cargo_r , p.categ_r, p.planta_pre, p.tipo_emp
from snpe.cargosnds as c, snpe.padaux as p, snpe.establecimientos as e, snpe.personas as pe, snpe.empresas as em
where p.nume_docu =pe.nro_documento and em.nombre=p.empresa and 
c.cargo_agrup = p.agrup_r and c.cargo_cod=p.cargo_r and c.cargo_categ =p.categ_r
and e.codigo_jurisdiccional = p.escuela 
group by e.id, pe.id , c.id ,  p.secuencia, 
 p.fecha_alta, p.fecha_baja, em.id, 'situacion rev',   p.aa_antig, p.mm_antig, p.dd_antig, p.agrup_r, p.cargo_r , p.categ_r, p.planta_pre, p.tipo_emp


#El que andaaaaaaaaaaaaa d ecargos no docentes

select * from snpe.padaux as p
join snpe.personas as pe ON p.nume_docu =pe.nro_documento
join snpe.empresas as em on em.nombre=p.empresa
join snpe.establecimientos as e on e.codigo_jurisdiccional = p.escuela 
join snpe.cargosnds as c on c.cargo_agrup = p.agrup_r 
and c.cargo_cod=p.cargo_r and c.cargo_categ =p.categ_r
group by p.nume_docu, p.escuela, p.categ_r, p.cargo_r, p.agrup_r 


select * from snpe.padaux as p
join snpe.personas as pe ON p.nume_docu =pe.nro_documento
join snpe.empresas as em on em.nombre=p.empresa
join snpe.establecimientos as e on e.codigo_jurisdiccional = p.escuela 
group by p.nume_docu, p.escuela 



#consulta para separa campos para la exportacion
 SELECT substring(ley_r, 1 , 1) as 'primero', substring(ley_r, 2 , 2) as 'segundo' FROM snpe.padaux;


#agregar a la tabla del mec
insert into snpe.establecimientos (codigo_jurisdiccional) values (19);
insert into snpe.establecimientos (codigo_jurisdiccional) values (86);
insert into snpe.establecimientos (codigo_jurisdiccional) values (131);
 insert into snpe.establecimientos (codigo_jurisdiccional) values (131) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (145) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (215) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (483) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (484) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (493) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (497) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (568) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (816) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (903) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (2002) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (3019) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (3021) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (3042) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (3044) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (5006) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (5007) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (5009) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (5011) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (5012) ;
 insert into snpe.establecimientos (codigo_jurisdiccional) values (7712);


#para importar escuela 4 primero creo la tabla 
CREATE TABLE  `snpe`.`escuela4` (
  `escuela` int(4) NOT NULL default '0',
  `prog` int(2) NOT NULL default '0',
  `ley_r` int(2) NOT NULL default '0',
  `agrup_r` int(2) NOT NULL default '0',
  `cargo_r` int(3) NOT NULL default '0',
  `categ_r` int(2) NOT NULL default '0',
  `ley_s` int(2) NOT NULL default '0',
  `agrup_s` int(2) NOT NULL default '0',
  `cargo_s` int(3) NOT NULL default '0',
  `categ_s` int(2) NOT NULL default '0',
  `fecha_ing` date NOT NULL default '0000-00-00',
  `fecha_alta` date NOT NULL default '0000-00-00',
  `fecha_baja` date NOT NULL default '0000-00-00',
  `planta_pre` int(4) NOT NULL default '0',
  `tipo_emp` int(3) NOT NULL default '0',
  `horas_cate` int(4) NOT NULL default '0',
  `tipo_docu` int(1) NOT NULL default '0',
  `nume_docu` int(11) NOT NULL default '0',
  `secuencia` int(2) NOT NULL default '0',
  `apeynom` char(30) NOT NULL default '',
  `materia` int(4) NOT NULL default '0',
  `curso` int(1) NOT NULL default '0',
  `division` int(1) NOT NULL default '0',
  `turno` char(3) NOT NULL default '',
   `estado` char(3) NOT NULL default '',
  `empresa` char(6) NOT NULL default '',
  `aa_antig` int(4) NOT NULL default '0',
  `mm_antig` int(4) NOT NULL default '0',
  `dd_antig` int(4) NOT NULL default '0',
 `observaciones` char(50) NOT NULL default ''

) COMMENT='PADRON DE CARGOS DOCENTES'


/*
select * from snpe.escuela4 as p
join snpe.personas as pe ON p.nume_docu =pe.nro_documento
join snpe.empresas as em on em.nombre=p.empresa
join snpe.establecimientos as e on e.codigo_jurisdiccional = p.escuela 
join snpe.funcions as c on c.categoria = (IF(LENGTH(p.cargo_r)=1,CONCAT_WS('0', p.agrup_r, p.cargo_r),CONCAT_WS('', p.agrup_r, p.cargo_r))) order by nume_docu
*/



#escuela 4 escript para importar#

select e.id as establecimiento_id, pe.id as persona_id, c.categoria as cargo, p.secuencia, CONCAT(p.planta_pre,'-', p.tipo_emp) as 'situacion rev', 
p.fecha_alta as fecha_alta, p.fecha_baja as fecha_baja , p.turno as turno, p.curso as anio, p.division as division, p.materia as materia_id,
p.estado as estado, em.id as 'empresa_id'
from snpe.escuela4 as p
join snpe.personas as pe ON p.nume_docu =pe.nro_documento
join snpe.empresas as em on em.nombre=p.empresa
join snpe.establecimientos as e on e.codigo_jurisdiccional = p.escuela 
join snpe.funcions as c on c.categoria = (IF(LENGTH(p.cargo_r)=1,CONCAT_WS('0', p.agrup_r, p.cargo_r),CONCAT_WS('', p.agrup_r, p.cargo_r))) order by nume_docu

insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	32	,	111	,	13	,'	1-3	','	2012-03-04	','	0000-00-00	',	"	T	"	,	6	,	4	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	3165	,	111	,	4	,'	1-1	','	0000-00-00	','	0000-00-00	',	"	T	"	,	5	,	2	,	0	,'	LIC	',	3	,'	"	ART.29	"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	6944	,	112	,	4	,'	1-1	','	1986-10-08	','	0000-00-00	',	"	M	"	,	0	,	0	,	440	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	5552	,	112	,	2	,'	1-1	','	0000-00-00	','	0000-00-00	',	"		"	,	0	,	0	,	440	,'	LIC	',	3	,'	"	ART.30	"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	16138	,	111	,	24	,'	1-3	','	2016-02-29	','	0000-00-00	',	"	T	"	,	5	,	2	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	10965	,	711	,	1	,'	1-2	','	2001-03-14	','	0000-00-00	',	"		"	,	0	,	0	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	6954	,	112	,	4	,'	1-1	','	2000-03-13	','	0000-00-00	',	"	M	"	,	0	,	0	,	363	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	9933	,	112	,	1	,'	1-1	','	1993-02-26	','	0000-00-00	',	"	M	"	,	1	,	0	,	440	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	20786	,	117	,	22	,'	2-3	','	2012-03-05	','	0000-00-00	',	"	M	"	,	0	,	0	,	363	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	8041	,	306	,	2	,'	1-1	','	1987-03-23	','	0000-00-00	',	"	M-"	,	0	,	0	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	9940	,	111	,	20	,'	1-1	','	2016-09-01	','	0000-00-00	',	"	T	"	,	6	,	2	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	10054	,	111	,	22	,'	1-1	','	2012-02-22	','	0000-00-00	',	"		"	,	0	,	0	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	6964	,	111	,	14	,'	1-1	','	0000-00-00	','	0000-00-00	',	"	T	"	,	1	,	3	,	0	,'	LIC	',	3	,'	"	29	"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	6964	,	306	,	18	,'	2-3	','	2016-02-23	','	0000-00-00	',	"	T	"	,	1	,	3	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	19340	,	117	,	23	,'	1-1	','	2015-02-20	','	0000-00-00	',	"	T	"	,	0	,	0	,	440	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	22064	,	111	,	50	,'	1-1	','	2015-02-20	','	0000-00-00	',	"	T	"	,	5	,	3	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	19295	,	111	,	47	,'	2-3	','	2013-02-27	','	0000-00-00	',	"	T	"	,	6	,	2	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	9941	,	111	,	7	,'	1-1	','	2015-02-20	','	0000-00-00	',	"	T	"	,	4	,	2	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	7745	,	117	,	26	,'	1-3	','	2016-03-17	','	0000-00-00	',	"	T	"	,	0	,	0	,	440	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	6966	,	108	,	13	,'	1-2	','	2016-02-23	','	0000-00-00	',	"	T	"	,	0	,	0	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	6966	,	111	,	8	,'	1-1	','	0000-00-00	','	0000-00-00	',	"	T	"	,	1	,	4	,	0	,'	LIC	',	3	,'	"	ART.29	"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	22087	,	111	,	59	,'	1-1	','	2015-02-20	','	0000-00-00	',	"	M	"	,	2	,	2	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	19291	,	111	,	40	,'	1-1	','	0000-00-00	','	0000-00-00	',	"	M	"	,	3	,	1	,	0	,'	LIC	',	3	,'	"	ART.29	"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	19291	,	113	,	46	,'	1-3	','	2015-07-02	','	0000-00-00	',	"	M-"	,	0	,	0	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	6962	,	108	,	44	,'	2-3	','	2016-08-15	','	0000-00-00	',	"		"	,	0	,	0	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	6962	,	111	,	41	,'	2-3	','	2010-08-08	','	0000-00-00	',	"	T	"	,	1	,	2	,	0	,'	LIC	',	3	,'	"	ART.30	"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	6962	,	111	,	43	,'	1-1	','	0000-00-00	','	0000-00-00	',	"	T	"	,	2	,	4	,	0	,'	LIC	',	3	,'	"	ART.29	"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	7206	,	111	,	24	,'	2-3	','	2016-02-26	','	0000-00-00	',	"	M	"	,	1	,	2	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	9358	,	111	,	41	,'	1-3	','	2016-02-26	','	0000-00-00	',	"	T	"	,	1	,	4	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	7958	,	111	,	23	,'	1-1	','	2012-02-22	','	0000-00-00	',	"	T	"	,	3	,	3	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	20755	,	111	,	27	,'	1-1	','	2015-02-20	','	0000-00-00	',	"	M	"	,	6	,	1	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	20257	,	111	,	3	,'	2-3	','	2015-07-02	','	0000-00-00	',	"	T	"	,	2	,	3	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	20257	,	111	,	2	,'	1-2	','	2015-03-11	','	0000-00-00	',	"	M	"	,	5	,	1	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	1225	,	111	,	42	,'	2-3	','	2016-03-30	','	0000-00-00	',	"	T	"	,	4	,	2	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	9371	,	116	,	18	,'	1-1	','	2012-02-22	','	0000-00-00	',	"	M	"	,	2	,	1	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	26266	,	117	,	13	,'	1-2	','	2012-03-14	','	0000-00-00	',	"	T	"	,	0	,	0	,	363	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	29845	,	111	,	43	,'	1-3	','	2015-02-27	','	0000-00-00	',	"	M	"	,	4	,	1	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	21334	,	111	,	40	,'	1-1	','	2015-02-20	','	0000-00-00	',	"	M	"	,	1	,	1	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	22556	,	111	,	83	,'	1-3	','	2016-02-23	','	0000-00-00	',	"	T	"	,	1	,	3	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	9081	,	111	,	61	,'	1-1	','	2012-02-22	','	0000-00-00	',	"	M	"	,	3	,	1	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	24095	,	111	,	11	,'	1-1	','	0000-00-00	','	0000-00-00	',	"	T	"	,	2	,	3	,	0	,'	LIC	',	3	,'	"	ART.30	"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	32041	,	111	,	22	,'	2-3	','	2014-03-09	','	0000-00-00	',	"	T	"	,	4	,	1	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	35007	,	117	,	38	,'	1-3	','	2016-03-01	','	0000-00-00	',	"	M	"	,	0	,	0	,	1836	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	29654	,	117	,	5	,'	2-3	','	2013-05-20	','	0000-00-00	',	"	T	"	,	0	,	0	,	363	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	39935	,	117	,	2	,'	2-4	','	2016-02-29	','	0000-00-00	',	"	T	"	,	0	,	0	,	1836	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	38905	,	111	,	26	,'	2-3	','	2015-07-07	','	0000-00-00	',	"	M	"	,	3	,	2	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	38289	,	111	,	12	,'	2-4	','	2016-08-17	','	0000-00-00	',	"	M	"	,	2	,	2	,	0	,'	ALT	',	3	,'	"		"	');
insert into snpe.cargos( establecimiento_id, persona_id, cargo, secuencia, situacion_revista, fecha_alta, fecha_baja, turno, anio, division, materium_id, estado,empresa_id, observaciones) values(	4	,	34469	,	111	,	33	,'	2-3	','	2016-05-10	','	0000-00-00	',	"	T	"	,	5	,	2	,	0	,'	ALT	',	3	,'	"		"	');
