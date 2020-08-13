require_relative './near_earth_objects'

class FormatNeos
    attr_reader :date

  def initialize(date)
    @date = date
  end

  def asteroid_details
    neos = NearEarthObjects.new(date)
    neos.find_neos_by_date
  end

  def asteroid_list
    asteroid_details[:asteroid_list]
  end

  def total_number_of_asteroids
     asteroid_details[:total_number_of_asteroids]
  end

  def largest_asteroid
     asteroid_details[:biggest_asteroid]
  end

  def column_labels
    { name: "Name", diameter: "Diameter", miss_distance: "Missed The Earth By:" }
  end
  def column_data
    column_labels.each_with_object({}) do |(col, label), hash|
    hash[col] = {
      label: label,
      width: [asteroid_list.map { |asteroid| asteroid[col].size }.max, label.size].max}
    end
  end

  def header
    "| #{ column_data.map { |_,col| col[:label].ljust(col[:width]) }.join(' | ') } |"
  end

  def divider
    "+-#{column_data.map { |_,col| "-"*col[:width] }.join('-+-') }-+"
  end

  def format_row_data(row_data, column_info)
    row = row_data.keys.map { |key| row_data[key].ljust(column_info[key][:width]) }.join(' | ')
    puts "| #{row} |"
  end

  def create_rows(asteroid_data, column_info)
    rows = asteroid_data.each { |asteroid| format_row_data(asteroid, column_info) }
  end

  def formated_date
    DateTime.parse(date).strftime("%A %b %d, %Y")
  end

end
