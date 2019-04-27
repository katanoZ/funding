class ProjectCategory < ApplicationRecord
  belongs_to :project
  belongs_to :category

  NUMBER_OF_CATEGORIES = 3

  validates :category, uniqueness: { scope: :project, message: 'は既に存在します' }
end
