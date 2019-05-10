class InvestmentsReporter
  def initialize(form, user)
    @form = form
    @user = user
  end

  def execute
    Investment.for_projects_created_by(user)
              .created_within(range)
              .includes(:project, :user)
              .order(:project_id, :user_id, :created_at)
  end

  private

  attr_reader :form, :user

  def range
    (form.start_date.beginning_of_day)..(form.end_date.end_of_day)
  end
end
