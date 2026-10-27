class DeckCard < ApplicationRecord
  belongs_to :deck
  belongs_to :card
  belongs_to :hand, optional: true
end
