class Investment < ApplicationRecord
  belongs_to :project
  belongs_to :user

  delegate :name, to: :project, prefix: true
  delegate :name, to: :user, prefix: true

  validates :price, numericality: { greater_than: 0, only_integer: true }
  validates :project, uniqueness: { scope: :user, message: 'に投資済みです' }
  validate :verify_owner

  scope :for_projects_created_by, ->(user) do
    where(project: user.projects)
  end

  scope :created_within, ->(range) do
    where(created_at: range)
  end

  private

  def verify_owner
    errors.add(:project, 'のオーナーは投資できません') if user.owner?(project)
  end
end
