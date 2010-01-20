
raw_field_names = 'raw_universe_with_counts.tsv'
mod_names = File.open("mod_universe_with_counts.tsv", "w")
first_pass = 'mod_raw_with_counts_aligned.tsv'

field_hash = Hash.new

File.open(first_pass).each do |line|
  line.chomp!
  row = line.dup.split("\t")
  mod_field = row[1].rstrip
  orig_field = row[2].rstrip
  field_hash[orig_field] = mod_field
#  puts orig_field + "\t" + mod_field
end

File.open(raw_field_names).each do |line|
  line.chomp!
  row = line.dup.split("\t")
  orig_field = row[1].rstrip
  mod_field = orig_field.dup
  if field_hash.key?(orig_field)
    mod_field = field_hash[orig_field]
  else
    if mod_field =~ /\$(\d+)((,\d{3})+)?/
     [
       [/\$(\d+),\d{3} to \$(\d+),\d{3} or loss/, 'Usd\1kto\2korL'], # eg $1 to $2,499 or loss
       [/\$(\d+),\d{3} to \$(\d+),\d{3}/,      'Usd\1kto\2k'], # eg $10,000 to $12,999
       [/\$(\d+),\d{3} or more/, 'Usd\1korM'], # eg $200,000 or more
       [/\$(\d{3}) to \$(\d{3})/, 'Usd\1to\2'],  
       [/Less than \$(\d+),\d{3}/, 'LtUsd\1k'], # eg Less than $10,000
     ].each do |regex, repl|
       mod_field.gsub!(regex, repl) and break
     end
     if mod_field == orig_field
       p [orig_field, mod_field]
     end
    end
     if mod_field =~ /(\d+):\d+ [ap].m. to (\d+):\d+ [ap].m./
       [
         [/(\d+):\d+ a.m. to (\d+):\d+ a.m./, "#{$1}AMto#{$2.to_i+1}AM"],
         [/(\d+):\d+ p.m. to (\d+):\d+ p.m./, "#{$1}PMto#{$2.to_i+1}PM"],
         [/(\d+):\d+ a.m. to (\d+):\d+ p.m./, "#{$1}AMto#{$2.to_i+1}PM"],
       ].each do |regex, repl|
         mod_field.gsub!(regex, repl) and break
       end
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /[Hh]ouseholder\s?/
       mod_field.gsub!(/[Hh]ouseholder\s?/, 'Hh')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /[Hh]ousehold[s]\s?/
        mod_field.gsub!(/[Hh]ousehold[s]\s?/, 'HH')
        if mod_field == orig_field
          p [orig_field, mod_field]
        end
      end
     if mod_field =~ /(\d\d) to (\d\d) years/
       mod_field.gsub!(/(\d\d) to (\d\d) years/, '\1to\2y')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /(\d\d) to (\d\d) weeks/
       mod_field.gsub!(/(\d\d) to (\d\d) weeks/, '\1to\2w')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /(\d\d) to (\d\d) minutes/
       mod_field.gsub!(/(\d\d) to (\d\d) minutes/, '\1to\2min')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /(\d?\d) year(s?)/
       mod_field.gsub!(/(\d?\d) year(s?)/, '\1y')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /(\sof\s|\sfor\s|\sa\s|\,|\s?the\s)/
       mod_field.gsub!(/(\sof\s|\sfor\s|\sa\s|\,|\s?the\s)/, '')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /[Uu]nder\s|[Ll]ess than\s/
       mod_field.gsub!(/[Uu]nder\s|[Ll]ess than\s/, 'Lt')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /[Mm]ore than\s/
       mod_field.gsub!(/[Mm]ore than\s/, 'Gt')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /\spercent\s?/
       mod_field.gsub!(/\spercent\s?/, 'pct')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /[Ii]ncome\s?/
       mod_field.gsub!(/[Ii]ncome\s?/, 'Inc')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Aggregate\s/
       mod_field.gsub!(/Aggregate\s/, 'Agg')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /civilian noninstitutionalized\s/
       mod_field.gsub!(/civilian noninstitutionalized\s/, 'CivNInst')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /American Indian and Alaska Native\s/
       mod_field.gsub!(/American Indian and Alaska Native\s/, 'AmIndAkNat')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Black or African American\s/
       mod_field.gsub!(/Black or African American\s/, 'BlkAfAmer')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Native Hawaiian and Other Pacific Islander\s/
       mod_field.gsub!(/Native Hawaiian and Other Pacific Islander\s/, 'NatHiPacIsl')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Nonfamily\s/
       mod_field.gsub!(/Nonfamily\s/, 'NFam')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /disability|disabilities/
       mod_field.gsub!(/disability|disabilities/, 'Disab')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /March\s/
       mod_field.gsub!(/March\s/, 'Mar')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Hispanic or Latino\s/
       mod_field.gsub!(/Hispanic or Latino\s/, 'HispLat')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /[Ff]amily|[Ff]amilies\s/
       mod_field.gsub!(/[Ff]amily|[Ff]amilies\s/, 'Fam')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Moved in\s/
       mod_field.gsub!(/Moved in\s/, 'Mvd')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Occupied housing units\s/
       mod_field.gsub!(/Occupied housing units\s/, 'OcpHousUnt')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /[Pp]opulation\s/
       mod_field.gsub!(/[Pp]opulation\s/, 'Pop')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Related children\s/
       mod_field.gsub!(/Related children\s/, 'RelCld')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Specified renter-occupied housing units\s/
       mod_field.gsub!(/Specified renter-occupied housing units\s/, 'RentOcpHousUnt')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Specified owner-occupied housing units\s/
       mod_field.gsub!(/Specified owner-occupied housing units\s/, 'OwnOcpHousUnt')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Two or more\s/
       mod_field.gsub!(/Two or more\s/, 'Gte2')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /[Vv]alue\s/
       mod_field.gsub!(/[Vv]alue\s/, 'Val')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /White\s/
       mod_field.gsub!(/White\s/, 'Wht')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Asian\s/
       mod_field.gsub!(/Asian\s/, 'Asn')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /[Aa]lone\s?/
       mod_field.gsub!(/[Aa]lone\s?/, 'Aln')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /\soccupants per room\s?/
       mod_field.gsub!(/\soccupants per room\s?/, 'OcpPrRm')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Built\s/
       mod_field.gsub!(/Built\s/, 'Blt')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Different\s/
       mod_field.gsub!(/Different\s/, 'Diff')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Enrolled\s/
       mod_field.gsub!(/Enrolled\s/, 'Erld')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Living\s/
       mod_field.gsub!(/Living\s/, 'Lvng')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Other\s/
       mod_field.gsub!(/Other\s/, 'Oth')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Speak\s/
       mod_field.gsub!(/Speak\s/, 'Spk')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /[Tt]otal\s?/
       mod_field.gsub!(/[Tt]otal\s?/, 'Tot')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /With\s/
       mod_field.gsub!(/With\s/, 'Wth')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /Worked\s/
       mod_field.gsub!(/Worked\s/, 'Wrkd')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /\sto\s/
       mod_field.gsub!(/\sto\s/, 'to')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
     if mod_field =~ /\sor\s/
       mod_field.gsub!(/\sor\s/, 'or')
       if mod_field == orig_field
         p [orig_field, mod_field]
       end
     end
#     puts orig_field + "\t" + mod_field
  end
  puts row[0] + "\t" + mod_field + "\t" + orig_field
  mod_names << row[0] + "\t" + mod_field + "\t" + orig_field +"\n"
end

field_hash.clear