class EspecialidadsController < InheritedResources::Base

  private

    def especialidad_params
      params.require(:especialidad).permit(:nombre)
    end
end

