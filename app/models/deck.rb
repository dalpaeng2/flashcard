class Deck < ApplicationRecord
  has_many :cards, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  def to_s
    name
  end
end
