class ApplicationController < ActionController::Base
  include ::EstablecimientosHelper
  include ::AltasBajasHorasHelper
  include ::LoteImpresionsHelper
  include ::CargosHelper
  include ::CargoNoDocentesHelper
  include ::AsistenciaHelper
  include ::LicenciaHelper
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
  protect_from_forgery

  def after_sign_in_path_for(resource)
    current_user.establecimientos.each do |e|
      session[:establecimiento] = e.id
    end
    stored_location_for(resource) || root_path
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, session[:establecimiento])
  end


  class SelectClass
    def initialize(id, descripcion)  
      # Instance variables  
      @id = id  
      @descripcion = descripcion  
    end
    def id
      return @id
    end
    def descripcion
      return @descripcion
    end
  end 

  def select_motivo_baja
    return [SelectClass.new(1,"Renuncia"),SelectClass.new(2,"Jubilación"),SelectClass.new(3,"Fallecimiento"),SelectClass.new(4,"Presentación de titular")]
  end  

end
