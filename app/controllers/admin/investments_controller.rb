class Admin::InvestmentsController < ApplicationController
  before_action :authenticate_user!

  def report
    @reporter = InvestmentsReporter.new
  end

  def generate_report
    @reporter = InvestmentsReporter.new(report_params, current_user)
    @investments = @reporter.execute if @reporter.valid?
    render :report
  end

  private

  def report_params
    params.require(:report).permit(:start_date, :end_date)
  end
end
