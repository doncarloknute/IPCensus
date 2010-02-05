require 'yaml'

titles = 'package_titles.txt'
field_path = './field_lists/'
data_path = '/Users/doncarlo/data/IPCensus/'

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


sources = [
  {'source'=>{'title'=>'United States Census 2000 Summary File 3',
    'main_link'=>"http://www2.census.gov/census_2000/datasets/Summary_File_3/"}},
  {'source'=>{'title'=>'MaxMind GeoLite City',
    'main_link'=>"http://www.maxmind.com/app/geolitecity"}},
  {'source'=>{'title'=>'Carl Knutson',
    'main_link'=>'http://infochimps.org'}}]

base_yaml = {'dataset'=>{
  'title'=>'IP Address to 2000 Census Data Summary File 3',
  'description'=>'United States IP address blocks are matched to their associated geographical data including zip code, city, state, area code, latitude, and longitude.  IP addresses are formatted as addresses as well as numbers using the following conversion:
  
IP address = w.x.y.z
IP num = 16777216*w + 65536*x + 256*y + z
      
These IP address blocks are then linked, via zip code, to the US Census 2000 data from Summary File 3.',
  'tags'=>['census','demographics','population','zipcode','zip'],
  'categories'=>['Social Sciences::Demographics::Large Scale Censuses','Computers::Internet'],
  'sources'=>['United States Census 2000 Summary File 3', 'MaxMind GeoLite City', 'Carl Knutson'],
  'payloads'=>{
    'title'=>'',
    'fmt'=>'tsv',
    'protected'=>'true',
    'records_count'=>'',
    'description'=>'',
    'schema_fields'=>[],
    'license'=>'Open Database License (ODbL)'
  }
  }
  }
  
puts sources.to_yaml
  
current_yaml = base_yaml.dup

Dir.foreach(field_path) do |filename|
  if filename =~ /census_2000_fields_us000\d\d\.tsv/
    current_yaml['dataset']['payloads']['title'] = title_hash['census_2000_sf3_zip_us000' + filename[24..25]][0]
    current_yaml['dataset']['payloads']['description'] = title_hash['census_2000_sf3_zip_us00001'][1]
    current_yaml['dataset']['payloads']['schema_fields'] = []
    records_count = 0
    File.open(field_path + "census_2000_fields_us000" + filename[24..25] + ".tsv").each do |line|
      records_count += 1
      line.chomp!
      row = line.dup.split("\t")
      current_yaml['dataset']['payloads']['schema_fields'] += [{'handle'=>row[0],'title'=>row[1]}]
    end
    current_yaml['dataset']['payloads']['records_count'] = records_count
#    yaml_file = File.open(data_path + "census_2000_sf3_zip_us000" + filename[24..25] + ".yaml", "w")
#    yaml_file << sources.to_yaml
#    yaml_file << current_yaml.to_yaml
  end
end


puts current_yaml.to_yaml
