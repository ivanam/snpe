class Util < ActiveRecord::Base
  # #attr_accessible :title, :body

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

  def self.max_min_periodo(periodo)
    # Recibe el periodo en formato String y devuelve fecha minima y fecha maxima en formato Date
    if periodo != nil
      @mindate = periodo[0..9]
      @maxdate = periodo[13..22]
    else
      @mindate_year = Date.today.year
      @mindate = Date.today.year.to_s + '/' + Date.today.month.to_s + '/01'
      @maxdate = Date.today.end_of_month
    end

    return @mindate.to_date, @maxdate.to_date
  end

end
