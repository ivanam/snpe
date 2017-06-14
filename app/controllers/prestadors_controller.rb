class PrestadorsController < InheritedResources::Base

  private

    def prestador_params
      params.require(:prestador).permit(:nombre, :matricula, :especialidad_id, :especialidad_id)
    end
end

