class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
  before_filter :configure_permitted_parameters, only: [:create]
  
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    @user = User.new(sign_up_params)

    if @user.documento.nil? || @user.documento.to_s.empty?
      @user.errors.add(:base, "Ingrese DNI.")
    else
      @persona = Persona.where(:nro_documento => @user.documento).first
      if @persona.nil?
        @user.errors.add(:base, "DNI incorrecto.")
      else
        @rubro = Rubro.where(persona_id: @persona.id).first
        if @rubro.nil?
          @user.errors.add(:base, "DNI no registrado en el padron.")
        end
      end
    end  
   
    if !@user.errors.messages.empty?
      respond_with @user
    else
      super do |resource|
        @defaultRole = Role.where(:description => 'UserJunta').first
        UserRole.create(:user_id => resource.id, :role_id => @defaultRole.id)        
      end
    end      
  end

    
  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

   def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:nombres, :apellidos, :documento,
        :email, :password, :password_confirmation)
    end    
  end

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
