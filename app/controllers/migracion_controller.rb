class MigracionController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :class => false

#ARMAR VISTA DE LOS DTAOS QUE NO COINCIDEN--->>>>> NOOOO CREARRRR REGIASTROS



	def migrar_hs
		@listaAux = []
		nueva = false
		if nueva
			@escuelas = [461]
		else
			@escuelas = [2,27,43,143,146,402,403,413,421,439,440,1,4,8,20,41,47,84,167,185,190,202,401,404,414,441,504,506,508,509,512,523,525,552,603,702,704,712,725,728,729,732,749,752,767,774,776,795,7705,7727,3000,3031,4002,4006,28,78,178,403,410,412,453,459,556,2404,2412,4001,4007,5009,567,4000,4004,4009,4012,4014,4015,4016,4017,4018,175,492,4006, 411,459,3004,3000,4000,753,603, 7712,2702, 753,703,710,728,736,741,750,775,768,785,786,789,790,2701,7701,7707,7710,7726,461]
		end
		client = Mysql2::Client.new(:username => "guest",:host => "172.16.0.19",  :password => "guest", :database => "mec")
	    #client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")

	    @escuelas.each do |e|
		if nueva

		    res=client.query("select secuencia as secMax, p.* from padhc p where escuela = '"+e.to_s+"'  and estado= 'ALT' and secuencia<88 group by  nume_docu, materia, horas_cate, secuencia union
	 		select secuencia as secMax, p.* from padhc p where escuela = '"+e.to_s+"' and secuencia<88 and estado= 'LIC'  group by  nume_docu, materia, horas_cate,secuencia")
		else
	 	    #res= client.query("select secuencia as secMax, p.* from padhc p where escuela = '"+params[:esc]+"'  and estado= 'ALT' and secuencia<88 group by  nume_docu, materia, horas_cate, secuencia union
	 		#select MAX(secuencia) as secMax, p.* from padhc p where escuela = '"+params[:esc]+"' and secuencia<88 and estado= 'LIC'  group by  nume_docu, materia, horas_cate")

		    #res= client.query("SELECT secuencia as secMax, p.* FROM padhc p where (p.fecha_alta > '2017-03-01' or p.fecha_baja> '2017-03-01' ) and p.escuela= '"+params[:esc]+"' ")
		    res= client.query("SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '"+e.to_s+"' and mes = 11 and anio = 2018  and secuencia<88 and (estado = 'ALT' or estado='LIC') and fecha_baja='0000-00-00'")
		end
		    # res=client.query("SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=21769453 and (secuencia=73 or secuencia= 74 or secuencia= 72 or secuencia= 75 or secuencia=76) union 
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=18761960 and secuencia=79 union
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=18761960 and secuencia=80 union
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=21806498 and secuencia=15 union
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=18761960 and secuencia=1 union 
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=21769453 and (secuencia=72 or secuencia=73 or secuencia=74) union
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=29493795 and (secuencia=57 or secuencia = 58 )union 
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=18761960 and secuencia=2 union 
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=21769453 and secuencia=76 union
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=21769453 and secuencia=76 union
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=23923916 and secuencia=57 union
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=20858349 and secuencia=60 union 
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=20858349 and secuencia=61 union
						# 		SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '702' and mes = 7 and anio = 2017  and nume_docu=20858349 and secuencia=62")


		    esc_id= Establecimiento.where(:codigo_jurisdiccional => e).first.id
			

		    for r in res

				if Materium.where(codigo: r['materia']).first != nil then

					materia_id = Materium.where(codigo: r['materia']).first.id
				else 
					materia_id= 0
				end
				if Persona.where(:nro_documento => r['nume_docu']).first == nil then
					res2= client.query("select apeynom, fech_nac, tipo_docu,nume_docu from agentes a where nume_docu= "+ r['nume_docu'].to_s ).first
		      		#res2= client.query("select apeynom, fech_nac, tipo_docu,nume_docu from agentes a where nume_docu= "+ "36869073" ).first
		      		res3= client.query("SELECT * FROM agentes_dni_cuit a where nume_docu= "+ r['nume_docu'].to_s ).first
		
		  			if res3 == nil then
			      		persona = Persona.create(nro_documento: res2['nume_docu'] ,fecha_nacimiento: res2['fech_nac'] ,tipo_documento_id: res2['tipo_docu'] ,apeynom: res2['apeynom'].force_encoding("ASCII-8BIT").encode('UTF-8', undef: :replace, replace: ''))
			      		persona_id = persona.id
			      	else
			      		persona = Persona.create(nro_documento: res2['nume_docu'] ,fecha_nacimiento: res2['fech_nac'] ,tipo_documento_id: res2['tipo_docu'] ,apeynom: res2['apeynom'].force_encoding("ASCII-8BIT").encode('UTF-8', undef: :replace, replace: ''), cuil: res3['cuit'])
			      		persona_id = persona.id
			      	end
				else
					persona_id = Persona.where(:nro_documento => r['nume_docu']).first.id


					#buscamos el cuil en el MEC y se lo seteamos
					if Persona.where(:nro_documento => r['nume_docu']).first.cuil == nil then
						@cuil = client.query("SELECT cuit FROM agentes_dni_cuit a where nume_docu= "+ r['nume_docu'].to_s ).first
				    @personac = Persona.where(:nro_documento => r['nume_docu']).first
				    	if  @cuil != nil then
						    @personac.cuil = @cuil["cuit"]
							@personac.save
						end

					end

				end

			  	if  r['ciclo'] < 1  then
			  		plan_id = nil
			  	elsif r['ciclo'] >= 1 then 
			  		if Plan.where(:codigo => r['ciclo']).first == nil then
			  			materia_id=Materium.where(codigo: r['ciclo']).first.id
			  			plan_id= Plan.where(codigo: 122).first.id
			  			ciclo = 122
			  			if Despliegue.where(:anio => r['curso'] , :plan_id => plan_id, :materium_id => materia_id ).first == nil then
			  				Despliegue.create(anio: r['curso'] , plan_id: plan_id, materium_id: materia_id )
			  			end

			  			if EstablecimientoPlan.where(:establecimiento_id => esc_id, :plan_id => plan_id).first == nil then 
			  				EstablecimientoPlan.create(establecimiento_id: esc_id, plan_id: plan_id)
			  			end

			  		else 
			  			plan_id =  Plan.where(:codigo => r['ciclo']).first.id
			  			ciclo = r['ciclo']
			  		end
			   	end

		 
		      	situacion_revista=  r['planta_pre'].to_s+ "-"+ r['tipo_emp'].to_s

		      	hora = AltasBajasHora.where(:establecimiento_id => esc_id, :persona_id => persona_id, secuencia: r['secMax']).first	
		      	if hora == nil then


		      		if AltasBajasHora.where(:establecimiento_id => esc_id, :persona_id => persona_id, horas: r['horas_cate'], fecha_alta: r['fecha_alta'] , anio: r['curso'], division: r['division'], secuencia: nil ).first != nil
								horaSinSec = AltasBajasHora.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , horas: r['horas_cate'], anio: r['curso'], division: r['division'], secuencia: nil ).first
		      			@listaAux << horaSinSec
		      			horaSinSec.assign_attributes(secuencia: r['secMax'])
		      			if horaSinSec.save!
		      				AltasBajasHoraEstado.create(estado_id: 10, alta_baja_hora_id: horaSinSec.id)
		      			end
		      		elsif AltasBajasHora.where(:establecimiento_id => esc_id, :persona_id => persona_id, horas: r['horas_cate'], fecha_alta: r['fecha_alta'] , secuencia: r['secMax']).first == nil
		      			
		      			RegistrosParaSolucionar.create!(mes_liq: 11, anio_liq: 2018, horas_registro: 1, establecimiento_id: esc_id, persona_id: persona_id, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista, horas: r['horas_cate'], ciclo_carrera: ciclo, anio:r['curso'], division: r['division'], turno:r['turno'], codificacion: r['materia'], estado:r['estado'] , materium_id: materia_id, plan_id: plan_id )
		      		end

			      end	
			end
		end

	end
