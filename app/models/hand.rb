class Hand < ApplicationRecord
  belongs_to :game
  has_many :deck_cards, dependent: :nullify
  has_many :cards, through: :deck_cards
end
