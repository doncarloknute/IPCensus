mod_field_names = 'mod_universe_with_counts_aligned.tsv'
clean_field_names = File.open("clean_field_names.tsv", "w")

File.open(mod_field_names).each do |line|
  line.chomp!
  row = line.dup.split("\t")
  row[1].delete!(':') if row[1].include?(':')
  row[1].delete!('/') if row[1].include?('/')
  row[1].gsub!(/MSAPMSA/, 'PMSA')
  row[1].gsub!(/Remain/, 'Rem')
  row[1].gsub!(/Hous(e?)/, 'Hs')
  row[1].gsub!(/[Ww]th/, 'W')
  row[1].gsub!(/[Ww]ith/, 'W')
  row[1].gsub!(/Married/, 'Mrd')
  row[1].gsub!(/His(p?)Lat/, 'Hisp')
  row[1].gsub!(/America(s?)/, 'Amer')
  row[1].gsub!(/PovLev|PovStat/, 'Pov')
  row[1].gsub!(/Occ\D\D\D/, '')
  row[1].gsub!(/People/, 'Ppl')
  row[1].gsub!(/AfAmer/, 'AfAm')
  row[1].gsub!(/Male/, 'Mle')
  row[1].gsub!(/Aln/, '') if row[1].rstrip.length > 10
  row[1].gsub!(/S(o?)meOth/, 'Oth')
  row[1].gsub!(/19(\d\d)/, '\1')
  row[1].gsub!(/[Rr]ace(s?)/, 'Rce')
  row[1].gsub!(/Labor/, 'Labr')
  #puts row[1] if row[1].include?('Labr')
  clean_field_names << row.join("\t") + "\n"
end