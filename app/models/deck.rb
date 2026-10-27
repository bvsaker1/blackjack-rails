class Deck < ApplicationRecord
  belongs_to :game
  has_many :deck_cards, dependent: :destroy
  has_many :cards, through: :deck_cards
end
