class Deck < ApplicationRecord
  has_many :cards, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true

  scope :with_card_counts, -> {
    deck_columns = column_names.map { |col| "decks.#{col}" }

    left_joins(:cards)
      .select(
        *deck_columns,
        "COUNT(cards.id) AS total_cards_count",
        "SUM(CASE WHEN cards.next_review_at IS NULL THEN 1 ELSE 0 END) AS new_cards_count",
        "SUM(CASE WHEN cards.next_review_at IS NOT NULL AND cards.next_review_at <= CURRENT_TIMESTAMP THEN 1 ELSE 0 END) AS overdue_cards_count",
        "SUM(CASE WHEN cards.next_review_at IS NULL OR cards.next_review_at <= CURRENT_TIMESTAMP THEN 1 ELSE 0 END) AS cards_due_for_review_count"
      )
      .group(*deck_columns)
  }

  def to_s
    name
  end

  # 복습이 필요한 카드 수를 반환하는 메소드
  def cards_due_for_review_count
    read_attribute(:cards_due_for_review_count) || cards.due_for_review.count
  end

  # 새로운 카드 수를 반환하는 메소드
  def new_cards_count
    read_attribute(:new_cards_count) || cards.new_cards.count
  end

  # 복습 시간이 지난 카드 수를 반환하는 메소드
  def overdue_cards_count
    read_attribute(:overdue_cards_count) || cards.overdue.count
  end

  def learned_cards_count
    total_cards_count - cards_due_for_review_count
  end

  def total_cards_count
    read_attribute(:total_cards_count) || cards.count
  end

  # 총 카드 수 대비 복습이 필요한 카드의 비율을 반환하는 메소드
  def review_progress_percentage
    total_cards = cards.count
    return 0 if total_cards.zero?

    due_cards = cards_due_for_review_count
    ((total_cards - due_cards).to_f / total_cards * 100).round(1)
  end
end
