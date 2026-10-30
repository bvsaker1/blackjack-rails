class DeckCard < ApplicationRecord
  belongs_to :deck
  belongs_to :card
  belongs_to :hand, optional: true

  delegate :suit, :rank, :image_file, :alt_text, to: :card
end
