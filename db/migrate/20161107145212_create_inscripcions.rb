class CreateInscripcions < ActiveRecord::Migration
  def change
    create_table :inscripcions do |t|
      t.integer :pesona_id
      t.integer :establecimiento_id
      t.integer :funcion_id
      t.integer :nivel_id
      t.string :escuela_titular
      t.string :serv_activo
      t.string :lugar_serv_act
      t.string :documentacion
      t.integer :rubro_id
      t.date :fecha_incripcion
      t.references :rubro, index: true
      t.references :persona, index: true
      t.references :establecimiento, index: true
      t.references :funcion, index: true
      t.references :nivel, index: true

      t.timestamps
    end
  end
end
