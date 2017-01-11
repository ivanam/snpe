class FuncionsController < InheritedResources::Base
  before_action :set_grupo, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  

  private

    def funcion_params
      params.require(:funcion).permit(:categoria, :tipo_cargo, :descripcion, :grupo)
    end
end

