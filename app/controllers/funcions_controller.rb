class FuncionsController < InheritedResources::Base

  private

    def funcion_params
      params.require(:funcion).permit(:categoria, :tipo_cargo, :descripcion, :grupo)
    end
end

