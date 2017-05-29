module FuncionsHelper

  def funciones_permitidas
    if Establecimiento.find(session[:establecimiento].to_i).nivel_id.to_i == 2 
      return Funcion.where(categoria: [305, 306 , 307, 310, 206, 207, 703, 210 ,321 ,322 ,315 ,313 ,113 ,311 ,115 ,111 ,511 ,809 ,611 ,711 ,709 ,811 ,320 ,112 ,117 ,312 ,212 ,617 ,619 ,217 ,219 ,317 ,318 ,319 ,118 ,119 ,817 ,116 ,965 ,108 ,208 ,104 ,808 ,308 ,708] )
    elsif Establecimiento.find(session[:establecimiento].to_i).nivel_id.to_i == 3 || Establecimiento.find(session[:establecimiento].to_i).nivel_id.to_i == 1
 
    	return Funcion.all
    else
      return []
    end
  end
end
