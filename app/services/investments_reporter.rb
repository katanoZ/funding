# frozen_string_literal: true

require 'csv'

class InvestmentsReporter
  FILEMAME = 'investments_report'

  delegate :valid?, :range, :params, :start_date, :end_date, to: :@form
  attr_reader :form

  def initialize(params = nil, user = nil)
    @form = InvestmentsReportForm.new(params)
    @user = user
  end

  def search
    Investment.for_projects_created_by(user)
              .created_within(range)
              .includes(:project, :user)
              .order(:project_id, :user_id)
  end

  def generate_csv
    CSV.generate(headers: true) do |csv|
      csv << header
      search.each do |investment|
        csv << [
          investment.project.name,
          investment.user.name,
          investment.price.to_s(:currency),
          I18n.l(investment.created_at, format: :long)
        ]
      end
    end
  end

  def filename
    "#{FILEMAME}_#{start_date}_#{end_date}.csv"
  end

  private

  attr_reader :user

  def header
    [
      Project.human_attribute_name(:name),
      User.human_attribute_name(:name),
      Investment.human_attribute_name(:price),
      Investment.human_attribute_name(:created_at)
    ]
  end
end
