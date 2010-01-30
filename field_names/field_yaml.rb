    titles = 'package_titles.txt'
    field_path = './field_lists/'

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
        puts "census_2000_sf3_zip_us000" + filename[24..25] + ".yaml"
      end
    end
      puts "dataset:\n"
      puts "  title: IP Address to 2000 Census Data Summary File 3\n"
      puts "  description: >-\n    United States IP address blocks are matched to their associated geographical data including zip code, city, state, area code, latitude, and longitude.  IP addresses are formatted as addresses as well as numbers using the following conversion\n\n    IP address = w.x.y.z\n    IP num = 16777216*w + 65536*x + 256*y + z\n\n    These IP address blocks are then linked, via zip code, to the US Census 2000 data from Summary File 3.\n"
      puts "  sources:\n"
      puts "    - title: United States Census 2000 Summary File 3\n"
      puts "      url: \"http://www2.census.gov/census_2000/datasets/Summary_File_3/\"\n"
      puts "    - title: MaxMind GeoLite City\n"
      puts "      url: \"http://www.maxmind.com/app/geolitecity\"\n"
      puts "    - title: Carl Knutson\n"
      puts "      url: \"http://infochimps.org\"\n"
      puts "  tables:\n"
      puts "    title: \"#{title_hash['census_2000_sf3_zip_us00001'][0]}\"\n"
      records_count = 0
      File.open(field_path + "census_2000_fields_us00001.tsv").each do |line|
        records_count += 1
      end
      puts "    records_count: #{records_count}"
      puts "    description: >-\n      #{title_hash['census_2000_sf3_zip_us00001'][1]}"
      puts "    fields:\n"
      puts "      - id:\n"
      puts "        handle: ZipCode\n"
      puts "        title: \"Zip Code\"\n"
      puts "      - id:\n"
      puts "        handle: LogRecNum\n"
      puts "        title: \"Logical Record Number\"\n"
      File.open(field_path + "census_2000_fields_us00001.tsv").each do |line|
        line.chomp!
        row = line.dup.split("\t")
        puts "      - id:\n"
        puts "        handle: #{row[0]}\n"
        puts "        title: \"#{row[1]}\"\n"
      end
      puts "license:\n"
      puts "  title: Open Database License (ODbL)"
      puts "  url: \"http://www.opendatacommons.org/licenses/odbl/\"\n"

#    end
