class Game < ApplicationRecord
  has_one :deck, dependent: :destroy
  has_many :hands, dependent: :destroy
end
