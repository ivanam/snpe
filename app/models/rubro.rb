class Rubro < ActiveRecord::Base
	belongs_to :funcion
	belongs_to :juntafuncion 
	belongs_to :persona
	belongs_to :region	
end
