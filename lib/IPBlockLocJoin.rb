require 'rubygems'
require 'geoip'
require 'fastercsv'

# Uses the GeoIP gem to look up a data entry about a certain IP or host.
#
#ip_path = '/data/ripd/GeoLiteCity.dat'
#
#ip_data = GeoIP.new(ip_path)
#
#print "Enter a host or IP address:"
#ip = gets.strip
#
#p ip_data.city(ip)

# Main data path
data_path = '/data/ripd/GeoLiteCity_20091201/'

# Test data path
#data_path = '/data/temp/minidata/'

# US locations file in format loc id, country, state, city, zip code, lat, long, metro code, area code
ip_locations = data_path + 'GeoLiteCity-USLocation.csv' 
# IP blocks file in format start ip, end ip, loc id
ip_blocks = data_path + 'GeoLiteCity-Blocks.csv'
# output file matching IP blocks to loaction using loc id
ip_output = data_path + 'USBlocksLocation.csv'

loc_hash = Hash.new(0)

# put location data into a hash with the location id as key
FasterCSV.foreach(ip_locations) do |row|
  loc_hash[row[0]] = row[1..-1]
end

# match IP blocks with loaction and output to a csv file
FasterCSV.foreach(ip_blocks) do |row|
  if loc_hash.key?(row[2])
    FasterCSV.open(ip_output, "a") do |csv|
      csv << row[0..1] + loc_hash[row[2]]
    end
  end
end