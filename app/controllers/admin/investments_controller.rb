class Admin::InvestmentsController < ApplicationController
  before_action :authenticate_user!

  def report
    @report_form = InvestmentsReportForm.new
  end

  def report_result
    @report_form = InvestmentsReportForm.new(report_form_params)
    @investments = InvestmentsReporter.new(@report_form, current_user).execute if @report_form.valid?
    render :report
  end

  private

  def report_form_params
    params.require(:range).permit(:start_date, :end_date)
  end
end
