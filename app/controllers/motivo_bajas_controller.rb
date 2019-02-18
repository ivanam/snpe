class MotivoBajasController < InheritedResources::Base

  private

    def motivo_baja_params
      params.require(:motivo_baja).permit(:nro_motivo, :motivo)
    end
end

