require 'rubygems'
require 'fastercsv'

# /(\$\d+),(\d+)[^\d]/
# /(\$\d+),(\d+),(\d+)[^\d]/

#[ /$(\d+) to $(\d+)/,                        'D\1_\2']
#[ /percent of total income/,                 '']

class String
  def gsub_bs! regex, repl
    if repl.is_a?(String) then gsub!(regex, repl)
    else                       gsub!(regex, &repl) end
  end
end

raw_counts = 'raw_with_counts.tsv'

File.open(raw_counts).each do |line|
  line.chomp!
  orig_line = line.dup
  if line =~ /(\$\d+),(\d+)/
    [
      [/\$?(\d+)(?:,\d+)? to \$?(\d+)(?:,\d+) or loss/, 'Usd\1kto\2korL'], # eg $1 to $2,499 or loss
      [/\$?(\d+)(?:,\d+)? to \$?(\d+)(?:,\d+)/,         Proc.new{ "Usd#{$1}kto#{$2.to_i+1}k"}], # eg $10,000 to $12,499
      [/\$?(\d+)(?:,\d+)? or more/, 'Usd\1korM'], # eg $200,000 or more 
      [/Less than \$?(\d+)(?:,\d+)/, 'LtUsd\1k'], # eg Less than $10,000
    ].each do |regex, repl|
      line.gsub_bs!(regex, repl) and break
    end
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /(\d+):\d+ [ap].m. to (\d+):\d+ [ap].m./
    [
      [/(\d+):\d+ a.m. to (\d+):\d+ a.m./, "#{$1}AMto#{$2.to_i+1}AM"],
      [/(\d+):\d+ p.m. to (\d+):\d+ p.m./, "#{$1}PMto#{$2.to_i+1}PM"],
      [/(\d+):\d+ a.m. to (\d+):\d+ p.m./, "#{$1}AMto#{$2.to_i+1}PM"],
    ].each do |regex, repl|
      line.gsub!(regex, repl) and break
    end
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /[Hh]ouseholder\s?/
    line.gsub!(/[Hh]ouseholder\s?/, 'Hh')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /(\d\d) to (\d\d) years/
    line.gsub!(/(\d\d) to (\d\d) years/, '\1to\2y')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /(\d\d) to (\d\d) weeks/
    line.gsub!(/(\d\d) to (\d\d) weeks/, '\1to\2w')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /(\d\d) to (\d\d) minutes/
    line.gsub!(/(\d\d) to (\d\d) minutes/, '\1to\2min')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /(\d?\d) year(s?)/
    line.gsub!(/(\d?\d) year(s?)/, '\1y')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /(\sof\s|\sfor\s|\sa\s)/
    line.gsub!(/(\sof\s|\sfor\s|\sa\s)/, '')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /[Uu]nder\s|[Ll]ess than\s/
    line.gsub!(/[Uu]nder\s|[Ll]ess than\s/, 'Lt')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /[Mm]ore than\s/
    line.gsub!(/[Mm]ore than\s/, 'Gt')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /\spercent\s?/
    line.gsub!(/\spercent\s?/, 'pct')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /\sto\s/
    line.gsub!(/\sto\s/, 'to')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /[Ii]ncome\s?/
    line.gsub!(/[Ii]ncome\s?/, 'Inc')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /Aggregate\s/
    line.gsub!(/Aggregate\s/, 'Agg')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /Different\s/
    line.gsub!(/Different\s/, 'Diff')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /Enrolled\s/
    line.gsub!(/Enrolled\s/, 'Erld')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /Living\s/
    line.gsub!(/Living\s/, 'Lvng')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /Other\s/
    line.gsub!(/Other\s/, 'Oth')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /Speak\s/
    line.gsub!(/Speak\s/, 'Spk')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /[Tt]otal\s/
    line.gsub!(/[Tt]otal\s/, 'Tot')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /With\s/
    line.gsub!(/With\s/, 'Wth')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if line =~ /Worked\s/
    line.gsub!(/Worked\s/, 'Wrkd')
    if line == orig_line
      p [orig_line, line]
    end
  end
  if orig_line != line 
    puts orig_line + "\t" + line 
  else 
    puts orig_line
  end
end