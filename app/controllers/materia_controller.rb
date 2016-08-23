class MateriaController < InheritedResources::Base

  private

    def materium_params
      params.require(:materium).permit(:codigo, :descripcion)
    end
end

