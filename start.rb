require_relative './near_earth_objects'
require_relative './format_neos'


puts "________________________________________________________________________________________________________________________________"
puts "Welcome to NEO. Here you will find information about how many meteors, astroids, comets pass by the earth every day. \nEnter a date below to get a list of the objects that have passed by the earth on that day."
puts "Please enter a date in the following format YYYY-MM-DD."
print ">>"

date = gets.chomp
neos = FormatNeos.new(date)

puts "______________________________________________________________________________"
puts "On #{neos.formated_date}, there were #{neos.total_number_of_asteroids} objects that almost collided with the earth."
puts "The largest of these was #{neos.largest_asteroid} ft. in diameter."
puts "\nHere is a list of objects with details:"
puts neos.divider
puts neos.header
neos.create_rows(neos.asteroid_list, neos.column_data)
puts neos.divider
