class EmpresasController < InheritedResources::Base

  private

    def empresa_params
      params.require(:empresa).permit(:nombre, :descripcion)
    end
end

