class Admin::InvestmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reporter, only: %i[generate_report generate_csv_report]

  def report
    @reporter = InvestmentsReporter.new
  end

  def generate_report
    @investments = @reporter.investments if @reporter.valid?
    render :report
  end

  def generate_csv_report
    send_data @reporter.export_csv, filename: @reporter.filename
  end

  private

  def report_params
    params.require(:report).permit(:start_date, :end_date)
  end

  def set_reporter
    @reporter = InvestmentsReporter.new(report_params, current_user)
  end
end

