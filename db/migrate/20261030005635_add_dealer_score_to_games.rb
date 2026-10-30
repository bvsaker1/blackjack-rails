class AddDealerScoreToGames < ActiveRecord::Migration[7.2]
  def change
    add_column :games, :dealer_score, :integer
  end
end
