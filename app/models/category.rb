class Category < ApplicationRecord
  has_many :project_categories, dependent: :destroy
  has_many :projects, through: :project_categories

  validates :name, presence: true
  validates :name, uniqueness: true
end
