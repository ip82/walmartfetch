class Product < ApplicationRecord
  validates :walmart_id, :name, :price, presence: true
  has_many :reviews, dependent: :destroy

  def self.currency
    '$' # hardcoded for now, though possibly can be retreived via Walmart API
  end
end
