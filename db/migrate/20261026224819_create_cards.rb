class CreateCards < ActiveRecord::Migration[7.2]
  def change
    create_table :cards do |t|
      t.string :suit
      t.string :rank

      t.timestamps
    end
    add_index :cards, [:suit, :rank], unique: true
  end
end
