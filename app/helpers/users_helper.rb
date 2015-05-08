module UsersHelper
  def ver_model(modelo)
  #Esta función recibe un nombre de modelo en forma de cadena y retorna 'True' si el usuario tiene permisos de lectura
    if current_user.role? :sadmin then
      return true
    end
    current_user.roles.each do |ro|
      ro.permissions.each do |pe|
        if pe.subject_class == modelo and (pe.action == "index" || pe.action == "show" )
          return true
        end
      end
    end
    return false
  end
end
