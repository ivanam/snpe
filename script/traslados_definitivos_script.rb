# IMPORTANTE!!: Comentar la siguiente linea en el modelo lincencium antes de ejecutar script
#
#   before_create :actualizar_estado
#
# Ejecutar
# 
# 1- rails c
# 
# 2- load "#{Rails.root}/script/traslados_definitivos_script.rb"

numeros_documentos = [25099464,
28193735,
23650416,
29115503,
33185284,
25082916,
26488053,
28745856,
22068611,
37346980,
32539014,
27975794,
35731033,
32539021,
36322171,
35694047,
26415380,
35694086,
34962351,
28745900,
31755474,
35886808,
26415368,
18100085,
24086864,
18161570,
33280310,
25789914,
17554680,
25402539,
36813070,
24125317,
35042112,
22691323,
24574849,
31795178,
16072908,
30693905,
28018909,
37065897,
36213050,
31764606,
23502316,
24311449,
34403086,
32538145,
38266206,
21702986,
37346979,
33261280,
24596903,
39897554,
32189688,
38298997,
27436832,
29589525,
29263421,
27884550,
93262302,
30197709,
29439051,
22418481,
35383557,
31672838,
27436891,
25789948,
26645723,
35277479,
38807394,
30724211,
32539044,
27531161,
22231062,
32506904,
26171973,
37389848,
25087061,
25414795,
32914420,
26738616,
28517327,
32506907,
35731029,
21055625,
35384495,
36321787,
31672849,
28953353,
27596849,
28517309,
23172807,
27531167,
25842137,
27455142,
26171861,
27436837,
35731008,
24100975,
24574856,
30040688,
22512997,
29263425,
20235679,
25789932,
22615701,
24721215,
23160114,
27977270,
26808665,
30693903,
26415370,
33770834,
27021543,
33354566,
17926784,
27679296,
35694026,
26233409,
21572487,
22540729,
22044735]

establecimiento3001 = Establecimiento.where(codigo_jurisdiccional: 3001).first
#Por cada persona del listado
personas = Persona.where(nro_documento: numeros_documentos)
personas.each do |p|
	puts "--- #{p.nro_documento}, #{p.apeynom} ---"
	#Obtengo los cargos auxiliares de la persona en el establecimiento 3001 (Delegacion I) y el de destino
	cargoOrigen3001 = CargoNoDocente.includes(:persona).where(personas: { id: p.id }, establecimiento_id: establecimiento3001.id).first
	cargoDestino = CargoNoDocente.includes(:persona, :establecimiento).where(personas: { id: p.id }).where.not(establecimiento_id: establecimiento3001.id).first	
	#Genero el traslado transitorio para el cargo auxiliar en la oficina destino
	licencia = Licencium.new
	licencia.con_certificado = true
	licencia.con_formulario = true
	licencia.cargo_no_docente_id = cargoOrigen3001.id
	licencia.fecha_desde = cargoDestino.fecha_alta
	licencia.fecha_hasta = nil
	licencia.articulo_id = Articulo.where(codigo: 907).first.id
	licencia.vigente = "Vigente"
	licencia.destino = cargoDestino.id
	licencia.observaciones = " --- Generado por sistema ---"
	licencia.nro_documento = p.nro_documento
	establecimientoUser = EstablecimientosUsers.where(establecimiento_id: establecimiento3001.id).first
	licencia.user_id = establecimientoUser.user_id
	licencia.oficina = Establecimiento.find(cargoOrigen3001.establecimiento_id).codigo_jurisdiccional
	#Solo si pude guardar continuo actulizando el registro del cargo reubicado
	if licencia.save(validate: false)
		puts "--- Licencia creada ---"
		cargoOrigen3001.estado = 'ART'
		cargoDestino.obs_lic = Articulo.where(codigo: 907).first.descripcion #Articulo 907 (Reubicacion /Traslado transitorio)
		cargoDestino.secuencia = 1000
		cargoDestino.estado = 'REU'
		if cargoDestino.save(validate: false)
			puts "--- Cargo destino actualizado! ---"
		else
			puts "--- Errores al actualizar cargo destino: --- #{cargoDestino.errors.full_messages}"
		end
	else
		puts "--- Errores al crear licencia:  --- #{licencia.errors.full_messages}"
	end
end