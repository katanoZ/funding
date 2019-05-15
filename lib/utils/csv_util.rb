require 'csv'

module CsvUtil
  def self.generate_csv(records, column_names, header = nil)
    CSV.generate(headers: (header.present? ? true : false)) do |csv|
      csv << header if header.present?
      records.each do |record|
        column_values = []
        column_names.map { |column| column_values << record.send(column) }
        csv << column_values
      end
    end
  end
end
