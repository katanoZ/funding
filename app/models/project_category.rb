class ProjectCategory < ApplicationRecord
  belongs_to :project
  belongs_to :category

  validates :category, uniqueness: { scope: :project, message: 'は既に存在します' }
end
