class CreateDeckCards < ActiveRecord::Migration[7.2]
  def change
    create_table :deck_cards do |t|
      t.references :deck, null: false, foreign_key: true, index: false
      t.references :card, null: false, foreign_key: true
      t.references :hand, null: true, foreign_key: true
      t.integer :position

      t.timestamps
    end
    add_index :deck_cards, [:deck_id, :card_id], unique: true
  end
end
