class ChangeScoresOnGames < ActiveRecord::Migration[7.2]
  def change
    change_column_default :games, :dealer_score, from: nil, to: 0
    change_column_default :games, :player_score, from: nil, to: 0
    change_column_null :games, :dealer_score, false, 0
    change_column_null :games, :player_score, false, 0
  end
end