=begin
	def migracion_inversa
		listado = AltasBajasHora.all
		@eliminados = []
		@escuelas = [2,27,43,143,146,402,403,413,421,439,440,1,4,8,20,41,47,84,167,185,190,202,401,404,414,441,504,506,508,509,512,523,525,552,603,702,712,725,728,729,732,752,767,774,776,795,7705,7727,3000,3031,4002,4006,28,78,178,403,410,412,453,459,556,2404,2412,4001,4007,5009,567,4000,4004,4009,4012,4014,4015,4016,4017,4018]
		#client = Mysql2::Client.new (:username=>'root', :host=>'localhost', :password=>'root', :database=>'snpe', :local_infile => true)
	    client = Mysql2::Client.new(:username => "guest",:host => "172.16.0.19",  :password => "gest", :database => "mec", :port => 3306, :local_infile => true)

	    @escuelas.each do |e|
		res= client.query("SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '"+e.to_s+"' and mes = 1 and anio = 2018  and secuencia<88 and (estado = 'ALT' or estado='LIC') and fecha_baja='0000-00-00'")

		 for l in listado 
		 	for r in res
		 		esc_id= Establecimiento.where(:codigo_jurisdiccional => e).first.id
		 		if Persona.where(:nro_documento => r['nume_docu']).first == nil then
					res2= client.query("select apeynom, fech_nac, tipo_docu,nume_docu from agentes a where nume_docu= "+ r['nume_docu'].to_s ).first
		      		#res2= client.query("select apeynom, fech_nac, tipo_docu,nume_docu from agentes a where nume_docu= "+ "36869073" ).first
		      		res3= client.query("SELECT * FROM agentes_dni_cuit a where nume_docu= "+ r['nume_docu'].to_s ).first
		
		  			if res3 == nil then
			      		persona = Persona.create(nro_documento: res2['nume_docu'] ,fecha_nacimiento: res2['fech_nac'] ,tipo_documento_id: res2['tipo_docu'] ,apeynom: res2['apeynom'].force_encoding("ASCII-8BIT").encode('UTF-8', undef: :replace, replace: ''))
			      		persona_id = persona.id
			      	else
			      		persona = Persona.create(nro_documento: res2['nume_docu'] ,fecha_nacimiento: res2['fech_nac'] ,tipo_documento_id: res2['tipo_docu'] ,apeynom: res2['apeynom'].force_encoding("ASCII-8BIT").encode('UTF-8', undef: :replace, replace: ''), cuil: res3['cuit'])
			      		persona_id = persona.id
			      	end
				else
					persona_id = Persona.where(:nro_documento => r['nume_docu']).first.id
				end 

		 		if !(l.establecimiento_id == esc_id && l.persona_id==persona_id && l.secuencia == r['secMax'] && l.fecha_alta == r['fecha_alta'] && l.horas == r['horas_cate'])
		 			@eliminados<< l
		 			l.delete
		 		end
		 	end
		 end
		end
	end 


	def pofs

		anio = 2017


	 		esc_id= Establecimiento.where(:codigo_jurisdiccional => params[:esc]).first.id
	 		
	 		if HistorialCargos.where(establecimiento_id: esc_id).count == 0
	
		 		cargos1 = Cargo.where(establecimiento_id: esc_id, estado: 'ALT')
		 		cargos2 =Cargo.where(establecimiento_id: esc_id, estado: 'LIC')
		 		cargos3 =Cargo.where(establecimiento_id: esc_id, estado: 'ART')

		 		cargos1.each do |cargo1|
		 			HistorialCargos.create(establecimiento_id: cargo1.establecimiento_id, persona_id:cargo1.persona_id, cargo: cargo1.cargo, secuencia: cargo1.secuencia, situacion_revista: cargo1.situacion_revista, turno: cargo1.turno, anio: cargo1.anio , curso: cargo1.curso, fecha_alta: cargo1.fecha_alta, fecha_baja: cargo1.fecha_baja, persona_reemplazada_id: cargo1.persona_reemplazada_id, observatorio: cargo1.observatorio, alta_lote_impresion_id: cargo1.alta_lote_impresion_id, division: cargo1.division, observaciones: cargo1.observaciones,baja_lote_impresion_id: cargo1.baja_lote_impresion_id, empresa_id: cargo1.empresa_id, lugar_pago_id: cargo1.lugar_pago_id, con_movilidad: cargo1.con_movilidad,grupo_id: cargo1.grupo_id, ina_injustificadas: cargo1.ina_injustificadas, licencia_desde: cargo1.licencia_desde, licencia_hasta: cargo1.licencia_hasta, cantidad_dias_licencia: cargo1.cantidad_dias_licencia, motivo_baja: cargo1.motivo_baja, estado: cargo1.estado, materium_id: cargo1.materium_id, disposicion: cargo1.disposicion, resolucion: cargo1.resolucion, anio_pof: anio)
		 		end
		 		cargos2.each do |cargo2|
		 			HistorialCargos.create(establecimiento_id: cargo2.establecimiento_id, persona_id:cargo2.persona_id, cargo: cargo2.cargo, secuencia: cargo2.secuencia, situacion_revista: cargo2.situacion_revista, turno: cargo2.turno, anio: cargo2.anio , curso: cargo2.curso, fecha_alta: cargo2.fecha_alta, fecha_baja: cargo2.fecha_baja, persona_reemplazada_id: cargo2.persona_reemplazada_id, observatorio: cargo2.observatorio, alta_lote_impresion_id: cargo2.alta_lote_impresion_id, division: cargo2.division, observaciones: cargo2.observaciones,baja_lote_impresion_id: cargo2.baja_lote_impresion_id, empresa_id: cargo2.empresa_id, lugar_pago_id: cargo2.lugar_pago_id, con_movilidad: cargo2.con_movilidad,grupo_id: cargo2.grupo_id, ina_injustificadas: cargo2.ina_injustificadas, licencia_desde: cargo2.licencia_desde, licencia_hasta: cargo2.licencia_hasta, cantidad_dias_licencia: cargo2.cantidad_dias_licencia, motivo_baja: cargo2.motivo_baja, estado: cargo2.estado, materium_id: cargo2.materium_id, disposicion: cargo2.disposicion, resolucion: cargo2.resolucion, anio_pof: anio)
		 		end
		 		cargos3.each do |cargo3|
		 			HistorialCargos.create(establecimiento_id: cargo3.establecimiento_id, persona_id:cargo3.persona_id, cargo: cargo3.cargo, secuencia: cargo3.secuencia, situacion_revista: cargo3.situacion_revista, turno: cargo3.turno, anio: cargo3.anio , curso: cargo3.curso, fecha_alta: cargo3.fecha_alta, fecha_baja: cargo3.fecha_baja, persona_reemplazada_id: cargo3.persona_reemplazada_id, observatorio: cargo3.observatorio, alta_lote_impresion_id: cargo3.alta_lote_impresion_id, division: cargo3.division, observaciones: cargo3.observaciones,baja_lote_impresion_id: cargo3.baja_lote_impresion_id, empresa_id: cargo3.empresa_id, lugar_pago_id: cargo3.lugar_pago_id, con_movilidad: cargo3.con_movilidad,grupo_id: cargo3.grupo_id, ina_injustificadas: cargo3.ina_injustificadas, licencia_desde: cargo3.licencia_desde, licencia_hasta: cargo3.licencia_hasta, cantidad_dias_licencia: cargo3.cantidad_dias_licencia, motivo_baja: cargo3.motivo_baja, estado: cargo3.estado, materium_id: cargo3.materium_id, disposicion: cargo3.disposicion, resolucion: cargo3.resolucion, anio_pof: anio)
		 		end
		 	end
		
	
	
	end 

