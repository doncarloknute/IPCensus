const_field_names = 'constructed_field_names.tsv'
sas_path = '../sas_files_ripd/SF3/'

field_hash = Hash.new
field_hash.default = ["TotPop_Tot", "Total population: Total"]

File.open(const_field_names).each do |line|
  line.chomp!
  row = line.dup.split("\t")
  field_code = row[0].rstrip
  mod_field = row[1].rstrip
  orig_field = row[2].rstrip
  field_hash[field_code] = [mod_field, orig_field] 
end

Dir.foreach(sas_path) do |filename|
  if filename =~ /SF3\d\d\.SAS/
    out_file = File.open("./field_lists/census_2000_fields_us000" + filename[3..4] + ".tsv", "w")
    out_file << "ZipCode\tZip Code\nLogRecNum\tLogical Record Number\n"
    File.open(sas_path + filename).each do |line|
      line.chomp!
      if line =~ /^\s{9}([A-Z]+\d{3}[A-Z]?\d{3})=/
        field_code = line[/[A-Z]+\d{3}[A-Z]?\d{3}/]
        puts line if !field_hash.key?(field_code)
        out_file << field_hash[field_code].join("\t") + "\n"
      end
    end
  end    
end

field_hash.clear