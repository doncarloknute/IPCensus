
mod_field_names = 'clean_field_names.tsv'
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

#yaml_file = "SF3" + ('%02d' % file_index) + '.icss.yaml'

name_array = []
long_index = 0

File.open(codes_names).each do |line|
  line.chomp!
  row = line.dup.split("\t")
  if row[1].rstrip.to_i < 1
    depth = row[1].dup.rstrip.to_i + 1
  else
    depth = (row[1].dup.rstrip.to_i - 4) / 2
  end
  orig_field = row[2].rstrip
  name_array[depth] = field_hash[orig_field]
  name_array[depth] = row[2].rstrip if (name_array[0] == 'PopGte5y' && name_array[depth] =~ /Anc\d{3}/)
  final_name = name_array[0..depth].join("_")
  if final_name.length > 64
    long_names << row[0] + "\t" + ('%s_%03d' % [final_name[0..60], long_index]) + "\t" + final_name + "\n"
    final_name = '%s_%03d' % [final_name[0..60], long_index]
    long_index += 1
  end
  const_field_names << row[0] + "\t" + final_name + "\t" + orig_field + "\n" if row[0].rstrip != "Universe"
end

field_hash.clear