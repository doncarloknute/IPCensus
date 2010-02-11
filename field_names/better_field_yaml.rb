#!/usr/bin/env ruby
require 'yaml'

# titles = 'package_titles.txt'
titles = 'titles_prices.tsv'
field_path = './field_lists/'
# temp_path = '/data/IPCensus/fields/'
# data_path = '/Users/doncarlo/data/IPCensus/'
data_path = '/data/IPCensus/'

title_hash = Hash.new

File.open(titles).each do |line|
  line.chomp!
  row = line.dup.split("\t")
  package_filename = row[0].rstrip
  package_price = row[2].rstrip.to_i
  dataset_title = row[3].rstrip
  warn 'Long title: #{dataset_title}' if dataset_title.length > 100
  package_title = dataset_title[41..-1]
  warn 'Long title: #{package_title}' if package_title.length > 100
  package_description = row[4].rstrip
  title_hash[package_filename] = [dataset_title, package_title, package_description, package_price]
  # p title_hash[package_filename] 
end


sources = [
  {'source'=>{'title'=>'United States Census 2000 Summary File 3',
    'main_link'=>"http://www2.census.gov/census_2000/datasets/Summary_File_3/",
    'description'=>'Summary File 3 contains population and housing data based on Census 2000 questions asked on the long form of a one-in-six sample of the population.

Population items include marital status, disability, educational attainment, occupation, income, ancestry, veteran status, and many other characteristics. Housing items include tenure (whether the unit is owner- or renter-occupied), occupancy status, housing value, mortgage status, price asked, and more.'}},
  {'source'=>{'title'=>'MaxMind GeoLite City',
    'main_link'=>"http://www.maxmind.com/app/geolitecity",
    'description'=>'Determine country, state/region, city, US postal code, US area code, metro code, latitude, and longitude information for IP addresses worldwide. 

This is the free version of the MaxMind GeoIP City database.'}}]
    
collection = [{'collection'=>{'title'=>'IP Address to US Census Data',
  'description'=>'A collection of datasets that link IP address geolocation data from MaxMind to the United States Census 2000 data.'}}]

base_yaml = [{'dataset'=>{
  'title'=>'',
  'subtitle'=>'IP Address to 2000 Census Data Summary File 3',
  'description'=>'United States IP address blocks are matched to their associated geographical data including zip code, city, state, area code, latitude, and longitude.  IP addresses are formatted as addresses as well as numbers using the following conversion:
  
IP address = w.x.y.z
IP num = 16777216*w + 65536*x + 256*y + z
      
These IP address blocks are then linked, via zip code, to a portion of the US Census 2000 data from Summary File 3.
----------------
This product includes GeoLite data created by MaxMind, available from http://maxmind.com',
  'collection'=>'IP Address to US Census Data',
  'tags'=>['census','demographics','population','zipcode','zip'],
  'categories'=>['Social Sciences::Demographics::Large Scale Censuses','Computers::Internet'],
  'sources'=>['United States Census 2000 Summary File 3', 'MaxMind GeoLite City', 'Monkeywrench Consultancy'],
  'payloads'=>[
    {
    'schema_fields'=>[{'handle'=>'IP_BeginNum','title'=>'Start of IP block in integer form'},
        {'handle'=>'IP_EndNum','title'=>'End of IP block in integer form'},
        {'handle'=>'IP_Begin','title'=>'Start of IP block in string form'},
        {'handle'=>'IP_End','title'=>'End of IP block in string form'},
        {'handle'=>'ZipCode','title'=>'Zip code'},
        {'handle'=>'ZipNum','title'=>'Zip code or nearest zip code'},
        {'handle'=>'Country','title'=>'Country'},
        {'handle'=>'State','title'=>'State'},
        {'handle'=>'City','title'=>'City'},
        {'handle'=>'Latitude','title'=>'Latitude'},
        {'handle'=>'Longitude','title'=>'Longitude'},
        {'handle'=>'MetroCode','title'=>'Metro code'},
        {'handle'=>'AreaCode','title'=>'Area code'}],
    'snippets'=>[{
      'columns'=>['IP_BeginNum','IP_EndNum','IP_Begin','IP_End','ZipCode','ZipNum','Country','State','City','Latitude','Longitude','MetroCode','AreaCode'],
      'data'=>[[50331648,67276831,"3.0.0.0","4.2.144.31","","","US","","",38.0000,-97.0000,"",""],
      [67276832,67276847,"4.2.144.32","4.2.144.47","02114","02114","US","MA","Boston",42.3616,-71.067506,617],
      [67276848,67277023,"4.2.144.48","4.2.144.223","","","US","","",38.0000,-97.000,"",""],
      [67277024,67277031,"4.2.144.224","4.2.144.231","22202","22202","US","VA","Arlington",38.8600,-77.0533,511,703],
      [67277032,67277039,"4.2.144.232","4.2.144.239","","","US","","",38.0000,-97.000,"",""],
      [67277040,67277047,"4.2.144.240","4.2.144.247","76092","76092","US","TX","Southlake",32.9516,-97.1515,623,817],
      [67277048,67277055,"4.2.144.248","4.2.144.255","45202","45202","US","OH","Cincinnati",39.1097,-84.5046,515,513],
      [67277056,67277215,"4.2.145.0","4.2.145.159","","","US","","",38.0000,-97.000,"",""],
      [67277216,67277247,"4.2.145.160","4.2.145.191","75038","75038","US","TX","Irving",32.8791,-96.989,623,972],
      [67277248,67277407,"4.2.145.192","4.2.146.95","","","US","","",38.0000,-97.000,"",""]
      ]
    }],
    'title'=>'',
    'price'=>'',
    'fmt'=>'tsv',
    'protected'=>'true',
    'records_count'=> 32038 + 1356836, # lines in each census data file + lines in the IP to zip code file
    'description'=>'',
    'license'=>'Open Database License (ODbL)',
    'owner'=>'MonkeywrenchConsultancy',
    'files_for_upload'=>[
      "README-infochimps",
      "fields_ancestry.tsv", 
      "fields_countries.tsv", 
      "fields_long_names.tsv", 
      "fields_occupations.tsv",
      "zip_codes_to_logical_record_number.tsv",
      "ip_blocks_to_zip_code_geo_data.tsv"]
  },
  # {
  #   'title'=>'',
  #   'description'=>'',
  #   'fmt'=>'tsv',
  #   'protected'=>'true',
  #   'records_count'=>1356836,
  #   'schema_fields'=>[{'handle'=>'IP_begin_num','title'=>''},
  #     {'handle'=>'IP_end_num','title'=>''},
  #     {'handle'=>'IP_begin','title'=>''},
  #     {'handle'=>'IP_end','title'=>''},
  #     {'handle'=>'zip_code','title'=>''},
  #     {'handle'=>'zip_num','title'=>''},
  #     {'handle'=>'country','title'=>''},
  #     {'handle'=>'state','title'=>''},
  #     {'handle'=>'city','title'=>''},
  #     {'handle'=>'latitude','title'=>''},
  #     {'handle'=>'longitude','title'=>''},
  #     {'handle'=>'metro_code','title'=>''},
  #     {'handle'=>'area_code','title'=>''}],
  #   'license'=>'Open Database License (ODbL)',
  #   'owner'=>'MonkeywrenchConsultancy',
  #   'file_for_upload'=>["ip_blocks_to_zip_code_geo_data.tsv"]
  # }
  ],
  'owner'=>'MonkeywrenchConsultancy'
  }
  }
  ]
  
puts sources.to_yaml
puts collection.to_yaml

yaml_file = File.open(data_path + "census_2000_sf3_zip_sources.yaml", "w")
yaml_file << sources.to_yaml
yaml_file << collection.to_yaml

Dir.foreach(field_path) do |filename|
  if filename =~ /census_2000_fields_us000\d\d\.tsv/
    current_yaml = []
    current_yaml = base_yaml.dup
    warn "Long title: #{title_hash['census_2000_sf3_zip_us000' + filename[24..25]][0].length}\t#{title_hash['census_2000_sf3_zip_us000' + filename[24..25]][0]}" if title_hash['census_2000_sf3_zip_us000' + filename[24..25]][0].length > 100
    current_yaml[0]['dataset']['title'] = title_hash['census_2000_sf3_zip_us000' + filename[24..25]][0]
    current_yaml[0]['dataset']['payloads'][0]['title'] = title_hash['census_2000_sf3_zip_us000' + filename[24..25]][1]
    current_yaml[0]['dataset']['payloads'][0]['description'] = title_hash['census_2000_sf3_zip_us000' + filename[24..25]][2]
    current_yaml[0]['dataset']['payloads'][0]['price'] = title_hash['census_2000_sf3_zip_us000' + filename[24..25]][3] * 100
    current_yaml[0]['dataset']['payloads'][0]['schema_fields'] = []
    File.open(field_path + "census_2000_fields_us000" + filename[24..25] + ".tsv").each do |line|
      line.chomp!
      row = line.dup.split("\t")
      if row[1].length > 255
        warn "Long title: #{row[1].length}\t#{row[1]}" 
        short_title = row[1].split(": ")[1..-1].join(": ")
        warn "New title: #{short_title.length}\t#{short_title}"
        current_yaml[0]['dataset']['payloads'][0]['schema_fields'] += [{'handle'=>row[0],'title'=>short_title,'description'=>row[1]}]
      else
        current_yaml[0]['dataset']['payloads'][0]['schema_fields'] += [{'handle'=>row[0],'title'=>row[1]}]
      end
    end
    current_yaml[0]['dataset']['payloads'][0]['files_for_upload'][7..-1] = nil
    current_yaml[0]['dataset']['payloads'][0]['files_for_upload'] += ["census_2000_sf3_zip_us000" + filename[24..25] + ".tsv"]
    yaml_file = File.open(data_path + "census_2000_sf3_zip_us000" + filename[24..25] + ".yaml", "w")
    yaml_file << current_yaml.to_yaml
  end
  # puts current_yaml.to_yaml
end