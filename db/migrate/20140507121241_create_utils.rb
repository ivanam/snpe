class CreateUtils < ActiveRecord::Migration
  def change
    create_table :utils do |t|

      t.timestamps
    end
  end
end
