class AmbitosController < InheritedResources::Base

  private

    def ambito_params
      params.require(:ambito).permit(:nombre, :inscripcion_id)
    end
end

