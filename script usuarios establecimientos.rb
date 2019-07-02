l = []
User.all.each do |us|

  if UserRole.where(:role_id => 5, :user_id => us.id ).first != nil
    l << [us.id, us.email, us.nombres, us.apellidos]
  end

end

USUARIOS PERSONAL
["user@user.com", "personal@personal.com", "olguinv@sueldos.com", "ramirezm@sueldos.com", 
  "mazzinic@sueldos.com", "montecinosr@personal.com", "olsinad@personal.com", "quintanam@personal.com", 
  "cayumanf@personal.com", "camposp@personal.com", "nunezr@personal.com", "iribarrenj@personal.com", 
  "rojasml@personal.com", "maliqueoe@personal.com", "ayalah@personal.com", "alitokohler@personal.com", 
  "njones@personal.com", "mcasin@personal.com", "cgomez@personal.com", "mtriolo@personal.com", 
  "mbarrera@personal.com", "obarrios@personal.com", "mkrieger@personal.com", "betancur@personal.com", 
  "delegacion-1@personal.com", "delegacion-3@personal.com", "delegacion-4@personal.com", 
  "darigolondrina@gmail.com", "areapersonal17@gmail.com", "delreg4sueldos@gmail.com", "gasbrina@hotmail.com", 
  "munozdario81@gmail.com", "jonatanm@hotmail.com", "gabifru14@hotmail.com", "euadianairisanifuente@yahoo.com.ar", 
  "delreg2@gmail.com", "apaz@personal.com", "vanesarawson@hotmail.com", "alitokohler@hotmail.com", 
  "roxanaandreaotero@gmail.com", "emorales@personal.com", "sleon@personal.com", "gvazquez@personal.com", 
  "moragaa@personal.com", "vidalv@personal.com", "mmorales@personal.com", "jcatalan@personal.com", "conejeron@personal.com"] 


[["user@user.com", "", ""], ["personal@personal.com", "", ""], 
["olguinv@sueldos.com", "Viviana", "Olguín"],  
["ramirezm@sueldos.com", "Marcelo", "Ramirez"],
["mazzinic@sueldos.com", "Cristina", "Mazzini"], ****************
["montecinosr@personal.com", "Rodrigo", "Montecinos"],
["olsinad@personal.com", "Daniela", "Olsina"], 
["quintanam@personal.com", "Mercedes", "Quintana"], 
["cayumanf@personal.com", "Francisca", "Cayuman"], 
["camposp@personal.com", "Pablo", "Campos"], 
["nunezr@personal.com", "Rosana", "Nuñez"], *************
["iribarrenj@personal.com", "Jorgelina", "Iribarren"], 
["rojasml@personal.com", "María Laura", "Rojas"],
["maliqueoe@personal.com", "Elba", "Maliqueo"], **************
["ayalah@personal.com", "Hugo", "Ayala"],
["alitokohler@personal.com", "Alejandra", "Kohler"], 
["njones@personal.com", "Norma", "Jones"],
["mcasin@personal.com", "Marta", "Casin"], 
["cgomez@personal.com", "Cesar", "Gomez"], 
["mtriolo@personal.com", "Maria del Carmen", "Triolo"], ******************
["mbarrera@personal.com", "Miguela", "Barrera"], ******************
["obarrios@personal.com", "Olga ", "Barrios"], 
["mkrieger@personal.com", "Marcela", "Krieger"], 
["betancur@personal.com", "Jessica", "Betancur"], 
["delegacion-1@personal.com", "", "Region I"], 
["delegacion-3@personal.com", "Delegaciòn", "Region III"],
["delegacion-4@personal.com", "", "Region IV"], 
["darigolondrina@gmail.com", "Karina Andrea,  Jonatan", "Villaroel, Christ"],**************
["areapersonal17@gmail.com", "Irma Hayde", "Pinchulef"], *************
["delreg4sueldos@gmail.com", "Hector", "Schechinger"],***********siiiii
["gasbrina@hotmail.com", "Gaston", "Brima"], ***********siiii
["munozdario81@gmail.com", "Dario", "Muñoz"], *********
["jonatanm@hotmail.com", "Jonatan", "Muñoz"], **************
["gabifru14@hotmail.com", "Gabriela", ""], *****************
["euadianairisanifuente@yahoo.com.ar", "Diana", "Fuente"], ***************
["delreg2@gmail.com", "Mauricio, Fernanda, Pablo", "Andrada, Rodas, Firmenich"], [*********************siii
"apaz@personal.com", "Ana", "Paz"], ********************
["vanesarawson@hotmail.com", "Vanesa", "Rawson"], *********************
["alitokohler@hotmail.com", "Alejandra", "Kohler"], **********************
["roxanaandreaotero@gmail.com", "Roxana Andrea", "Otero"], 
["emorales@personal.com", "Eliana", "Morales"], 
["sleon@personal.com", "Sonia", "leon"],
["gvazquez@personal.com", "Gabriela ", "Vazquez"],
 ["moragaa@personal.com", "Antonio", "Moraga"],
["vidalv@personal.com", "Vanesa", "Vidal"], 
["mmorales@personal.com", "mariela", "morales"], 
["jcatalan@personal.com", "Juliana", "Catalan"], 
["conejeron@personal.com", "Norma", "Conejero"]]




