require 'rubygems'
require 'geoip'
require 'fastercsv'


# Main data path
data_path = '/data/ripd/GeoLiteCity_20100201/'

# Test data path
#data_path = '/data/temp/minidata/'

# US locations file in format loc id, country, state, city, zip code, lat, long, metro code, area code
# ip_locations = data_path + 'GeoLiteCity-Location-US.csv' 
ip_locations = data_path + 'GeoLiteCity-Location.csv' 

# IP blocks file in format start ip, end ip, loc id
ip_blocks = data_path + 'GeoLiteCity-Blocks.csv'

# output file matching IP blocks to loaction using loc id
# ip_output = File.open(data_path + 'ip_blocks_us_geo.tsv', 'w')
ip_output = File.open(data_path + 'ip_blocks_world_geo.tsv', 'w')

loc_hash = Hash.new(0)

# put location data into a hash with the location id as key
File.open(ip_locations).each do |line|
  line.chomp!
  unless line =~ /^\d+\,\"\w{2}\"\,(.*)/ then warn "Skipped line: #{line}" ; next ; end
  row = line.split(',')
  loc_hash[row[0].to_i] = row[1..-1]
end

# Build a tab separated table from the US IP blocks
File.open(ip_blocks).each do |line|
  line.chomp!
  outrow = []
  unless line =~ /^\"(\d+)\"\,\"(\d+)\"\,\"(\d+)\"/ then warn "Skipped line: #{line}" ; next ; end
  outrow[0], outrow[1], location_key = [$1.to_i, $2.to_i, $3.to_i]
  outrow[2] = "#{(outrow[0]/16777216)%256}.#{(outrow[0]/65536)%256}.#{(outrow[0]/256)%256}.#{outrow[0]%256}" #IP block start num in string format
  outrow[3] = "#{(outrow[1]/16777216)%256}.#{(outrow[1]/65536)%256}.#{(outrow[1]/256)%256}.#{outrow[1]%256}" #IP block end num in string format
  if loc_hash.key?(location_key)
    outrow[4..11] = loc_hash[location_key] 
    ip_output << outrow.join("\t") + "\n"
  end
end
