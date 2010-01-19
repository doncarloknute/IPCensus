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
    if mod_field =~ /(\$\d+)(,\d{3})+/
     [
       [/\$(\d+)(,\d{3}) to \$(\d+)(,\d{3}) or loss/, 'Usd\1kto\3korL'], # eg $1 to $2,499 or loss
       [/\$(\d+)(,\d{3}) to \$(\d+)(,\d{3})/,      "Usd#{$1}kto#{$3.to_i+1}k"], # eg $10,000 to $12,999
       [/\$(\d+)(,\d{3}) or more/, 'Usd\1korM'], # eg $200,000 or more 
       [/Less than \$(\d+)(,\d{3})/, 'LtUsd\1k'], # eg Less than $10,000
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
     if mod_field =~ /(\sof\s|\sfor\s|\sa\s)/
       mod_field.gsub!(/(\sof\s|\sfor\s|\sa\s)/, '')
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
     if mod_field =~ /\sto\s/
       mod_field.gsub!(/\sto\s/, 'to')
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
     puts orig_field + "\t" + mod_field
  end
#  puts orig_field + "\t" + mod_field
end

field_hash.clear