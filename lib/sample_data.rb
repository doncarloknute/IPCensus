#!/usr/bin/env ruby

WORK_DIR = "/data/pkgd/demographics/census/ip_census/"

austin_zips = [
  73301, 73344, 78701, 78702, 78703, 78704, 78705, 78708, 78709, 78711,
  78712, 78713, 78714, 78715, 78716, 78717, 78718, 78719, 78720, 78721,
  78722, 78723, 78724, 78725, 78726, 78727, 78728, 78729, 78730, 78731,
  78732, 78733, 78734, 78735, 78736, 78737, 78738, 78739, 78741, 78742,
  78744, 78745, 78746, 78747, 78748, 78749, 78750, 78751, 78752, 78753,
  78754, 78755, 78756, 78757, 78758, 78759, 78760, 78761, 78762, 78763,
  78764, 78765, 78766, 78767, 78768, 78769, 78772, 78773, 78774, 78778,
  78779, 78780, 78781, 78783, 78785, 78788, 78789]
  
# outfile = File.open(WORK_DIR + "ip_blocks_zip_code_geo_sample.tsv", "w")
  
# Get the Austin zip lines from the IP blocks data.
#
# File.open(WORK_DIR + "ip_blocks_to_zip_code_geo_data.tsv").each do |line|
#   zip = line.split("\t")[4].to_i
#   next unless austin_zips.include?(zip)
#   puts line
#   # outfile << line
#   austin_zips.delete(zip)
# end

# outfile = File.open(WORK_DIR + "census_2000_sf3_us00001_sample.tsv", "w")

# Get the Austin zip lines from the first census data file

File.open(WORK_DIR + "census_2000_sf3_zip_us00001.tsv").each do |line|
  zip = line.split("\t")[0].to_i
  next unless austin_zips.include?(zip)
  puts line
  # outfile << line
  austin_zips.delete(zip)
end
  