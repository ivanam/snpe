class TipoArticulo < ActiveRecord::Base

	def to_s
		self.descripcion
	end
end
