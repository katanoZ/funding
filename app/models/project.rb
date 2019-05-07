class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :investments, dependent: :destroy
  has_many :investors, through: :investments, source: :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :project_categories, dependent: :destroy
  has_many :categories, through: :project_categories

  accepts_nested_attributes_for :project_categories

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :price, numericality: { greater_than: 0, only_integer: true }
  validate :verify_cateogry_ids, if: :category_id_entered?

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

  def category_id_entered?
    category_ids.any?
  end

  def verify_cateogry_ids
    return true if category_ids_uniq?

    errors.add(:base, '同じカテゴリは選択できません')
    false
  end

  def category_ids
    project_categories.map(&:category_id)
  end

  def category_ids_uniq?
    (category_ids.size - category_ids.uniq.size).zero?
  end
end
