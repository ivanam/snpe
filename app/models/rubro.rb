class Rubro < ActiveRecord::Base
	belongs_to :funcion
	belongs_to :juntafuncion 
	belongs_to :persona
	belongs_to :region
	belongs_to :ambito
	belongs_to :establecimiento

	validates :ambito, presence: true, on: :update
	validates :establecimiento, presence: true, on: :update

end
