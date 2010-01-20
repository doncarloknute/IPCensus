cat sas_files_ripd/SF3/*.sas |
  ruby -ne '
    $_.chomp! ;
    puts [$3].join("\t") if ($_ =~ %r{^         ([A-Z]+\d{6})=\W(\s*)(.+)'"'"'})' |
    wu-hist  | sort -t"   " -k2
    > field_names/raw_with_counts.tsv

	cat sas_files_ripd/SF3/*.sas |
	  ruby -ne '
	    $_.chomp! ;
	    puts [$1, $2.length, $3].join("\t") if ($_ =~ %r{^         ([A-Z]+\d{3}[A-Z]?\d{3})=\W(\s*)(.+)'"'"'})' |
	    wu-hist  | sort -t"   " -k2
	    > field_names/raw_with_counts.tsv
	
cat sas_files_ripd/SF3/*.sas | 
	ruby -ne '
		$_.chomp! ; 
		puts [$3].join("\t") if ($_ =~ %r{^         (\/\*)(Universe):\s+(.+)(\*\/)}) ; 
		puts [$3].join("\t") if ($_ =~ %r{^         ([A-Z]+\d{3}[A-Z]?\d{3})=\W(\s*)(.+)'"'"'})' 
		> field_names/raw_universe.tsv
		
cat sas_files_ripd/SF3/*.sas | 
	ruby -ne '
		$_.chomp! ; 
		puts [$2, -1, $3].join("\t") if ($_ =~ %r{^         (\/\*)(Universe):\s+(.+)(\*\/)}) ; 
		puts [$1, $2.length, $3].join("\t") if ($_ =~ %r{^         ([A-Z]+\d{3}[A-Z]?\d{3})=\W(\s*)(.+)'"'"'})' 
		> field_names/raw_with_field_code_universe.tsv

export LC_ALL='C'
cat sas_files_ripd/SF3/*.sas | 
	ruby -ne '
		$_.chomp! ; 
		puts [$3].join("\t") if ($_ =~ %r{^         (\/\*)(Universe):\s+(.+)(\*\/)}) ; 
		puts [$3].join("\t") if ($_ =~ %r{^         ([A-Z]+\d{3}[A-Z]?\d{3})=\W(\s*)(.+)'"'"'})' | 
		wu-hist | sort -t"    " -k2 
		> field_names/raw_universe_with_counts.tsv
