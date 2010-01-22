mod_field_names = 'mod_universe_with_counts_aligned.tsv'
cleaned_field_names = File.open("clean_field_names.tsv", "w")

File.open(mod_field_names).each do |line|
  line.chomp!
  row = line.dup.split("\t")
  row[1].delete!(':') if row[1].include?(':')
  row[1].delete!('/') if row[1].include?('/')
  puts row[1] if row[1].include?('/')
  cleaned_field_names << row.join("\t") + "\n"
end