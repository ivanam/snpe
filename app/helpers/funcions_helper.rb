module FuncionsHelper

  def funciones_permitidas
    if Establecimiento.find(session[:establecimiento].to_i).nivel_id.to_i == 1 #inicial
      return Funcion.where(categoria: [802, 803, 111, 511, 809, 811, 112, 117, 312, 212, 812, 319, 817, 818, 819, 808] )
    elsif Establecimiento.find(session[:establecimiento].to_i).nivel_id.to_i == 2 # Primaria
      return Funcion.where(categoria: [305, 306 , 307, 310, 206, 207, 703, 210 ,321 ,322 ,315 ,313 ,113 ,311 ,115 ,111 ,511 ,809 ,611 ,711 ,709 ,811 ,320 ,112 ,117 ,312 ,212 ,617 ,619 ,217 ,219 ,317 ,318 ,319 ,118 ,119 ,817 ,116 ,965 ,108 ,208 ,104 ,808 ,308 ,708] )
    elsif Establecimiento.find(session[:establecimiento].to_i).nivel_id.to_i == 3 # Secundaria
      return Funcion.where(categoria: [943, 913, 914, 915, 315, 313, 311, 115, 111, 935, 312, 963, 964, 965, 944, 960, 961, 962, 928, 929, 930, 916, 917, 918, 306, 925, 926, 927, 919, 920, 928, 929, 930] )
    elsif Establecimiento.find(session[:establecimiento].to_i).nivel_id.to_i == 7 # Especial
    	return Funcion.where(categoria: [503, 702, 703, 111, 511, 711, 709, 811, 112, 117, 312, 717, 718, 719, 517, 119, 712, 819, 515, 116, 108, 708] )
    elsif Establecimiento.find(session[:establecimiento].to_i).nivel_id.to_i == 8 # Hospitalaria
      return Funcion.where(categoria: [502, 306, 503, 111, 511, 711, 811, 117, 212, 517, 518, 519, 317, 512, 515, 508, 108] )
    else
      return Funcion.all
    end
  end
end
