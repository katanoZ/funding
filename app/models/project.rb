class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :investments, dependent: :destroy
  has_many :investors, through: :investments, source: :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :project_categories, dependent: :destroy
  has_many :categories, through: :project_categories

  accepts_nested_attributes_for :project_categories,
                                reject_if: :reject_blank_categories,
                                allow_destroy: true

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :price, numericality: { greater_than: 0, only_integer: true }
  validate :verify_cateogry_ids

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

  def reject_blank_categories(attributes)
    exists = attributes[:id].present?
    empty = attributes[:category_id].empty?
    attributes[:_destroy] = 1 if exists && empty
    !exists && empty
  end

  def verify_cateogry_ids
    uniq = []
    project_categories.each do |project_category|
      next if project_category[:category_id].nil?

      if uniq.include?(project_category[:category_id])
        errors.add(:base, '同じカテゴリは選択できません')
        return false
      else
        uniq << project_category[:category_id]
      end
    end
    true
  end
end
