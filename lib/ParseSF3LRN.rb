require 'rubygems'
require 'fastercsv'

# Main data path
#data_path = '/data/IPCensus/'

# Test data path
data_path = '/data/temp/minidata/'

# ZIPLIKE and Logical Record Number file
zip_logrec = data_path + 'ZIPLIKELogRecNo.tsv'
# SF3 data file
sf3_data = data_path + 'us00001.uf3'
# data file with only selected logical record numbers
out_data = data_path + 'ZIPLIKEus00001.tsv'
# Options hash for tab separated values
tab_sep = {:col_sep => "\t"}

ziplike_hash = Hash.new()
FasterCSV.foreach(zip_logrec, options = tab_sep) do |row|
  ziplike_hash[row[0]] = row[1]
end

p ziplike_hash['78758']
p ziplike_hash['50459']



ziplike_hash.clear()


