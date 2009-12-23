require 'rubygems'
require 'fastercsv'

# Main data path
#data_path = '/data/ripd/www2.census.gov/census_2000/datasets/Summary_File_3/0_National/'

# Test data path
data_path = '/data/temp/minidata/'

# Geo data file
geo_data = data_path + 'usgeo.uf3'
# IP blocks and location data file
iploc_data = data_path + 'USBlocksLocation.csv'
# Output data file
out_data = data_path + 'USIPLocLogRecNum.csv'

# Read in geo data from geo file
geozip_hash = Hash.new()
IO.foreach(geo_data) do |entry|
  georow = []
  georow[0] = entry[18..24]  #logical record number
  georow[1] = entry[29..30]  #state
  georow[2] = entry[31..33]  #county
  georow[3] = entry[142..143]  #congressional district (110th)
  georow[4] = entry[160..164]  #ZCTA5
  georow[5] = entry[292..300].to_i  #population
  georow[6] = entry[310..318].insert(3, '.')  #latitute
  georow[7] = entry[319..328].insert(4, '.')  #longitude
  if georow[4] != '     '
    if geozip_hash.key?(georow[4])
      p georow[4]
      raise Exception, "Multiple entries for a ZCTA5 code."
    else
      geozip_hash[georow[4]] = georow
    end
  end
end

# Open IP blocks and location data and match zip codes to logical record number
record_hash = Hash.new()
FasterCSV.foreach(iploc_data) do |row|
  if geozip_hash.key?(row[5])
    p geozip_hash[row[5]]
  else
    raise Exception, "Missing entry for a ZCTA5 code."
  end
end

geozip_hash.clear

