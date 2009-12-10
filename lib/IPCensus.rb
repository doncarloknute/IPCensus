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

data_path = '/data/ripd/GeoLiteCity_20091201/'
ip_locations = data_path + 'GeoLiteCity-USLocation.csv'

FasterCSV.foreach(ip_locations) do |row|
  if row[3] == "Austin"
    p row
  end
end