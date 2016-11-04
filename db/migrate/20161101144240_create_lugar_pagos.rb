class CreateLugarPagos < ActiveRecord::Migration
  def change
    create_table :lugar_pagos do |t|
      t.integer :codigo
      t.string :descripcion

      t.timestamps
    end
  end
end