=end


	def migrar_cargos

		@listacargoSinSec = []
		nueva = false
		if nueva
			@escuelas = [461]
		else
			@escuelas = [1,2,27,43,143,146,402,403,413,421,439,440,4,8,20,41,47,84,167,185,190,202,401,404,414,441,504,506,508,509,512,523,525,552,603,702,704,711,712,725,728,729,732,749,752,767,774,776,795,7705,7727,3000,3031,4002,4006,28,78,178,403,410,412,453,459,556,2404,2412,4001,4007,5009,567,4000,4004,4009,4012,4014,4015,4016,4017,4018,492,175,787,7718,411,459,3004,753,603,7712,2702, 753,703,710,728,736,741,750,775,768,785,786,789,790,2701,7701,7707,7710,7726,3001]
		end

		client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")
	 	
	    @escuelas.each do |e|

	    	if nueva

	    		res= client.query("select secuencia as secMax, p.* from paddoc p where escuela = '"+e.to_s+"'  and estado= 'ALT' and  secuencia<88 group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r union
				 select secuencia as secMax, p.* from paddoc p where escuela = '"+e.to_s+"' and secuencia<88  and estado= 'LIC' group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r")
	    		
	    	else
		    	res= client.query("SELECT secuencia as secMax, p.* FROM his_paddoc p where  p.escuela= '"+e.to_s+"'and secuencia<88 and mes = 11 and anio = 2018 and (estado = 'ALT' or estado='LIC') and fecha_baja='0000-00-00' ")
		    end


			esc_id= Establecimiento.where(:codigo_jurisdiccional => e).first.id

			for r in res

				materia_id = nil

				if Persona.where(:nro_documento => r['nume_docu']).first == nil then

					res2= client.query("select apeynom, fech_nac, tipo_docu,nume_docu from agentes a where nume_docu= "+ r['nume_docu'].to_s ).first
		      		#res2= client.query("select apeynom, fech_nac, tipo_docu,nume_docu from agentes a where nume_docu= "+ "36869073" ).first
		      		res3= client.query("SELECT * FROM agentes_dni_cuit a where nume_docu= "+ r['nume_docu'].to_s ).first
			
		  			if res3 == nil then
			      		persona = Persona.create(nro_documento: res2['nume_docu'] ,fecha_nacimiento: res2['fech_nac'] ,tipo_documento_id: res2['tipo_docu'] ,apeynom: res2['apeynom'].force_encoding("ASCII-8BIT").encode('UTF-8', undef: :replace, replace: ''))
			      		persona_id = persona.id

			      	else
			      		persona = Persona.create(nro_documento: res2['nume_docu'] ,fecha_nacimiento: res2['fech_nac'] ,tipo_documento_id: res2['tipo_docu'] ,apeynom: res2['apeynom'].force_encoding("ASCII-8BIT").encode('UTF-8', undef: :replace, replace: ''), cuil: res3['cuit'])
			      		persona_id = persona.id
		      		end

				else
					persona_id = Persona.where(:nro_documento => r['nume_docu']).first.id

					#buscamos el cuil en el MEC y se lo seteamos
					if Persona.where(:nro_documento => r['nume_docu']).first.cuil == nil then
						@cuil = client.query("SELECT cuit FROM agentes_dni_cuit a where nume_docu= "+ r['nume_docu'].to_s ).first
				    	@personac = Persona.where(:nro_documento => r['nume_docu']).first
					    if  @cuil != nil then
						    @personac.cuil = @cuil["cuit"]
						    @personac.save
						end

					end
				end


			  	if r['cargo_r'].to_s.size == 1 then
			  		cargo_concat=  r['agrup_r'].to_s+ "0" + r['cargo_r'].to_s
			  	else 		
			  		cargo_concat=  r['agrup_r'].to_s+ r['cargo_r'].to_s
			  	end

			  	if Funcion.where(:categoria => cargo_concat).first != nil
	       		  categoria = Funcion.where(:categoria => cargo_concat).first.categoria
	       		end
	       		situacion_revista=  r['planta_pre'].to_s+ "-"+ r['tipo_emp'].to_s
	       
	      	
	       		cargo = Cargo.where(:establecimiento_id => esc_id, :persona_id => persona_id, secuencia: r['secMax']).first


		   		if cargo == nil then

		      		if Cargo.where(:establecimiento_id => esc_id, :persona_id => persona_id, cargo: categoria, secuencia: nil, fecha_alta: r['fecha_alta'] ).first != nil
						cargoSinSec = Cargo.where(:establecimiento_id => esc_id, :persona_id => persona_id, cargo: categoria, secuencia: nil, fecha_alta: r['fecha_alta']).first
		       			@listacargoSinSec << cargoSinSec
		      			cargoSinSec.assign_attributes(secuencia: r['secMax'])
		      			if cargoSinSec.save!
		      				CargoEstado.create(estado_id: 10, cargo_id: cargoSinSec.id)
		      			end
		       		elsif 
		       			Cargo.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: r['secMax'], cargo: categoria ).first == nil
		       			RegistrosParaSolucionar.create!(mes_liq: 11, anio_liq: 2018, cargos_registro: 1,establecimiento_id: esc_id, persona_id: persona_id, cargo: categoria, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista,  anio:r['curso'], division: r['division'], turno:r['turno'],   estado:r['estado'] , materium_id: materia_id)
		       		end

				end	

			end
		end
	end


	def migrar_auxiliares
		@listacargoNSinSec = []
		nueva =  false
		if nueva
			@escuelas = [461]
		else
			@escuelas = [1,2,27,43,143,146,402,403,413,421,439,440,4,8,20,41,47,84,167,185,190,202,401,404,414,441,504,506,508,509,512,523,525,552,603,702,704,732,749,712,725,728,729,732,752,767,774,776,795,7705,7727,3000,3031,4002,4006,28,78,178,403,410,412,453,459,556,2404,2412,4001,4007,5009,567,4000,4004,4009,4012,4014,4015,4016,4017,4018,175,492,411,411,459,3004,753,604,3004,7712,2702, 753,703,710,728,736,741,750,775,768,785,786,789,790,2701,7701,7707,7710,7726,3001]
		end
		client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")


		@escuelas.each do |e|
			if nueva
	 	  		res = client.query("select secuencia as secMax, p.* from padaux p where escuela = '"+e.to_s+"'  and estado= 'ALT' and secuencia=0 group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r union
	 		select secuencia as secMax, p.* from padaux p where escuela = '"+e.to_s+"' and secuencia<88 and estado= 'LIC'  group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r")
	 				
			else
				res= client.query("SELECT secuencia as secMax, p.* FROM his_padaux p where  p.escuela= '"+e.to_s+"'and secuencia<88 and mes = 11 and anio = 2018 and (estado = 'ALT' or estado='LIC') and fecha_baja='0000-00-00'")
	 	    end
	 	    #res= client.query("SELECT  secuencia as secMax, p.*  FROM padaux p where (p.fecha_alta > '2017-01-01' or p.fecha_baja> '2017-01-01' ) and p.escuela='"+params[:esc]+"' ")

			esc_id= Establecimiento.where(:codigo_jurisdiccional => e).first.id

			for r in res

				materia_id = nil

				if Persona.where(:nro_documento => r['nume_docu']).first == nil then

					res2= client.query("select apeynom, fech_nac, tipo_docu,nume_docu from agentes a where nume_docu= "+ r['nume_docu'].to_s ).first
			      	#res2= client.query("select apeynom, fech_nac, tipo_docu,nume_docu from agentes a where nume_docu= "+ "36869073" ).first
			      	res3= client.query("SELECT * FROM agentes_dni_cuit a where nume_docu= "+ r['nume_docu'].to_s ).first
			
			  		if res3 == nil then
				      	persona = Persona.create(nro_documento: res2['nume_docu'] ,fecha_nacimiento: res2['fech_nac'] ,tipo_documento_id: res2['tipo_docu'] ,apeynom: res2['apeynom'].force_encoding("ASCII-8BIT").encode('UTF-8', undef: :replace, replace: ''))
				      	persona_id = persona.id

				    else
				      	persona = Persona.create(nro_documento: res2['nume_docu'] ,fecha_nacimiento: res2['fech_nac'] ,tipo_documento_id: res2['tipo_docu'] ,apeynom: res2['apeynom'].force_encoding("ASCII-8BIT").encode('UTF-8', undef: :replace, replace: ''), cuil: res3['cuit'])
				      	persona_id = persona.id
				    end

				else
					persona_id = Persona.where(:nro_documento => r['nume_docu']).first.id
						
						#buscamos el cuil en el MEC y se lo seteamos
					if Persona.where(:nro_documento => r['nume_docu']).first.cuil == nil then
						@cuil = client.query("SELECT cuit FROM agentes_dni_cuit a where nume_docu= "+ r['nume_docu'].to_s ).first
						@personac = Persona.where(:nro_documento => r['nume_docu']).first
							if  @cuil != nil then
							    @personac.cuil = @cuil["cuit"]
							    @personac.save
							end

					end
				end

			  if Cargosnd.where(:cargo_agrup => r['agrup_r'], :cargo_cod => r['cargo_r'], :cargo_categ => r['categ_r']).first != nil
			  cargo_id = Cargosnd.where(:cargo_agrup => r['agrup_r'], :cargo_cod => r['cargo_r'], :cargo_categ => r['categ_r']).first.id
			end

			      	
			  situacion_revista=  r['planta_pre'].to_s+ "-"+ r['tipo_emp'].to_s


	          cargond = CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, secuencia: r['secMax']).first



	      	  if cargond == nil then
		      		if CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, cargo: cargo_id, secuencia: nil, fecha_alta: r['fecha_alta']).first != nil
						cargoNSinSec = CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, cargo: cargo_id, secuencia: nil, fecha_alta: r['fecha_alta']).first
		     			@listacargoNSinSec << cargoNSinSec
		      			cargoNSinSec.assign_attributes(secuencia: r['secMax'])
		      			if cargoNSinSec.save!
		      				CargoNoDocenteEstado.create(estado_id: 10, cargo_no_docente_id: cargoNSinSec.id)
		      			end
		       		elsif 
		       			CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: r['secMax'], cargo: cargo_id ).first == nil
								RegistrosParaSolucionar.create!(mes_liq: 11, anio_liq: 2018, auxiliar_registro: 1, establecimiento_id: esc_id, persona_id: persona_id, cargo: cargo_id, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista,  turno:r['turno'], estado:r['estado'])
	      	  
					end    	
		       end	

		  	end

		  end
	end

end

