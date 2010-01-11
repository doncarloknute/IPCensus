

# /(\$\d+),(\d+)[^\d]/
# /(\$\d+),(\d+),(\d+)[^\d]/

#[ /$(\d+) to $(\d+)/,                        'D\1_\2']
#[ /percent of total income/,                 '']


raw_counts = 'raw_with_counts.tsv'

IO.foreach(raw_counts) do |line|
  if line =~ /(\$\d+),(\d+)/
    line.chomp!.delete!(",")
    p line.gsub(/\$(\d+) to \$(\d+)/, 'D\1_\2')
    if line =~ /$(\d+) to $(\d+)/
      p line
    end
  end
end