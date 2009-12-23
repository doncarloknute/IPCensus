require 'rubygems'
require 'fastercsv'

# Main data path
#data_path = '/data/ripd/www2.census.gov/census_2000/datasets/Summary_File_3/0_National/'
data_path = '/data/ripd/GeoLiteCity_20091201/'

# Test data path
#data_path = '/data/temp/minidata/'

# Geo data file
geo_data = data_path + 'usgeo.uf3'
# IP blocks and location data file
iploc_data = data_path + 'USBlocksLocation.csv'
# Output data file
out_data = data_path + 'USIPLocLogRecNum.csv'
# Skipped data file
skipped = data_path + 'IPBlocksSkipped.csv'

# Read in geo data from geo file
geozip_hash = Hash.new()
IO.foreach(geo_data) do |entry|
  georow = []
  georow[0] = entry[18..24]  #logical record number
  georow[1] = entry[160..164]  #ZCTA5
  georow[2] = entry[292..300].to_i  #population
  georow[3] = entry[310..318].insert(3, '.')  #latitute
  georow[4] = entry[319..328].insert(4, '.')  #longitude
  if georow[1] != '     '
    if geozip_hash.key?(georow[1])
      p georow[1]
      raise Exception, "Multiple entries for a ZCTA5 code."
    else
      geozip_hash[georow[1]] = georow
    end
  end
end

# Open IP blocks and location data and match zip codes to logical record number.
# Then add logical record number to the end of each row.
# If the location data has a zip code that doesn't match to a logical record number, write that data to a "skipped" file.
record_hash = Hash.new()
FasterCSV.foreach(iploc_data) do |row|
  if row[5] != ''
    if geozip_hash.key?(row[5])
      row[10] = geozip_hash[row[5]][0]
      FasterCSV.open(out_data, "a") do |csv|
        csv << row
      end
    else
      FasterCSV.open(skipped, "a") do |csv|
        csv << row
      end
#      raise Exception, "Missing entry for a ZCTA5 code."
    end
  end
end

geozip_hash.clear
record_hash.clear

