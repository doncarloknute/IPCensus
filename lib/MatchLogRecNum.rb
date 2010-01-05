require 'rubygems'
require 'fastercsv'

# Main data path
#data_path = '/data/ripd/www2.census.gov/census_2000/datasets/Summary_File_3/0_National/'
#data_path = '/data/ripd/GeoLiteCity_20091201/'

# Test data path
data_path = '/data/temp/minidata/'

# Geo data file
geo_data = data_path + 'usgeo.uf3'
# IP blocks and location data file
iploc_data = data_path + 'USBlocksLocation.csv'
# Output data file
out_data = data_path + 'USBlocksZIPLIKE.tsv'
# Skipped data file
#skipped = data_path + 'IPBlocksSkipped.csv'
# ZIPLIKE and Logical Record Number file
zip_logrec = data_path + 'ZIPLIKELogRecNo.tsv'
# Options hash for tab separated values
tab_sep = {:col_sep => "\t"}

# Read in geo data from geo file
geozip_hash = Hash.new()
IO.foreach(geo_data) do |entry|
  georow = []
  georow[0] = entry[18..24]  #logical record number
  georow[1] = entry[160..164]  #ZCTA5
  georow[2] = entry[292..300].to_i  #population
  georow[3] = entry[310..318].insert(3, '.').to_f  #latitute
  georow[4] = entry[319..328].insert(4, '.').to_f  #longitude
  if georow[1] != '     '
    if geozip_hash.key?(georow[1])
      p georow[1]
      raise Exception, "Multiple entries for a ZCTA5 code."
    else
      geozip_hash[georow[1]] = georow
    end
  end
end

# Build a tab separated table from the US IP blocks
FasterCSV.foreach(iploc_data) do |row|
  outrow = []
  outrow[0] = row[0] #IP block start num
  outrow[1] = row[1] #IP block end num
  outrow[2] = "#{(row[0]/16777216)%256}.#{(row[0]/65536)%256}.#{(row[0]/256)%256}.#{row[0]%256}" #IP block start num in string format
  outrow[3] = "#{(row[1]/16777216)%256}.#{(row[1]/65536)%256}.#{(row[1]/256)%256}.#{row[1]%256}" #IP block end num in string format
  outrow[4] = row[5] #ZIP code associated with IP block
  outrow[5] = geozip_hash[row[5]][1] #ZIPlike number associated with IP block
  outrow[6] = row[2] #country
  outrow[7] = row[3] #state
  outrow[8] = row[4] #city
  outrow[9] = row[6] #latitude
  outrow[10] = row[7] #longitude
  outrow[11] = row[8] #metro code
  outrow[12] = row[9] #area code
  FasterCSV.open(out_data, "a", options = tab_sep) do |csv|
    csv << outrow
  end
end

geozip_hash.clear

