class Investment < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :price, numericality: { greater_than: 0, only_integer: true }
  validates :project, uniqueness: { scope: :user, message: 'に投資済みです' }
  validate :verify_owner

  private

  def verify_owner
    errors.add(:project, 'のオーナーは投資できません') if user.owner?(project)
  end
end
