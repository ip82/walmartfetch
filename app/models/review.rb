class Review < ApplicationRecord
  validates :title, :body, :product_id, presence: true

  belongs_to :product
end
