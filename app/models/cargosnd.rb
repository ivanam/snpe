class Cargosnd < ActiveRecord::Base

	def to_s_codigo
		"#{ self.cargo_agrup }#{ self.cargo_cod }#{ self.cargo_categ }"
	end

	def to_s
		"#{ self.cargo_agrup }#{ self.cargo_cod }#{ self.cargo_categ } - #{ self.cargo_desc }"
	end
end
