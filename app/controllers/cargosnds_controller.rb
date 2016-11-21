class CargosndsController < InheritedResources::Base

  private

    def cargosnd_params
      params.require(:cargosnd).permit(:cargo_agrup, :cargo_cod, :cargo_categ, :nivel, :cargo_desc)
    end
end

