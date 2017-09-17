class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.string :title, null: :false
      t.text :body, null: false
      t.datetime :submission_time, null: false
      t.integer :overall_rating
      t.string :reviewer
      t.integer :product_id, null: false

      t.timestamps
    end

    add_index :reviews, :reviewer
  end
end
