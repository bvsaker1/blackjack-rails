class Hand < ApplicationRecord
  belongs_to :game
  has_many :deck_cards, dependent: :nullify
  has_many :cards, through: :deck_cards

  def get_hand_score
    # get the cards score
    score = 0
    ace_count = 0
    deck_cards.each do |deck_card|
      value, ace = rank_score(score, deck_card.card)
      score += value
      if ace
        ace_count += 1
      end
    end
    score = ace_adjustments(score, ace_count)
  end

  def ace_adjustments(score, ace_count)
    count = ace_count
    while count > 0 && score > 21
      count -= 1
      score -= 10
    end
    score
  end

  def is_blackjack?
    if deck_cards.length == 2 && get_hand_score == 21
      true
    else
      false
    end
  end

  def get_visible_score
    score, _ = rank_score(0, deck_cards.order(:position)[1])
    score
  end

  def rank_score(score, card)
    value = 0
    ace = false
    if card.rank == "A"
      value = 11
      ace = true
    elsif card.rank == "K" || card.rank == "Q" || card.rank == "J"
      value = 10
    else
      value = card.rank.to_i
    end
    return value, ace
  end
end
