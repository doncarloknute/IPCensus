require 'rubygems'
require 'fastercsv'

# Main data path
data_path = '/data/IPCensus/'

# Test data path
#data_path = '/data/temp/minidata/'

# ZIPLIKE and Logical Record Number file
zip_logrec = data_path + 'ZIPLIKELogRecNo.tsv'
# SF3 data file
sf3_data = data_path + 'us00001.uf3'
# data file with only selected logical record numbers
out_data = data_path + 'ZIPLIKEus00001.tsv'
# Options hash for tab separated values
tab_sep = {:col_sep => "\t"}
# Options hash to force quote entries
force_quote = {:force_quotes => true}

ziplike_hash = Hash.new()
FasterCSV.foreach(zip_logrec, options = tab_sep) do |row|
  ziplike_hash[row[1]] = row[0]
end

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

ziplike_hash.clear()


