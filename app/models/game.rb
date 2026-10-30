class Game < ApplicationRecord
  has_one :deck, dependent: :destroy
  has_many :hands, dependent: :destroy

  enum :status, {
    waiting: "waiting",
    in_progress: "in_progress",
    player_won: "player_won",
    dealer_won: "dealer_won",
    dealer_turn: "dealer_turn",
    push: "push"
  }, default: :waiting

  def self.start!
    Game.transaction do
      game = Game.create!

      deck = game.create_deck!
      game.hands.create!(role: "dealer")
      game.hands.create!(role: "player")
      game.hands.create!(role: "discarded")
      cards = Card.all

      positions = (0...cards.size).to_a.shuffle

      cards.each_with_index do |card, index|
        deck.deck_cards.create!(card: card, position: positions[index])
      end
      game
    end
  end

  def player_hand
    hands.find_by(role: "player")
  end

  def dealer_hand
    hands.find_by(role: "dealer")
  end

  def discard_hands
    # don't want to destroy the hands for this game but just set cards them back to nil?
    discard_hand_id = hands.find_by(role: "discarded")
    deck_cards = DeckCard.where(hand: [ player_hand, dealer_hand ])
    deck_cards.update_all(hand_id: discard_hand_id.id)
  end

  def hand_finished_check
    dealer_hand = hands.find_by(role: "dealer")
    player_hand = hands.find_by(role: "player")

    dhand_score = dealer_hand.get_hand_score
    phand_score = player_hand.get_hand_score

    pblackjack = player_hand.is_blackjack?
    dblackjack = dealer_hand.is_blackjack?

    if  pblackjack && !dblackjack ||
      phand_score == 21 ||
      (phand_score < 21 && phand_score > dhand_score) ||
      dhand_score > 21
      unless player_score.nil?
        increment(:player_score)
        save!
      end
      player_won!
    elsif dblackjack && !pblackjack ||
      phand_score > 21 ||
      phand_score < dhand_score
      unless dealer_score.nil?
        increment!(:dealer_score)
        save!
      end
      dealer_won!
    elsif phand_score == dhand_score
      push!
    end
  end

  def add_card_to_hand(role)
    next_card = deck.deck_cards.where(hand_id: nil).order(:position).first
    role_hand = hands.find_by(role: role)
    next_card.hand_id = role_hand.id
    next_card.save!
  end

  def dealer_step
    # finish the dealer hand
    dealer_turn!
    dealer_hand = hands.find_by(role: "dealer")

    if dealer_hand.get_hand_score < 17
      add_card_to_hand("dealer")
    else
      hand_finished_check
    end
  end
end
