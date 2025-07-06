class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.string :front
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
