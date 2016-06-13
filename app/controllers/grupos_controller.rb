class GruposController < InheritedResources::Base

  private

    def grupo_params
      params.require(:grupo).permit(:nombre, :descripcion)
    end
end

