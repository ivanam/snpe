class AddCamposToLicencia < ActiveRecord::Migration
  def change
    add_reference :licencia, :cargo, index: true
    add_reference :licencia, :cargo_no_docente, index: true
  end
end
