#!/usr/bin/env ruby
require 'rubygems'
require 'dm-core'
require 'dm-types'
require 'configliere'
Settings.use :config_file, :define
Settings.read 'ip_census.yaml'  # ~/.configliere/ip_census.yaml
Settings.define :db_user, :description => "Username for mysql DB"
Settings.define :db_pass, :description => "Password for mysql DB"
Settings.define :db_host, :description => "Host for mysql DB"
Settings.define :db_port, :description => "Port for mysql DB"
Settings.define :db_name, :description => "Database name to use"

geoip_path = '../geoip_ripd/'
ip_log_path = '../log_ips/'

DB_URI = "mysql://#{Settings.db_user}:#{Settings.db_pass}@#{Settings.db_host}:#{Settings.db_port}/#{Settings.db_name}"
p DB_URI
DataMapper.setup(:default, DB_URI)

class IPLogEntry
  include DataMapper::Resource
  
  property :counts, Integer
  # min > 0 forces unsigned in dbs that support it
  property :ipaddress, Integer, :key => true, :min => 0  
  property :useragent, String, :length => 255, :key => true
  
end

class IPBlock
  include DataMapper::Resource
  
  property :start_ip,    Integer, :min => 0, :key => true,    :unique_index => :ip_range
  property :end_ip,      Integer, :min => 0,                  :unique_index => :ip_range
  property :location_id, Integer
end

IPLogEntry.auto_migrate!
IPBlock.auto_migrate!

# --------------------------------------------------------------------------

def dotted_ip_to_packed_ip dotted_ip
  dotted_ip.
    split('.').map(&:to_i).   # break apart, convert to integers
    pack('C*').               # pack as strings
    unpack('N').first.to_i    # unpack as int
end


File.open(ip_log_path + 'IP_20100124.tsv').each do |line|
  line.chomp!
  unless line =~ /^(\s+\d+)\s(\d+\.\d+\.\d+\.\d+)\t(.+)/ then warn "Bad line: #{line}" ; next ; end
  counts, dotted_ip, user_agent = [$1, $2, $3]
  counts = counts.to_i
  packed_ip = dotted_ip_to_packed_ip(dotted_ip)
  user_agent = user_agent[0..254]
  #p packed_ip
  ip_row = IPLogEntry.create :counts => counts, :ipaddress => packed_ip, :useragent => user_agent
end
# 
# File.open(geoip_path + 'GeoLiteCity-Blocks.csv').each do |line|
#   line.chomp!
#   unless line =~ /^\"(\d+)\"\,\"(\d+)\"\,\"(\d+)\"/ then warn "Bad line: #{line}" ; next ; end
#   startip, endip, locid = [$1, $2, $3]
#   startip = startip.to_i
#   endip = endip.to_i
#   locid = locid.to_i
#   ip_block = IPBlock.create :startipnum => startip, :endipnum => endip, :locid => locid
# end
# 
