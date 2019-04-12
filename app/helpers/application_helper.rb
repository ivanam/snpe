module ApplicationHelper
  def log_seperator
    return "***************************************************"
  end

  def log_error(message)
    logger.error(log_seperator);
    logger.error(controller_name + '.' + action_name + ":  " + message)
  end

  def establecimiento_actual
    return Establecimiento.find(session[:establecimiento])
  end

   def establecimiento_region
    @establecimiento = Establecimiento.find(session[:establecimiento])
    @localidad = Localidad.find(@establecimiento.localidad_id)
    @region = Region.find(@localidad.region_id)
    return @region
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end