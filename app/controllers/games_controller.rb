class GamesController < ApplicationController
  before_action :set_game

  def index
    if @game.dealer_turn?
      # stand
      if @game.updated_at < 1.second.ago
        @game.dealer_step
      end
    elsif (@game.dealer_won? || @game.player_won? || @game.push?) &&
      @game.updated_at < 3.seconds.ago
      @game.waiting!
    end
  end

  def deal
    # @game.status = "in_progress"
    logger.info("status changed to in_progress")
    @game.hands.each do |hand|
      @game.discard_hands
    end

    # determine if shuffle is needed if less than 20 cards
    remaining = @game.deck.deck_cards.where(hand_id: nil).order(:position)
    if remaining.size < @game.deck.deck_cards.size * 0.20
      shuffle
    end

    # deal, from the remaining cards in the deck
    remaining[0].hand_id = @game.player_hand.id
    remaining[1].hand_id = @game.dealer_hand.id
    remaining[2].hand_id = @game.player_hand.id
    remaining[3].hand_id = @game.dealer_hand.id

    (0..3).each do |index|
      remaining[index].save!
    end

    @game.in_progress!

    score_21_check
  end

  def hit
    # add a card from the deck which is next deck_card in the list with hand_id=nil
    @game.add_card_to_hand("player")

    score_21_check
  end

  def stand
    # finish the dealer hand
    @game.dealer_turn!

    redirect_to root_path
  end

  def reset
    @game.destroy

    redirect_to root_path
  end

  private

  def set_game
    @game = Game.find_by(id: session[:game_id])

    if @game.nil? || @game.deck.nil?
      @game = Game.start!
      session[:game_id] = @game.id
    else
      @game = Game.find_by(id: session[:game_id])
    end
  end

  def shuffle
    deck = Deck.where("game_id=#{@game.id}")
    deck_cards = DeckCard.where("deck_id=#{deck[0].id}")
    shuffled = (0...deck_cards.size).to_a.shuffle

    deck_cards.each_with_index do |card, index|
      card.position = shuffled[index]
      card.hand_id = nil
      card.save!
    end

    logger.info("Shuffled Deck")
  end

  def score_21_check
    player_hand = @game.hands.find_by(role: "player")
    score = player_hand.get_hand_score

    if score == 21
      stand
    else
      if score > 21
        @game.hand_finished_check
      end

      redirect_to root_path
    end
  end
end
