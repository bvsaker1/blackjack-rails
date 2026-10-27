# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
rank_list = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

["Hearts", "Diamonds", "Spades", "Clubs"].each do |suit|
  rank_list.each do |rank|
    # card = Card.new
    # card.suit = suit
    # card.rank = rank
    # card.save!
    Card.find_or_create_by!(suit: suit, rank: rank)
  end
end
    

