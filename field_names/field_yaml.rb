    titles = 'package_titles.txt'
    field_path = './field_lists/'
    data_path = '/data/IPCensus/'

    title_hash = Hash.new

    File.open(titles).each do |line|
      line.chomp!
      row = line.dup.split("\t")
      package_filename = row[0].rstrip
      package_title = row[1].rstrip
      package_description = row[2].rstrip
      puts row[0] if row[2] == nil
      title_hash[package_filename] = [package_title, package_description] 
    end
    
    Dir.foreach(field_path) do |filename|
      if filename =~ /census_2000_fields_us000\d\d\.tsv/
        yaml_file = File.open(data_path + "census_2000_sf3_zip_us000" + filename[24..25] + ".yaml", "w")
        yaml_file << "dataset:\n"
        yaml_file << "  title: IP Address to 2000 Census Data Summary File 3\n"
        yaml_file << "  description: >-\n    United States IP address blocks are matched to their associated geographical data including zip code, city, state, area code, latitude, and longitude.  IP addresses are formatted as addresses as well as numbers using the following conversion\n\n    IP address = w.x.y.z\n    IP num = 16777216*w + 65536*x + 256*y + z\n\n    These IP address blocks are then linked, via zip code, to the US Census 2000 data from Summary File 3.\n"
        yaml_file << "  sources:\n"
        yaml_file << "    - title: United States Census 2000 Summary File 3\n"
        yaml_file << "      url: \"http://www2.census.gov/census_2000/datasets/Summary_File_3/\"\n"
        yaml_file << "    - title: MaxMind GeoLite City\n"
        yaml_file << "      url: \"http://www.maxmind.com/app/geolitecity\"\n"
        yaml_file << "    - title: Carl Knutson\n"
        yaml_file << "      url: \"http://infochimps.org\"\n"
        yaml_file << "  tables:\n"
        yaml_file << "    title: \"#{title_hash['census_2000_sf3_zip_us000' + filename[24..25]][0]}\"\n"
        records_count = 0
        File.open(field_path + "census_2000_fields_us000" + filename[24..25] + ".tsv").each do |line|
          records_count += 1
        end
        yaml_file << "    records_count: #{records_count}\n"
        yaml_file << "    description: >-\n      #{title_hash['census_2000_sf3_zip_us000' + filename[24..25]][1]}\n"
        yaml_file << "    fields:\n"
#        yaml_file << "      - id:\n"
#        yaml_file << "        handle: ZipCode\n"
#        yaml_file << "        title: \"Zip Code\"\n"
#        yaml_file << "      - id:\n"
#        yaml_file << "        handle: LogRecNum\n"
#        yaml_file << "        title: \"Logical Record Number\"\n"
        File.open(field_path + "census_2000_fields_us000" + filename[24..25] + ".tsv").each do |line|
          line.chomp!
          row = line.dup.split("\t")
          yaml_file << "      - id:\n"
          yaml_file << "        handle: #{row[0]}\n"
          yaml_file << "        title: \"#{row[1]}\"\n"
        end
        yaml_file << "license:\n"
        yaml_file << "  title: Open Database License (ODbL)\n"
        yaml_file << "  url: \"http://www.opendatacommons.org/licenses/odbl/\"\n"
      end
    end
    
    title_hash.clear
