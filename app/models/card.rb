class Card < ApplicationRecord
  belongs_to :deck
  has_rich_text :back

  validates :front, presence: true
  validates :back, presence: true

  # 리뷰가 필요한 카드들을 찾는 스코프
  scope :due_for_review, -> { where("next_review_at IS NULL OR next_review_at <= ?", Time.current) }

  # 아직 한 번도 리뷰하지 않은 새로운 카드들
  scope :new_cards, -> { where(next_review_at: nil) }

  # 리뷰 시간이 지난 카드들
  scope :overdue, -> { where("next_review_at <= ?", Time.current) }

  # 카드가 새로운 카드인지 확인
  def new_card?
    next_review_at.nil?
  end

  # 카드가 리뷰 시간이 지났는지 확인
  def overdue?
    next_review_at.present? && next_review_at <= Time.current
  end
end
