class ChangeCodigoJurisdiccionalToInteger < ActiveRecord::Migration
  def change
    change_column :establecimientos, :codigo_jurisdiccional, :integer
  end
end
