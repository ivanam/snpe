class JuntafuncionsController < InheritedResources::Base

  private

    def juntafuncion_params
      params.require(:juntafuncion).permit(:descripcion)
    end
end

