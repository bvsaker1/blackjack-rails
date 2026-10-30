module GamesHelper
  def get_dealer_cards
    hand_cards("dealer")
  end

  def get_player_cards
    hand_cards("player")
  end

  private

  # deck_cards dealt to the hand, in deal order, with their card preloaded
  def hand_cards(role)
    @game.hands.find_by(role: role).deck_cards.includes(:card).order(:position)
  end
end
