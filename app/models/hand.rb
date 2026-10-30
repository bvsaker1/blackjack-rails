class Hand < ApplicationRecord
  belongs_to :game
  has_many :deck_cards, dependent: :nullify
  has_many :cards, through: :deck_cards

  def get_hand_score
    # get the cards score
    score = 0
    deck_cards.each do |deck_card|
      score += rank_score(score, deck_card.card)
    end
    score
  end

  def get_visible_score
    rank_score(0, deck_cards.order(:position)[1])
  end

  def rank_score(score, card)
    value = 0
    if card.rank == "A"
      if score < 11
        value = 11
      else
        value = 1
      end
    elsif card.rank == "K" || card.rank == "Q" || card.rank == "J"
      value = 10
    else
      value = card.rank.to_i
    end
    value
  end
end
