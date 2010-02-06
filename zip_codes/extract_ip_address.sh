cd ~/ics/Infochimps/wukong/examples/
zcat /slices/infochimps.org/bkup/log/201001/infochimps.org-access.log-20100124.gz | ./apache_log_parser.rb --map | ruby -ne 'foo = $_.split("\t") ; puts [foo[4], foo[12]].join("\t")' | sort | uniq -c
