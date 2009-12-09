require 'rubygems'
require 'geoip'

ip_path = '/data/ripd/GeoLiteCity.dat'

ip_data = GeoIP.new(ip_path)

print "Enter a host or IP address:"
ip = gets.strip

p ip_data.city(ip)
