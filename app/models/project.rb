class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :investments, dependent: :destroy
  has_many :investors, through: :investments, source: :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :price, numericality: { greater_than: 0, only_integer: true }

  scope :investable, ->(user) do
    not_owned_by(user).not_invested_by(user)
  end

  scope :not_owned_by, ->(user) do
    where.not(owner: user)
  end

  scope :not_invested_by, ->(user) do
    where.not(id: user.investment_projects)
  end

  def investments_amount
    investments.sum(:price)
  end
end
