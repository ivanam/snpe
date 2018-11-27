class AddDisposicionATraslado < ActiveRecord::Migration
  def change
	add_column :traslados, :disposicion, :string
  end
end
