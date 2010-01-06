require 'rubygems'
require 'fastercsv'

# Main data path
data_path = '/data/IPCensus/'

# Census data path
census_path = '/data/ripd/www2.census.gov/census_2000/datasets/Summary_File_3/0_National/'

# Test data path
#data_path = '/data/temp/minidata/'

# ZIPLIKE and Logical Record Number file
zip_logrec = data_path + 'zip_codes_to_logical_record_number.tsv'
# SF3 data file
#sf3_data = census_path + 'us00001.uf3'
# data file with only selected logical record numbers
#out_data = data_path + 'census_2000_sf3_zip_us00001.tsv'
# Options hash for tab separated values
tab_sep = {:col_sep => "\t"}
# Options hash to force quote entries
force_quote = {:force_quotes => true}

ziplike_hash = Hash.new()
FasterCSV.foreach(zip_logrec, options = tab_sep) do |row|
  ziplike_hash[row[1]] = row[0]
end

Dir.chdir(census_path)
Dir.glob("us000??.uf3") do |filename|
  sf3_data = census_path + filename
  out_data = data_path + "census_2000_sf3_zip_us000" + filename[5..6] + ".tsv"
  FasterCSV.foreach(sf3_data, options = force_quote) do |row|
    outrow = []
    if ziplike_hash.key?(row[4])
      outrow[0] = ziplike_hash[row[4]] #put ziplike as first item
      outrow += row[4..-1] #put logical record number and all other data as the rest
      FasterCSV.open(out_data, "a", options = tab_sep) do |csv|
        csv << outrow
      end
    end
  end
end

ziplike_hash.clear()


