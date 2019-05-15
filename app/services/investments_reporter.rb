# frozen_string_literal: true

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

  def export_csv
    CsvUtil.generate_csv(search, column_names, header)
  end

  def filename
    "#{FILEMAME}_#{start_date}_#{end_date}.csv"
  end

  private

  attr_reader :user

  def column_names
    %w[project_name user_name price]
  end

  def header
    [
      Project.human_attribute_name(:name),
      User.human_attribute_name(:name),
      Investment.human_attribute_name(:price)
    ]
  end
end
