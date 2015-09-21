class ApplicationController < ActionController::Base
  include ::EstablecimientosHelper
  include ::AltasBajasHorasHelper
  include ::LoteImpresionsHelper
  include ::CargosHelper
  include ::AsistenciaHelper
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
  protect_from_forgery

  def after_sign_in_path_for(resource)
    current_user.establecimientos.each do |e|
      if e.peso == 0
        session[:establecimiento] = e.id
        break
      else
        @suborganizacion_0 = e.suborganizaciones_peso_cero
        if @suborganizacion_0 != []
          session[:establecimiento] = @suborganizacion_0.first.id
          break
        end
      end
    end
    stored_location_for(resource) || root_path
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, session[:establecimiento])
  end

end
