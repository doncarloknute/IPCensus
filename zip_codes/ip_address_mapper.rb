#!/usr/bin/env ruby
require 'rubygems'
require 'dm-core'
require 'dm-types'
require 'configliere'
require 'digest/md5'
Settings.use :config_file, :define
Settings.read 'ip_census.yaml'  # ~/.configliere/ip_census.yaml
Settings.define :db_uri,  :description => "Base URI for database -- eg mysql://USERNAME:PASSWORD@localhost:9999"
Settings.define :db_name, :description => "Database name to use"

geoip_path = '../geoip_ripd/'
ip_log_path = '../log_ips/'

DB_URI = Settings.db_uri + "/" + Settings.db_name
p DB_URI
DataMapper.setup(:default, DB_URI)

class IPLogEntry
  include DataMapper::Resource

  property :counts,     Integer
  # min > 0 forces unsigned in dbs that support it
  property :ip_address, Integer, :min => 0,     :key => true
  property :ua_hash,    String, :length => 32,  :key => true
  property :user_agent, String, :length => 300
  property :ip_address_8,  Integer, :min => 0,   :index => :ip_address_8
  property :ip_address_12, Integer, :min => 0,   :index => :ip_address_12
  before :save, :hash_user_agent!

  def hash_user_agent!
    self.ua_hash    = Digest::MD5.hexdigest(user_agent)
    self.user_agent = user_agent[0..299]
    self.ip_address_12 = ip_address >> 20
    self.ip_address_8  = ip_address >> 24
  end
end

class IPBlock
  include DataMapper::Resource

  property :start_ip,    Integer, :min => 0,         :key => true
  property :end_ip,      Integer, :min => 0,         :key => true
  property :location_id, Integer, :required => true #, :index => :location_id
  # has 1, :location, :through => :location_id
end

class Location
  include DataMapper::Resource

  property :id,           Integer, :key => true
  property :country_code, String
  property :region_code,  String
  property :city,         String
  property :postal_code,  String
  property :latitude,     Float
  property :longitude,    Float
  property :metro_code,   Integer
  property :area_code,    Integer

#  has n, :ipblocks, :through => :location_id
end

# IPLogEntry.auto_migrate!
# IPBlock.auto_migrate!
# Location.auto_migrate!

# --------------------------------------------------------------------------

def dotted_ip_to_packed_ip dotted_ip
  dotted_ip.
    split('.').map(&:to_i).   # break apart, convert to integers
    pack('C*').               # pack as strings
    unpack('N').first.to_i    # unpack as int
end

Dir[ip_log_path + 'all*.tsv'].each do |logfile|
  File.open(logfile).each do |line|
    line.chomp!
    unless line =~ /^(\s+\d+)\s(\d+\.\d+\.\d+\.\d+)\t(.*)/ then warn "Bad line: #{line}" ; next ; end
    counts, dotted_ip, user_agent = [$1, $2, $3]
    counts    = counts.to_i
    packed_ip = dotted_ip_to_packed_ip(dotted_ip)
    ip_row = IPLogEntry.create :counts => counts, :ip_address => packed_ip, :user_agent => user_agent
  end
end

#
# File.open(geoip_path + 'GeoLiteCity-Location.csv').each do |line|
#   line.chomp!
#   unless line =~ /^\d+.+/ then warn "Bad line: #{line}" ; next ; end
#   locid, ccode, rcode, city, pcode, lat, long, mcode, acode = line.split(",")
#   locid = locid.to_i
#   ccode.delete!('"') if ccode.is_a?(String)
#   rcode.delete!('"') if rcode.is_a?(String)
#   city.delete!('"') if city.is_a?(String)
#   pcode.delete!('"') if pcode.is_a?(String)
#   lat = lat.to_f
#   long = long.to_f
#   mcode = mcode.to_i if mcode != nil
#   acode = acode.to_i if acode != nil
#   locale = Location.create :location_id => locid, :country_code => ccode, :region_code => rcode, :city => city, :postal_code => pcode, :latitude => lat, :longitude => long, :metro_code => mcode, :area_code => acode
# end
#
#
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
