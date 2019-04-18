class Like < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :project, uniqueness: { scope: :user, message: 'に既にいいね済みです' }
  validate :verify_owner

  private

  def verify_owner
    errors.add(:project, 'のオーナーはいいねできません') if user.owner?(project)
  end
end
