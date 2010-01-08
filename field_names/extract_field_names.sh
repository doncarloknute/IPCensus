cat sas_files_ripd/SF3/*.sas |
  ruby -ne '
    $_.chomp! ;
    puts [$3].join("\t") if ($_ =~ %r{^         ([A-Z]+\d{6})=\W(\s*)(.+)'"'"'})' |
    wu-hist  | sort -t"   " -k2
    > field_names/raw_with_counts.tsv
