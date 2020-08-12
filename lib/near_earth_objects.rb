require 'faraday'
require 'figaro'
require 'pry'
# Load ENV vars via Figaro
Figaro.application = Figaro::Application.new(environment: 'production', path: File.expand_path('../config/application.yml', __FILE__))
Figaro.load

class NearEarthObjects
  attr_reader :date

  def initialize(date)
    @date = date
  end

  def conn(date)
    Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key']}
    )
  end

  def asteroids_list_data(date)
    conn(date).get('/neo/rest/v1/feed')
  end

  def parsed_asteroids_data(date)
     JSON.parse(asteroids_list_data(date).body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end

  def largest_asteroid_diameter(date)
    parsed_asteroids_data(date).map do |astroid|
      asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
    end.max { |a,b| a<=> b}
  end

  def total_number_of_asteroids(date)
    parsed_asteroids_data(date).count
  end

  def formatted_asteroid_data(date)
    parsed_asteroids_data(date).map do |asteroid|
      {
        name: asteroid[:name],
        diameter: "#{asteroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
        miss_distance: "#{asteroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
      }
    end
  end

  def find_neos_by_date(date)
   {
     asteroid_list: formatted_asteroid_data(date),
     biggest_asteroid: largest_asteroid_diameter(date),
     total_number_of_asteroids: total_number_of_asteroids(date)
   }
 end
  # def self.find_neos_by_date(date)
  #   conn = Faraday.new(
  #     url: 'https://api.nasa.gov',
  #     params: { start_date: date, api_key: ENV['nasa_api_key']}
  #   )
  #   asteroids_list_data = conn.get('/neo/rest/v1/feed')
  #
  #   parsed_asteroids_data = JSON.parse(asteroids_list_data.body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  #
  #   largest_astroid_diameter = parsed_asteroids_data.map do |astroid|
  #     astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i
  #   end.max { |a,b| a<=> b}
  #
  #   total_number_of_astroids = parsed_asteroids_data.count
  #   formatted_asteroid_data = parsed_asteroids_data.map do |astroid|
  #     {
  #       name: astroid[:name],
  #       diameter: "#{astroid[:estimated_diameter][:feet][:estimated_diameter_max].to_i} ft",
  #       miss_distance: "#{astroid[:close_approach_data][0][:miss_distance][:miles].to_i} miles"
  #     }
  #   end
  #
  #   {
  #     astroid_list: formatted_asteroid_data,
  #     biggest_astroid: largest_astroid_diameter,
  #     total_number_of_astroids: total_number_of_astroids
  #   }
  # end
end
