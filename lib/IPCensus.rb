require 'rubygems'
require 'fastercsv'

# Main data path
#data_path = '/data/ripd/www2.census.gov/census_2000/datasets/Summary_File_3/0_National/'

# Test data path
data_path = '/data/temp/minidata/'

# Geo data file
geo_data = data_path + 'usgeo.uf3'

# Read in geo data from geo file
record_hash = Hash.new()
IO.foreach(geo_data) do |entry|
  georow = []
  georow[0] = entry[18..24]  #logical record number
  georow[1] = entry[29..30]  #state
  georow[2] = entry[31..33]  #county
  georow[3] = entry[142..143]  #congressional district (110th)
  georow[4] = entry[160..164]  #ZCTA5
  georow[5] = entry[292..300]  #population
  georow[6] = entry[310..318].insert(3, '.')  #latitute
  georow[7] = entry[319..328].insert(4, '.')  #longitude
  if georow[4] != '     '
    if record_hash.key?(georow[4]) == false
      record_hash[georow[4]] = georow
    end
  end
end

p record_hash