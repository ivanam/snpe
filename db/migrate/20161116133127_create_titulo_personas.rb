class CreateTituloPersonas < ActiveRecord::Migration
  def change
    create_table :titulo_personas do |t|
      t.integer :titulo_id
      t.integer :persona_id
      t.references :persona, index: true
      t.references :titulo, index: true

      t.timestamps
    end
  end
end
