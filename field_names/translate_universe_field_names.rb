require 'rubygems'
require 'fastercsv'

raw_field_names = 'raw_universe_with_counts.tsv'
mod_names = 'mod_universe_with_counts.tsv'
first_pass = 'mod_raw_with_counts_aligned.tsv'

field_hash = Hash.new

File.open(first_pass).each do |line|
  line.chomp!
  row = line.dup.split("\t")
  mod_field = row[1].rstrip
  orig_field = row[2].rstrip
  field_hash[orig_field] = mod_field
  puts orig_field + "\t" + mod_field
end

