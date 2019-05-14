class InvestmentsReportForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :start_date, :date
  attribute :end_date, :date

  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :verify_range

  def range
    (start_date.beginning_of_day)..(end_date.end_of_day)
  end

  def params
    { start_date: start_date, end_date: end_date }
  end

  private

  def verify_range
    return if start_date.nil? || end_date.nil?
    return if start_date <= end_date

    errors.add(:base, '開始日は終了日より前に設定してください')
  end
end
