class Idea < ApplicationRecord
  belongs_to :category
  validates :body, presence: true
  validates :category_id, presence: true
end
