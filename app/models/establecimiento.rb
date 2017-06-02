class Establecimiento < ActiveRecord::Base
	has_many :cursos
	belongs_to :rol
	belongs_to :nivel
	belongs_to :localidad
	belongs_to :persona
	
	has_many :plan_estudio_establecimiento

	has_many :establecimientos_users, :foreign_key => 'establecimiento_id', :class_name => 'EstablecimientosUsers'
	has_many :users, :through => :establecimientos_users

	has_many :plan_estudio_establecimientos
	has_many :plan_estudios, :through => :plan_estudio_establecimientos

	has_many :suborganizaciones, :class_name => 'Establecimiento', :foreign_key => 'organizacion_id'
	belongs_to :organizacion_superior, :class_name => 'Establecimiento', :foreign_key => 'organizacion_id'

	def to_s
	  	"#{self.codigo_jurisdiccional} - #{ self.nombre } - #{ self.nivel }"
	end

	def requiere_movilidad
		(self.codigo_jurisdiccional >= "300" && self.codigo_jurisdiccional <= "399") || (self.codigo_jurisdiccional >= "500" && self.codigo_jurisdiccional <= "599")
	end

	def peso
		@suborganizaciones = self.suborganizaciones
		if @suborganizaciones == [] then
			return 0
		else
			peso_mayor = 0
			@suborganizaciones.each do |s|
				if s.peso > peso_mayor then
					peso_mayor = s.peso
				end
		end
		return peso_mayor + 1
		end
	end

	def suborganizaciones_peso_cero
		@suborganizaciones = self.suborganizaciones
		@establecimiento_ids = []
		if @suborganizaciones == [] then
			return []
		else
  		@suborganizaciones.each do |sub|
				if sub.peso == 0
					@establecimiento_ids << sub.id
				else
					sub.suborganizaciones_peso_cero.each do |sub0|
						@establecimiento_ids << sub0.id
					end
				end
		 end
		 return Establecimiento.where(id: @establecimiento_ids)
	  end
	end

  def cargos_director
    return Cargo.where(establecimiento_id: self.id, cargo: Funcion::DIRECTOR_CATEGORIAS, estado: ['ALT', 'LIC', 'ART'] )
  end

  def cargos_vicedirector
    return Cargo.where(establecimiento_id: self.id, cargo: Funcion::VICEDIRECTOR_CATEGORIAS, estado: ['ALT', 'LIC', 'ART'] )
  end

  def cargos_auxiliares
    return CargoNoDocente.where(establecimiento_id: self.id, estado: ['ALT', 'LIC', 'ART'] )
  end
end
