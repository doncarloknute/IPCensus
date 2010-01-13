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
  fixed_line = ''
  if line =~ /(\$\d+),(\d+)/
    #p line
    # line.gsub!(/\$(\d+),(\d+) to \$(\d+),(\d+)/, 'Usd\1kto\3k')
    orig_line = line.dup
    [
      [/\$?(\d+)(?:,\d+)? to \$?(\d+)(?:,\d+) or loss/, 'Usd\1kto\2korL'], # eg $1 to $2,499 or loss
      [/\$?(\d+)(?:,\d+)? to \$?(\d+)(?:,\d+)/,         Proc.new{ "Usd#{$1}kto#{$2.to_i+1}k"}], # eg $10,000 to $12,499
      [/\$?(\d+)(?:,\d+)? or more/, 'Usd\1korM'], # eg $200,000 or more 
      [/Less than \$?(\d+)(?:,\d+)/, 'LtUsd\1k'], # eg Less than $10,000
    ].each do |regex, repl|
      line.gsub_bs!(regex, repl) and break
    end
    if true || line == orig_line
      p [orig_line, line]
    end
    # puts line
  end
  if line =~ /[Hh]ouseholder\s?/
    fixed_line = line.gsub(/[Hh]ouseholder\s?/, 'Hh')
    if line == fixed_line
      p [line, fixed_line]
    end
    puts fixed_line
  end
  if line =~ /(\d\d) to (\d\d) years/
    if fixed_line == ''
      fixed_line = line.gsub(/(\d\d) to (\d\d) years/, '\1to\2y')
    else
      fixed_line.gsub!(/(\d\d) to (\d\d) years/, '\1to\2y')
    end
    if line == fixed_line
      p [line, fixed_line]
    end
    puts fixed_line
  end
end