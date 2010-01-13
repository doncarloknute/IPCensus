require 'rubygems'
require 'fastercsv'

# /(\$\d+),(\d+)[^\d]/
# /(\$\d+),(\d+),(\d+)[^\d]/

#[ /$(\d+) to $(\d+)/,                        'D\1_\2']
#[ /percent of total income/,                 '']


raw_counts = 'raw_with_counts.tsv'

IO.foreach(raw_counts) do |line|
  fixed_line = ''
  if line =~ /(\$\d+),(\d+)/
    line.chomp!
    #p line
    # line.gsub!(/\$(\d+),(\d+) to \$(\d+),(\d+)/, 'Usd\1kto\3k')
    {
      /\$?(\d+)(?:,\d+)? to \$?(\d+)(?:,\d+) or loss/ => 'Usd\1kto\2korL', # eg $1 to $2,499 or loss
      /\$?(\d+)(?:,\d+)? to \$?(\d+)(?:,\d+)/ => 'Usd\1kto\2k', # eg10,000 to $12,499
      /\$?(\d+)(?:,\d+)? or more/ => 'Usd\1korM', # $200,000 or more 
      /Less than \$?(\d+)(?:,\d+)/ => 'LtUsd\1k'
    }.each do |regex, repl|
      fixed_line = line.gsub(regex, repl) and break
    end
    if true || line == fixed_line
      p [line, fixed_line]
    end
    puts fixed_line
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