class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, dependent: :destroy
  has_many :investments, dependent: :destroy
  has_many :investment_projects, through: :investments, source: :project

  def owner?(project)
    self == project.owner
  end

  def invest_in?(project)
    investments.exists?(project: project)
  end

  def investment_amount(project)
    investment = investments.find_by(project: project)
    investment&.price
  end
end
