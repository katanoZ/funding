class DateRangeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.between?(Date.today.prev_year, Date.today)

    record.errors[attribute] << (options[:message] || 'は1年前から本日までの範囲で入力してください')
  end
end
