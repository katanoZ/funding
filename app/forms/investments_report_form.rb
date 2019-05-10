class InvestmentsReportForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :start_date, :date
  attribute :end_date, :date

  validates :start_date, presence: true
  validates :start_date, date_range: true, if: -> { start_date.present? }
  validates :end_date, presence: true
  validates :end_date, date_range: true, if: -> { end_date.present? }

  validate :verify_start_and_end_dates, if: :start_and_end_dates_entered?

  private

  def start_and_end_dates_entered?
    start_date && end_date
  end

  def verify_start_and_end_dates
    errors.add(:base, '開始日は終了日より前に設定してください') if start_date > end_date
  end
end
