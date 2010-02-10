#!/usr/bin/env ruby
LOG_WORK_DIR = File.dirname(__FILE__)+"/../log_ips"

def dotted_ip_to_packed_ip dotted_ip
  dotted_ip.
    split('.').map(&:to_i).   # break apart, convert to integers
    pack('C*').               # pack as strings
    unpack('N').first.to_i    # unpack as int
end

first = true
File.open(LOG_WORK_DIR+"/from_murtha-parsed.tsv", "w") do |outfile|
  File.open(LOG_WORK_DIR+"/from_murtha-raw.csv") do |f|
    f.each do |line_set|
      line_set.split(/[\r\n]+/).map do |line|
        if first then first = false ; next ; end # swallow first line
        dotted_ip, clicks, reg, city, zip = line.split(",", 5).map{|f| f == "NULL" ? nil : f}
        zip = "%05d"%zip.to_i unless zip.nil?
        packed_ip = dotted_ip_to_packed_ip dotted_ip
        packed_ip_12 = packed_ip >> 20
        outfile << [packed_ip, packed_ip_12, clicks, reg, city, zip].join("\t")+"\n"
      end
    end
  end
end

