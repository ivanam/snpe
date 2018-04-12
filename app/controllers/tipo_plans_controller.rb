class TipoPlansController < InheritedResources::Base

  private

    def tipo_plan_params
      params.require(:tipo_plan).permit(:nombre)
    end
end

