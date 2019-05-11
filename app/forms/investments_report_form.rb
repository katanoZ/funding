class InvestmentsReportForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :start_date, :date
  attribute :end_date, :date

  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :verify_term
  validate :verify_range, if: :start_and_end_dates_entered?

  private

  def verify_term
    verify_date_term(start_date, :start_date) if start_date.present?
    verify_date_term(end_date, :end_date) if end_date.present?
  end

  def verify_date_term(date, attribute)
    return if date.between?(Date.today.prev_year, Date.today)

    errors.add(attribute, 'は1年前から本日までの期間で入力してください')
  end

  def start_and_end_dates_entered?
    start_date && end_date
  end

  def verify_range
    errors.add(:base, '開始日は終了日より前に設定してください') if start_date > end_date
  end
end
