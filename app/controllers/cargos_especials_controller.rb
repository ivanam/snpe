class CargosEspecialsController < InheritedResources::Base

  private

    def cargos_especial_params
      params.require(:cargos_especial).permit(:descripcion)
    end
end

