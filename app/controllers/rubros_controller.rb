class RubrosController < InheritedResources::Base

  private

    def rubro_params
      params.require(:rubro).permit(:pesona_id, :escuela_id, :rubro_titulo, :rubro_concepto, :rubro_asis_perf, :rubro_ser_prest, :rubro_residencia, :rubro_gestion, :rubro_cursos, :ant_doc, :rubro_titulo, :total, :promedio, :persona_id, :establecimiento_id)
    end
end

