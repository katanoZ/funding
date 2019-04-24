class Category < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :projects, through: :categorizations

  validates :name, presence: true
  validates :name, uniqueness: true
end
