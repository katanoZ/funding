class InvestmentsReporter
  delegate :valid?, to: :@form
  attr_reader :form

  def initialize(params = nil, user = nil)
    @form = InvestmentsReportForm.new(params)
    @user = user
  end

  def execute
    Investment.for_projects_created_by(user)
              .created_within(range)
              .includes(:project, :user)
              .order(:project_id, :user_id)
  end

  private

  attr_reader :user

  def range
    (form.start_date.beginning_of_day)..(form.end_date.end_of_day)
  end
end
