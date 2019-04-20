class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, dependent: :destroy
  has_many :investments, dependent: :destroy
  has_many :investment_projects, through: :investments, source: :project
  has_many :likes, dependent: :destroy
  has_many :liked_projects, through: :likes, source: :project

  def owner?(project)
    self == project.owner
  end

  def invest_in?(project)
    investments.exists?(project: project)
  end

  def investment_amount(project)
    return 0 unless invest_in?(project)

    investment = investments.find_by(project: project)
    investment.price
  end

  def like!(project)
    likes.create!(project: project)
  end

  def remove_like!(project)
    raise 'プロジェクトにいいねしていません' unless liked?(project)

    likes.find_by(project: project).destroy!
  end

  def liked?(project)
    likes.exists?(project: project)
  end
end
