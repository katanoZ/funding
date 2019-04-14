class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :investments, dependent: :destroy
  has_many :investors, through: :investments, source: :user

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :price, numericality: { greater_than: 0 }
end
