class AddPlayerScoreToGames < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :player_score, :integer
  end
end
