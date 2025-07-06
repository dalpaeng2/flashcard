class AddNextReviewAtToCards < ActiveRecord::Migration[8.0]
  def change
    add_column :cards, :next_review_at, :datetime
  end
end
