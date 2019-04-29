class MigracionController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :class => false

	$mes = 3
	$anio = 2019
	$nueva = true
	#$escuelasNuevas = [3002]
	$escuelasNuevas = [410,430,434,448,449,457,461,462,464,475,480,482,486,487,495,498,2401,2405,2406,2407,2408,516,520,524,526,528,556]
  #en la vista registros para controlar hay q permitir dar de alta;

	def migrar_hs
		@listaAux = []
		@escuelas = []
		if $nueva
			@escuelas = $escuelasNuevas
		else
			Establecimiento.where(migrada: 1).each do |es|
				@escuelas << es.codigo_jurisdiccional
			end 
		end 
		client = Mysql2::Client.new(:username => "guest",:host => "172.16.0.19",  :password => "guest", :database => "mec")
	  @escuelas.each do |e|
			if $nueva
			    res=client.query("select secuencia as secMax, p.* from padhc p where escuela = '"+e.to_s+"'  and estado= 'ALT' and secuencia<88 group by  nume_docu, materia, horas_cate, secuencia union
		 			select secuencia as secMax, p.* from padhc p where escuela = '"+e.to_s+"' and secuencia<88 and estado= 'LIC'  group by  nume_docu, materia, horas_cate,secuencia")
			else
			    res= client.query("SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '"+e.to_s+"' and mes ='"+$mes.to_s+"' and anio = '"+$anio.to_s+"'  and secuencia<88 and (estado = 'ALT' or estado='LIC') and fecha_baja='0000-00-00'")
			end
		    esc_id= Establecimiento.where(:codigo_jurisdiccional => e).first.id
		    for r in res
					if Materium.where(codigo: r['materia']).first != nil then
							materia_id = Materium.where(codigo: r['materia']).first.id
					else 
							materia_id= 0
					end
					if Persona.where(:nro_documento => r['nume_docu']).first == nil then
							res2= client.query("select apeynom, fech_nac, tipo_docu,nume_docu from agentes a where nume_docu= "+ r['nume_docu'].to_s ).first
			    		res3= client.query("SELECT * FROM agentes_dni_cuit a where nume_docu= "+ r['nume_docu'].to_s ).first
							if res3 == nil then
							next if res2 == nil 
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
							    	if @cuil != nil then
									    @personac.cuil = @cuil["cuit"]
											@personac.save
										end
							end
					end

			  	if r['ciclo'] < 1  then
			  			plan_id = nil
			  	elsif r['ciclo'] >= 1 then 
				  		if Plan.where(:codigo => r['ciclo']).first == nil then
					  			if Materium.where(codigo: r['ciclo']).first == nil
					  				materia_id = 0
					  			else
					  				materia_id=Materium.where(codigo: r['ciclo']).first.id
					  			end
					  			plan_id= Plan.where(codigo: 122).first.id
					  			ciclo = 122
				  		else 
					  			plan_id =  Plan.where(:codigo => r['ciclo']).first.id
					  			ciclo = r['ciclo']
				  		end
			   	end
		      situacion_revista=  r['planta_pre'].to_s+ "-"+ r['tipo_emp'].to_s
	      	hora = AltasBajasHora.where(:establecimiento_id => esc_id, :persona_id => persona_id, secuencia: r['secMax']).first	
	      	if hora == nil then
		      		if Establecimiento.where(id: esc_id).first.sede != 1 
			             if AltasBajasHora.where(:establecimiento_id => esc_id, :persona_id => persona_id, horas: r['horas_cate'], fecha_alta: r['fecha_alta'] , anio: r['curso'], division: r['division'], secuencia: nil ).first != nil
													horaSinSec = AltasBajasHora.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , horas: r['horas_cate'], anio: r['curso'], division: r['division'], secuencia: nil ).first
							      			@listaAux << horaSinSec
							      			horaSinSec.assign_attributes(secuencia: r['secMax'])
							      			if horaSinSec.save!
							      				AltasBajasHoraEstado.create(estado_id: 10, alta_baja_hora_id: horaSinSec.id)
							      			end
				      			elsif AltasBajasHora.where(:establecimiento_id => esc_id, :persona_id => persona_id, horas: r['horas_cate'], fecha_alta: r['fecha_alta'] , secuencia: r['secMax']).first == nil
				    	      		  	AltasBajasHora.create!(establecimiento_id: esc_id, persona_id: persona_id, empresa_id: 6, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista, horas: r['horas_cate'], ciclo_carrera: ciclo, anio:r['curso'], division: r['division'], turno:r['turno'], codificacion: r['materia'], oblig: r['categ'], estado:r['estado'] , materium_id: materia_id, plan_id: plan_id )
					       						#RegistrosParaSolucionar.create!(mes_liq: 12, anio_liq: 2018, horas_registro: 1, establecimiento_id: esc_id, persona_id: persona_id, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista, horas: r['horas_cate'], ciclo_carrera: ciclo, anio:r['curso'], division: r['division'], turno:r['turno'], codificacion: r['materia'], estado:r['estado'] , materium_id: materia_id, plan_id: plan_id )
				      			end
		      		else
		      				AltasBajasHora.create!(establecimiento_id: esc_id, persona_id: persona_id, empresa_id: 6,secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista, horas: r['horas_cate'], ciclo_carrera: ciclo, anio:r['curso'], division: r['division'], turno:r['turno'], codificacion: r['materia'], oblig: r['categ'], estado:r['estado'] , materium_id: materia_id, plan_id: plan_id )
		      		end
			  end	
			end
		end
	end


	def migrar_cargos
		@listaAux = []
		@escuelas = []
		if $nueva
			@escuelas = $escuelasNuevas
		else
			Establecimiento.where(migrada: 1).each do |es|
				@escuelas << es.codigo_jurisdiccional
			end 
		end 
		client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")
	  @escuelas.each do |e|
	    	if $nueva
	    		res= client.query("select secuencia as secMax, p.* from paddoc p where escuela = '"+e.to_s+"'  and estado= 'ALT' and  secuencia<88 group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r union
				 	select secuencia as secMax, p.* from paddoc p where escuela = '"+e.to_s+"' and secuencia<88  and estado= 'LIC' group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r")
	    	else
		    	res= client.query("SELECT secuencia as secMax, p.* FROM his_paddoc p where secuencia<88 and p.escuela= '"+e.to_s+"' and mes ='"+$mes.to_s+"' and anio = '"+$anio.to_s+"' and (estado = 'ALT' or estado='LIC') and fecha_baja='0000-00-00' ")
		    end
				esc_id= Establecimiento.where(:codigo_jurisdiccional => e).first.id

				for r in res
					materia_id = nil
					if Persona.where(:nro_documento => r['nume_docu']).first == nil then
							res2= client.query("select apeynom, fech_nac, tipo_docu,nume_docu from agentes a where nume_docu= "+ r['nume_docu'].to_s ).first
		      		res3= client.query("SELECT * FROM agentes_dni_cuit a where nume_docu= "+ r['nume_docu'].to_s ).first
		  				if res3 == nil then
		  				next if res2 == nil 
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
	       		empresa_id = Empresa.where(nombre: r['empresa']).first.id
	   				if Cargo.where(:establecimiento_id => esc_id, :persona_id => persona_id, cargo: categoria, secuencia: nil, fecha_alta: r['fecha_alta'] ).first != nil
								cargoSinSec = Cargo.where(:establecimiento_id => esc_id, :persona_id => persona_id, cargo: categoria, secuencia: nil, fecha_alta: r['fecha_alta']).first
		       			@listaAux << cargoSinSec
		      			cargoSinSec.assign_attributes(secuencia: r['secMax'])
		      			if cargoSinSec.save!
		      				CargoEstado.create(estado_id: 10, cargo_id: cargoSinSec.id)
		      			end
	       		elsif Cargo.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: r['secMax'], cargo: categoria ).first == nil
		       			Cargo.create!(establecimiento_id: esc_id, persona_id: persona_id, cargo: categoria, empresa_id: empresa_id, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista,  anio:r['curso'], division: r['division'], turno:r['turno'],   estado:r['estado'] , materium_id: materia_id)
		       			#RegistrosParaSolucionar.create!(mes_liq: 12, anio_liq: 2018, cargos_registro: 1,establecimiento_id: esc_id, persona_id: persona_id, cargo: categoria, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista,  anio:r['curso'], division: r['division'], turno:r['turno'],   estado:r['estado'] , materium_id: materia_id)
	       		end
	       		# if Cargo.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: r['secMax'], cargo: categoria ).first != nil
		       	# 		if Cargo.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: r['secMax'], cargo: categoria, empresa_id: empresa_id ).first == nil
		       	# 				c = Cargo.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: r['secMax'], cargo: categoria ).first
		       	# 				c.update!(empresa_id: empresa_id)
			       # 		end
		       	# end
				end
		end
	end


	def migrar_auxiliares
		@listaAux = []
		@escuelas = []
		if $nueva
				@escuelas = $escuelasNuevas
		else
				Establecimiento.where(migrada: 1).each do |es|
					@escuelas << es.codigo_jurisdiccional
				end 
		end 
		client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")
		@escuelas.each do |e|
					if $nueva
			 	  		res = client.query("select secuencia as secMax, p.* from padaux p where escuela = '"+e.to_s+"'  and estado= 'ALT' and secuencia=0 group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r union
			 		select secuencia as secMax, p.* from padaux p where escuela = '"+e.to_s+"' and secuencia<88 and estado= 'LIC'  group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r")
					else
							res= client.query("SELECT secuencia as secMax, p.* FROM his_padaux p where p.secuencia < 88 and p.escuela= '"+e.to_s+"' and mes ='"+$mes.to_s+"' and anio = '"+$anio.to_s+"' and (estado = 'ALT' or estado='LIC') and fecha_baja='0000-00-00'")
			 	  end

				esc_id= Establecimiento.where(:codigo_jurisdiccional => e).first.id
				for r in res
							materia_id = nil
							if Persona.where(:nro_documento => r['nume_docu']).first == nil then
											res2= client.query("select apeynom, fech_nac, tipo_docu,nume_docu from agentes a where nume_docu= "+ r['nume_docu'].to_s ).first
									    res3= client.query("SELECT * FROM agentes_dni_cuit a where nume_docu= "+ r['nume_docu'].to_s ).first
								  		if res3 == nil then
								  			next if res2 == nil 
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
				  empresa_id = Empresa.where(nombre: r['empresa']).first.id
		      cargond = CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, secuencia: 0, empresa_id: empresa_id, cargo: cargo_id).first
	       	if ['turno'] == nil
	       		turno = 'M'
	       	else
	       		turno = r['turno']
	       	end
	       	if CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, cargo: cargo_id, secuencia: nil, fecha_alta: r['fecha_alta']).first != nil
											cargoNSinSec = CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, cargo: cargo_id, secuencia: nil, fecha_alta: r['fecha_alta']).first
						     			@listaAux << cargoNSinSec
					      			cargoNSinSec.assign_attributes(secuencia: 0)
					      			if cargoNSinSec.save!
					      					CargoNoDocenteEstado.create(estado_id: 10, cargo_no_docente_id: cargoNSinSec.id)
					      			end
				  elsif  CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: 0, cargo: cargo_id ).first == nil
				       		if CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: 0).first != nil
				       				carg = CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: 0).first
				       				carg.update(cargo: cargo_id)
									else			
											if CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id).first != nil
					       				carg = CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id).first 
					       				carg.update(:estado => 'BAJ')
		       						end
											CargoNoDocente.create!(establecimiento_id: esc_id, empresa_id: empresa_id, persona_id: persona_id, cargo: cargo_id, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista,  turno: turno, estado:r['estado'])	
											#RegistrosParaSolucionar.create!(mes_liq: 12, anio_liq: 2018, auxiliar_registro: 1, establecimiento_id: esc_id, persona_id: persona_id, cargo: cargo_id, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista,  turno:r['turno'], estado:r['estado'])
									end
					end
					# if CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: 0, cargo: cargo_id ).first != nil		       		
				 #       			if CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: 0, empresa_id: empresa_id ).first == nil
				 #       					car = CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: 0 ).first
				 #       					car.update!(empresa_id: empresa_id)
					#        		end
			  #   end
		      end	
		 end
	end

end
