class MigracionController < ApplicationController





	def migrar_hs
	    client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")
	      res= client.query("select secuencia as secMax, p.* from padhc p where escuela = '"+params[:esc]+"'  and estado= 'ALT' group by  nume_docu, materia, horas_cate union
select MAX(secuencia) as secMax, p.* from padhc p where escuela = '"+params[:esc]+"'  and estado= 'LIC'  group by  nume_docu, materia, horas_cate")

	      esc_id= Establecimiento.where(:codigo_jurisdiccional => params[:esc]).first.id

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
	      	AltasBajasHora.create!(establecimiento_id: esc_id, persona_id: persona_id, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista, horas: r['horas_cate'], ciclo_carrera: ciclo, anio:r['curso'], division: r['division'], turno:r['turno'], codificacion: r['materia'], oblig: r['categ'], estado:r['estado'] , materium_id: materia_id, plan_id: plan_id )

	     end

		 respond_to do |format|
    		format.js { render nothing: true }
    	end
	end



def migrar_cargos
	    client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")
	      res= client.query("select secuencia as secMax, p.* from paddoc p where escuela = '"+params[:esc]+"'  and estado= 'ALT' group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r union
select MAX(secuencia) as secMax, p.* from paddoc p where escuela = '"+params[:esc]+"'  and estado= 'LIC' group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r")


	      esc_id= Establecimiento.where(:codigo_jurisdiccional => params[:esc]).first.id

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

	       categoria = Funcion.where(:categoria => cargo_concat).first.categoria

	      	
	      	situacion_revista=  r['planta_pre'].to_s+ "-"+ r['tipo_emp'].to_s
	      	Cargo.create!(establecimiento_id: esc_id, persona_id: persona_id, cargo: categoria, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista,  anio:r['curso'], division: r['division'], turno:r['turno'],   estado:r['estado'] , materium_id: materia_id)

	     end

		respond_to do |format|
    		format.js { render nothing: true }
    	end
	end


def migrar_auxiliares
	    client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")
	      res= client.query("select secuencia as secMax, p.* from padaux p where escuela = '"+params[:esc]+"'  and estado= 'ALT' group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r union
select MAX(secuencia) as secMax, p.* from padaux p where escuela = '"+params[:esc]+"'  and estado= 'LIC' group by  nume_docu, secuencia, planta_pre, tipo_emp, cargo_r")


	      esc_id= Establecimiento.where(:codigo_jurisdiccional => params[:esc]).first.id

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


	       cargo_id = Cargosnd.where(:cargo_agrup => r['agrup_r'], :cargo_cod => r['cargo_r'], :cargo_categ => r['categ_r']).first.id

	      	
	      	situacion_revista=  r['planta_pre'].to_s+ "-"+ r['tipo_emp'].to_s
	      	CargoNoDocente.create!(establecimiento_id: esc_id, persona_id: persona_id, cargo: cargo_id, secuencia: r['secMax'], fecha_alta: r['fecha_alta'], fecha_baja: r['fecha_baja'], situacion_revista: situacion_revista,  turno:r['turno'],   estado:r['estado'])

	     end

		 respond_to do |format|
    		format.js { render nothing: true }
    	end
	end


end
