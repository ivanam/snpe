class MigracionController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :class => false


	def migrar_hs
		@listaAux = []
		@escuelas = [1,4,8,20,41,47,84,167,185,190,202,401,404,414,441,504,506,508,509,512,523,525,552,603,702,712,725,728,729,732,752,767,774,776,795,7705,7727,3000,3031,4002,4006,28,78,178,403,410,412,453,459,556,2404,2412,4001,4007,5009,567,4000,4004,4009,4012,4014,4015,4016,4017,4018]

	    client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")

	    @escuelas.each do |e|

		    #res=client.query("select secuencia as secMax, p.* from padhc p where escuela = '"+e+"'  and estado= 'ALT' and secuencia<88 group by  nume_docu, materia, horas_cate, secuencia union
	 		#select secuencia as secMax, p.* from padhc p where escuela = '"+e+"' and secuencia<88 and estado= 'LIC'  group by  nume_docu, materia, horas_cate,secuencia")


	 	    #res= client.query("select secuencia as secMax, p.* from padhc p where escuela = '"+params[:esc]+"'  and estado= 'ALT' and secuencia<88 group by  nume_docu, materia, horas_cate, secuencia union
	 		#select MAX(secuencia) as secMax, p.* from padhc p where escuela = '"+params[:esc]+"' and secuencia<88 and estado= 'LIC'  group by  nume_docu, materia, horas_cate")

		    #res= client.query("SELECT secuencia as secMax, p.* FROM padhc p where (p.fecha_alta > '2017-03-01' or p.fecha_baja> '2017-03-01' ) and p.escuela= '"+params[:esc]+"' ")
		    res= client.query("SELECT secuencia as secMax, p.* FROM his_padhc p where  p.escuela= '"+e.to_s+"' and mes = 9 and anio = 2017  and secuencia<88 and (estado = 'ALT' or estado='LIC') and fecha_baja='0000-00-00'")

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
		      			horaSinSec.save!
		    			elsif AltasBajasHora.where(:establecimiento_id => esc_id, :persona_id => persona_id, horas: r['horas_cate'], fecha_alta: r['fecha_alta'] , secuencia: nil).first != nil
		      			horaSinSec = AltasBajasHora.where(:establecimiento_id => esc_id, :persona_id => persona_id, horas: r['horas_cate'] ,  fecha_alta: r['fecha_alta'], secuencia: nil).first
		      			@listaAux << horaSinSec
		       			horaSinSec.assign_attributes(secuencia: r['secMax'])
		       			horaSinSec.save!


		      		elsif AltasBajasHora.where(:establecimiento_id => esc_id, :persona_id => persona_id, horas: r['horas_cate'], fecha_alta: r['fecha_alta'] , secuencia: r['secMax']).first == nil
		      			AltasBajasHora.create!(establecimiento_id: esc_id, persona_id: persona_id, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista, horas: r['horas_cate'], ciclo_carrera: ciclo, anio:r['curso'], division: r['division'], turno:r['turno'], codificacion: r['materia'], oblig: r['categ'], estado:r['estado'] , materium_id: materia_id, plan_id: plan_id )
		      		end

		      		##################COMENTAR PARA MIGRAR TODOOOOOO
		     #   	else

		     #    	if hora.estado != 'ART'

				   #     	if hora.estado == 'LIC' && (( r['estado'] == 'ALT')  ||  ( r['estado'] == 'BAJ') ) 
				   #    		hora.estado =  r['estado']
				   #    	elsif hora.estado == 'ALT' && ( (r['estado'] == 'LIC') || ( r['estado'] == 'BAJ') ) 
				   #    		hora.estado =  r['estado']
				   #     	elsif hora.fecha_baja != r['fecha_baja']
				   #     		hora.fecha_baja = r['fecha_baja']
				   #    		hora.estado = 'BAJ'
				   #     	elsif hora.fecha_baja != nil
				   #     		hora.estado = 'BAJ'
				   #     	end
				   #    end
				
				
					  # hora.assign_attributes(fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista)
					  # hora.save      	
			      end	
			end
		end

	end





	def migrar_cargos

		@listacargoSinSec = []
	    @escuelas = [1,4,8,20,41,47,84,167,185,190,202,401,404,414,441,504,506,508,509,512,523,525,552,603,702,712,725,728,729,732,752,767,774,776,795,7705,7727,3000,3031,4002,4006,28,78,178,403,410,412,453,459,556,2404,2412,4001,4007,5009,567,4000,4004,4009,4012,4014,4015,4016,4017,4018]

		client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")
	 	#res= client.query("select secuencia as secMax, p.* from paddoc p where escuela = '"+params[:esc]+"'  and estado= 'ALT' and  secuencia<88 group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r union
	 #select secuencia as secMax, p.* from paddoc p where escuela = '"+params[:esc]+"' and secuencia<88  and estado= 'LIC' group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r")
	    @escuelas.each do |e|

		    res= client.query("SELECT secuencia as secMax, p.* FROM his_paddoc p where  p.escuela= '"+e.to_s+"'and secuencia<88 and mes = 9 and anio = 2017 and (estado = 'ALT' or estado='LIC') and fecha_baja='0000-00-00' ")


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
		      			cargoSinSec.save!
		       		elsif 
		       			Cargo.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: r['secMax'], cargo: categoria ).first == nil
		       			Cargo.create!(establecimiento_id: esc_id, persona_id: persona_id, cargo: categoria, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista,  anio:r['curso'], division: r['division'], turno:r['turno'],   estado:r['estado'] , materium_id: materia_id)
		       		end




		    #    		##################COMENTAR PARA MIGRAR TODOOOOOO
	     #    		else
	   	 # 	   		if cargo.estado != 'ART'
				  #     	if cargo.estado == 'LIC' && (( r['estado'] == 'ALT')  ||  ( r['estado'] == 'BAJ') ) 
				  #     		cargo.estado =  r['estado']
				  #     	elsif cargo.estado == 'ALT' && ( (r['estado'] == 'LIC') || ( r['estado'] == 'BAJ') ) 
				  #     		cargo.estado =  r['estado']
				  #     	elsif cargo.fecha_baja != r['fecha_baja']
				  #     		cargo.fecha_baja = r['fecha_baja']
				  #     		cargo.estado = 'BAJ'
				  #     	elsif cargo.fecha_baja != nil
				  #     		cargo.estado = 'BAJ'
				  #     	end
				  # 	end
			
				  # cargo.assign_attributes(fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista)
				  # cargo.save      	
		 	    end	

			end
		end
	end


	def migrar_auxiliares
		@listacargoNSinSec = []
		@escuelas = [1,4,8,20,41,47,84,167,185,190,202,401,404,414,441,504,506,508,509,512,523,525,552,603,702,712,725,728,729,732,752,767,774,776,795,7705,7727,3000,3031,4002,4006,28,78,178,403,410,412,453,459,556,2404,2412,4001,4007,5009,567,4000,4004,4009,4012,4014,4015,4016,4017,4018]

		client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")


		@escuelas.each do |e|

	 	  #res = client.query("select secuencia, p.* from padaux p where escuela = '"+params[:esc]+"'  and estado= 'ALT' and secuencia=0 group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r union 
	 #select secuencia as secMax, p.* from padaux p where escuela = '"+params[:esc]+"'  and estado= 'LIC' and secuencia=0 group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r")
			


			res= client.query("SELECT secuencia as secMax, p.* FROM his_padaux p where  p.escuela= '"+e.to_s+"'and secuencia<88 and mes = 9 and anio = 2017 and (estado = 'ALT' or estado='LIC') and fecha_baja='0000-00-00'")
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
		      			cargoNSinSec.save!
		       		elsif 
		       			CargoNoDocente.where(:establecimiento_id => esc_id, :persona_id => persona_id, fecha_alta: r['fecha_alta'] , secuencia: r['secMax'], cargo: cargo_id ).first == nil
						CargoNoDocente.create!(establecimiento_id: esc_id, persona_id: persona_id, cargo: cargo_id, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista,  turno:r['turno'], estado:r['estado'])
	      	  
					end

					##################COMENTAR PARA MIGRAR todooooo
	    #    	  else
		   #     		if cargond.estado != 'ART'
				 #     	if cargond.estado == 'LIC' && (( r['estado'] == 'ALT')  ||  ( r['estado'] == 'BAJ') ) 
				 #     		cargond.estado =  r['estado']
				 #    	elsif cargond.estado == 'ALT' && ( (r['estado'] == 'LIC') || ( r['estado'] == 'BAJ') ) 
				 #     		cargond.estado =  r['estado']
				 #     	elsif cargond.fecha_baja != r['fecha_baja']
				 #     		cargond.fecha_baja = r['fecha_baja']
				 #     		cargond.estado = 'BAJ'
				 #     	elsif cargond.fecha_baja != nil
				 #     		cargond.estado = 'BAJ'
				 #     	end
			  #    	end
			
			
				 #     cargond.assign_attributes(fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista)
					# cargond.save      	
		       end	

		  	end

		  end
	end

end

