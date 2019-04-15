class Investment < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :price, numericality: { greater_than: 0 }
  validates :project, uniqueness: { scope: :user, message: 'に投資済みです' }
  validate :user_cannot_be_owner

  private

  def user_cannot_be_owner
    errors.add(:project, 'のオーナーは投資できません') if user.owner?(project)
  end
end
