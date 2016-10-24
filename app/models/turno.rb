class Turno < ActiveRecord::Base

	validates :descripcion, :presence => true

	def to_s
		self.descripcion
	end 
end
