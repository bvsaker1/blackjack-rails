class Card < ApplicationRecord
  has_many :deck_cards

  # e.g. "cards/HA.png" for the Ace of Hearts
  def image_file
    "cards/#{suit[0]}#{rank}.png"
  end

  def alt_text
    "#{rank} of #{suit}"
  end
end
