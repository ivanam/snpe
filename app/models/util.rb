class Util < ActiveRecord::Base
  # attr_accessible :title, :body

  def self.fecha_a_cadena(fecha)
  	if fecha then
  		return I18n.l fecha, :format => fecha.day.to_s + " de %B de " + fecha.year.to_s 
  	else
  		return "" 
  	end
  end

  def self.fecha_a_es(fecha)
  	if fecha then
  		return I18n.l fecha
  	else
  		return ""
  	end  	
  end

end
