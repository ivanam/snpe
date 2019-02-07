class Rubro < ActiveRecord::Base
	belongs_to :funcion
	belongs_to :juntafuncion 
	belongs_to :persona
	belongs_to :region
	  
	validates :juntafuncion, :presence => true
	validates :persona, :presence => true
	validates :region, :presence => true

	validates_uniqueness_of :juntafuncion, :scope => [:persona, :region], message: "Cargo repetido para persona en region."

	#validate :unico_lugar
	
	# otro_lugar y establecimientos_id excluyetes
	def unico_lugar
		if self.establecimiento.present? && self.otro_lugar.present?
			errors.add(:base, "Seleccione unico lugar.")
		elsif !self.establecimiento.present? && !self.otro_lugar.present?
			errors.add(:base, "Seleccione un lugar.")
		end
	end

end
