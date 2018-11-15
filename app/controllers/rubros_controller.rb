class RubrosController < InheritedResources::Base
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
  	respond_to do |format|
      format.html
      format.json { render json: RubroDatatable.new(view_context, { query: Rubro.all }) }
    end
  end

  def destroy
    redirect_to rubros_path, :alert => "Operacion no permitida."
  end


  private

    def rubro_params
      params.require(:rubro).permit()
    end
end

