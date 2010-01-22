
mod_field_names = 'mod_universe_with_counts_aligned.tsv'
codes_names = 'raw_with_field_code_universe.tsv'

const_field_names = File.open("constructed_field_names.tsv", "w")
long_names = File.open("long_field_names.tsv", "w")

field_hash = Hash.new

File.open(mod_field_names).each do |line|
  line.chomp!
  row = line.dup.split("\t")
  mod_field = row[1].rstrip
  orig_field = row[2].rstrip
  field_hash[orig_field] = mod_field
#  puts mod_field + "\t" + orig_field
end

name_array = []

File.open(codes_names).each do |line|
  line.chomp!
  row = line.dup.split("\t")
  if row[1].rstrip.to_i < 1
    depth = row[1].dup.rstrip.to_i + 1
  else
    depth = (row[1].dup.rstrip.to_i - 4) / 2
  end
#  puts row.join("\t")
  orig_field = row[2].rstrip
  name_array[depth] = field_hash[orig_field]
  final_name = name_array[0..depth].join("_")
  const_field_names << row[0] + "\t" + final_name + "\t" + orig_field + "\n" if row[0].rstrip != "Universe"
  long_names << final_name + "\t" + "#{final_name.length}" + "\n" if final_name.length > 64
end

field_hash.clear