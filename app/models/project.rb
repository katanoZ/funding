class Project < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :price, numericality: { greater_than: 0 }
end
