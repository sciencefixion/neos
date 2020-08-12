require 'faraday'
require 'figaro'
require 'pry'

class NearEarthObjectService
  def get_api(date)
    Faraday.new(
      url: 'https://api.nasa.gov',
      params: { start_date: date, api_key: ENV['nasa_api_key']}
    )
  end
  def get_asteroids_list_data(date)
    get_api(date).get('/neo/rest/v1/feed')
  end
  def neos(date)
    JSON.parse(get_asteroids_list_data(date).body, symbolize_names: true)[:near_earth_objects][:"#{date}"]
  end
end
