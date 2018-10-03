class RegistrationsController < Devise::RegistrationsController
  def create
    if verify_recaptcha
      super
    else
      build_resource(sign_up_params)
      clean_up_passwords(resource)
      flash.now[:alert] = "Hubo un error al ingresar el código de la imagen, por favor reingrese el código."
      flash.delete :recaptcha_error
      render :new
    end
  end
end