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
      
  		return fecha.strftime("%d-%m-%Y")
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

  def self.anio_mes_periodo(anio, mes)
    # Recibe el año y el mes en formato String, y retorna el mismo año y mes en caso que vengan con algun valor, y sino retorna el año y mes actual
    if anio == nil || mes == nil
      return Date.today.year, Date.today.month
    else
      return anio, mes
    end
  end

end
