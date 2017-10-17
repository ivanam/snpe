module EstablecimientosHelper
  def establecimientos_permitidos
    if current_user.role? :sadmin then
      return Establecimiento.all
    elsif (current_user.email == "meneira@personal.com") || (current_user.email == "apaz@personal.com") || (current_user.email == "ayalah@personal.com") || (current_user.email == "mcasin@personal.com") || (current_user.email == "mbarrera@personal.com") || (current_user.email == "iribarrenj@personal.com") || (current_user.email == "moralesm@personal.com") || (current_user.email == "njones@personal.com") 
      return Establecimiento.where(codigo_jurisdiccional: [1,4,8,20,41,47,84,167,185,190,202,401,404,414,441,504,506,508,509,512,523,525,552,603,702,712,725,728,729,732,752,767,774,776,795,7705,7727,3000,3031,4002,4006,28,78,178,403,410,412,453,459,556,2404,2412,4001,4007,5009,567,4000,4004,4009,4012,4014,4015,4016,4017,4018])
    else
      return current_user.establecimientos
    end
  end
end
