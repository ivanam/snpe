class PlansController < InheritedResources::Base

  private

    def plan_params
      params.require(:plan).permit(:codigo, :descripcion)
    end
end