NO PERTENECES A PERSONAL
["mazzinic@sueldos.com", "Cristina", "Mazzini"], ****************
["nunezr@personal.com", "Rosana", "Nuñez"], *************
["maliqueoe@personal.com", "Elba", "Maliqueo"], **************
["cgomez@personal.com", "Cesar", "Gomez"], *************************
["mtriolo@personal.com", "Maria del Carmen", "Triolo"], ******************
["mbarrera@personal.com", "Miguela", "Barrera"], ******************
["darigolondrina@gmail.com", "Karina Andrea,  Jonatan", "Villaroel, Christ"],**************
["areapersonal17@gmail.com", "Irma Hayde", "Pinchulef"], *************
["munozdario81@gmail.com", "Dario", "Muñoz"], *********
["jonatanm@hotmail.com", "Jonatan", "Muñoz"], **************
["gabifru14@hotmail.com", "Gabriela", ""], *****************
["euadianairisanifuente@yahoo.com.ar", "Diana", "Fuente"], ***************
"apaz@personal.com", "Ana", "Paz"], ********************
["vanesarawson@hotmail.com", "Vanesa", "Rawson"], *********************
["alitokohler@hotmail.com", "Alejandra", "Kohler"], **********************





[17, "montecinosr@personal.com", "Rodrigo", "Montecinos"], 
[19, "olsinad@personal.com", "Daniela", "Olsina"], 
[20, "quintanam@personal.com", "Mercedes", "Quintana"], 
[22, "cayumanf@personal.com", "Francisca", "Cayuman"],
[23, "camposp@personal.com", "Pablo", "Campos"], 
[26, "iribarrenj@personal.com", "Jorgelina", "Iribarren"],
[27, "rojasml@personal.com", "María Laura", "Rojas"], 
[29, "ayalah@personal.com", "Hugo", "Ayala"], 
[62, "njones@personal.com", "Norma", "Jones"], 
[63, "mcasin@personal.com", "Marta", "Casin"],  
[68, "obarrios@personal.com", "Olga ", "Barrios"], 
[69, "mkrieger@personal.com", "Marcela", "Krieger"],
[72, "betancur@personal.com", "Jessica", "Betancur"], 
6942

l = [6942]
l.each do |us|
  es = Establecimiento.where(migrada:1, sede: nil)
  es.each do |e|
    EstablecimientosUsers.create(:user_id => us, :establecimiento_id => e.id)
  end
end



es = [9,22,38,41,58,59,60,67,69,75,80,81,89,90,93,103,108,109,121,132,186,194,223,604]
es.each do |ee|
  est = Establecimiento.where(codigo_jurisdiccional: ee).first
  est.update(nivel_id:2)
end

ini =[420,445,446,453,476,484,1470,2416,2417]
ini.each do |ee|
  est = Establecimiento.where(codigo_jurisdiccional: ee).first
  est.update(nivel_id:1)
end



inc = [522,530,562,563,564]
inc.each do |ee|
  est = Establecimiento.where(codigo_jurisdiccional: ee).first
  est.update(nivel_id:7)
end



est = Establecimiento.where(codigo_jurisdiccional: 308).first
est.update(nivel_id:8)


inc = [656,657]
inc.each do |ee|
  est = Establecimiento.where(codigo_jurisdiccional: ee).first
  est.update(nivel_id:2)
end


inc = [717,726,727,734,765,774,788,7709,7719,7727]
inc.each do |ee|
  est = Establecimiento.where(codigo_jurisdiccional: ee).first
  est.update(nivel_id:3)
end




est = [9,22,38,41,58,59,60,67,69,75,80,81,89,90,93,103,108,109,121,132,186,194,223,604,420,445,446,453,476,484,1470,2416,2417,522,530,562,563,564,308,656,657,717,726,727,734,765,774,788,7709,7719,7727]

est.each do |ee|
  esta = Establecimiento.where(codigo_jurisdiccional: ee).first
  esta.update(migrada:1)
end

est = [9,22,38,41,58,59,60,67,69,75,80,81,89,90,93,103,108,109,121,132,186,194,223,604,420,445,446,453,476,484,1470,2416,2417,522,530,562,563,564,308,656,657,717,726,727,734,765,774,788,7709,7719,7727]

est.each do |ee|
  esta = Establecimiento.where(codigo_jurisdiccional: ee).first
  AltasBajasHora.where(:establecimiento => esta.id)
end

