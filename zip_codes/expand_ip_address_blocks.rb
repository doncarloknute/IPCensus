#!/usr/bin/env ruby
require 'rubygems'
require 'wukong'

module IpCensus
  class IpBlocksMapper < Wukong::Streamer::RecordStreamer

    def recordize line
      line.gsub(/\"/, '').split(",", 3)
    end



    def packed_ip_to_dotted_ip packed_ip
      [
        (packed_ip >> 24) & 0xFF,
        (packed_ip >> 16) & 0xFF,
        (packed_ip >>  8) & 0xFF,
        (packed_ip      ) & 0xFF,
      ].join(".")
    end

    # Use the regex to break line into fields
    # Emit each record as flat line
    def process start_ip, end_ip, location_id
      start_ip = start_ip.to_i
      end_ip   = end_ip.to_i
      start_ip_16 = start_ip >> 16
      end_ip_16   = end_ip   >> 16
      (start_ip_16 .. end_ip_16).each do |sub_block|
        sub_start_ip = [start_ip, (sub_block     << 16)     ].max
        sub_end_ip   = [end_ip,   ((sub_block+1) << 16) - 1 ].min
        yield [
          sub_start_ip,
          sub_end_ip,
          sub_block,
          location_id,
          packed_ip_to_dotted_ip(sub_start_ip),
          packed_ip_to_dotted_ip(sub_end_ip)
        ]
      end
    end

  end
end

Wukong::Script.new(IpCensus::IpBlocksMapper, nil).run




