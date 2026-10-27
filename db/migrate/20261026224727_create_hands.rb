class CreateHands < ActiveRecord::Migration[7.2]
  def change
    create_table :hands do |t|
      t.references :game, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
