class MotivoBaja < ActiveRecord::Base

	validates :motivo, :presence => true

	def to_s
		self.motivo
	end 
end
