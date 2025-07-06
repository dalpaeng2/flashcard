class Card < ApplicationRecord
  belongs_to :deck
  has_rich_text :back

  validates :front, presence: true
  validates :back, presence: true
end
