require 'rubygems'
require 'fastercsv'

# Main data path
#data_path = '/data/ripd/www2.census.gov/census_2000/datasets/Summary_File_3/0_National/'

# Test data path
data_path = '/data/temp/minidata/'

# Geo data file
geo_data = data_path + 'usgeo.uf3'

# CSV data file
out_csv = data_path + 'usgeo.csv'

# Read in geo data from geo file
geozip_hash = Hash.new()
IO.foreach(geo_data) do |entry|
  georow = []
  georow[0] = entry[0..5] #file identification
  georow[1] = entry[6..7] #State/U.S.-Abbreviation (USPS)
  georow[2] = entry[9..10] #summary level
  georow[3] = entry[11..12] #geographic component
  georow[4] = entry[13..15] #characteristic iteration
  georow[5] = entry[16..17] #characteristic iteration file sequence number
  georow[6] = entry[18..24]  #logical record number
  georow[7] = entry[25] #REGION
  georow[8] = entry[26] #DIVISION
  georow[9] = entry[27..28] #state (Census)
  georow[10] = entry[29..30]  #state (FIPS)
  georow[11] = entry[31..33]  #county
  georow[12] = entry[34..35] #county size code
  georow[13] = entry[36..40] #county subdivision (FIPS)
  georow[14] = entry[41..42] #FIPS county subdivision class code
  georow[15] = entry[43..44] #county subdivision size code
  georow[16] = entry[45..49] #place (FIPS)
  georow[17] = entry[50..51] #FIPS place class code
  georow[18] = entry[53..54] #place size code
  georow[19] = entry[55..60] #census tract
  georow[20] = entry[61] #block group
  georow[21] = entry[62..65] #block
  georow[22] = entry[66..67] #internal use code
  georow[23] = entry[68..72] #consolidated city (FIPS)
  georow[24] = entry[73..74] #FIPS consolidated city class code
  georow[25] = entry[75..76] #consolidated city size code
  georow[26] = entry[77..80] #AIANHH
  georow[27] = entry[81..85] #AIANHHFP
  georow[28] = entry[86..87] #AIANHHCC
  georow[29] = entry[88] #AIHHTLI
  georow[30] = entry[89..91] #AITSCE
  georow[31] = entry[92..96] #AITS
  georow[32] = entry[97..98] #AITSCC
  georow[33] = entry[99..103] #ANRC
  georow[34] = entry[104..105] #ANRCCC
  georow[35] = entry[106..109] #MSACMSA
  georow[36] = entry[110..111] #MASC
  georow[37] = entry[112..113] #CMSA
  georow[38] = entry[114] #MACCI
  georow[39] = entry[115..118] #PMSA
  georow[40] = entry[119..122] #NECMA
  georow[41] = entry[123] #NECMACCI
  georow[42] = entry[124..125] #NECMASC
  georow[43] = entry[126] #extended place indicator
  georow[44] = entry[127..131] #urban area
  georow[45] = entry[132..133] #urban area size code
  georow[46] = entry[134] #urban area type
  georow[47] = entry[135] #urban/rural
  georow[48] = entry[136..137] #congressional district (106th)
  georow[49] = entry[138..139] #congressional district (108th)
  georow[50] = entry[140..141] #congressional district (109th)
  georow[51] = entry[142..143]  #congressional district (110th)
  georow[52] = entry[144..146] #state legislative district (upper chamber)
  georow[53] = entry[147..149] #state legislative district (lower chamber)
  georow[54] = entry[150..155] #voting district
  georow[55] = entry[156] #voting district indicator
  georow[56] = entry[157..159] #ZCTA3
  georow[57] = entry[160..164]  #ZCTA5 (ZIP code tabulation area (5-digit))
  georow[58] = entry[165..169] #subbarrio (FIPS)
  georow[59] = entry[170..171] #FIPS subbarrio class code
  georow[60] = entry[172..185].to_i #land area
  georow[61] = entry[186..199].to_i #water area
  georow[62] = entry[200..289] #area name-legal/statistical area description term-part indicator
  georow[63] = entry[290] #functional status code
  georow[64] = entry[291] #geographic change user note indicator
  georow[65] = entry[292..300].to_i  #population
  georow[66] = entry[301..309].to_i #housing units
  georow[67] = entry[310..318].insert(3, '.')  #latitute
  georow[68] = entry[319..328].insert(4, '.')  #longitude
  georow[69] = entry[329..330] #legal/statistical area description code
  georow[70] = entry[331] #part flat
  georow[71] = entry[332..336] #school district (elementary)
  georow[72] = entry[337..341] #school district (secondary)
  georow[73] = entry[342..346] #school district (unified)
  georow[74] = entry[347..352] #traffic analysis zone
  georow[75] = entry[353..357] #Oregon urban growth area
  georow[76] = entry[358..362] #public use microdata area - 5% file
  georow[77] = entry[363..367] #public use microdata area - 1% file
  georow[78] = entry[368..382] #RESERVED
  georow[79] = entry[383..387] #metropolitan area central city
  georow[80] = entry[388..392] #urban area central place
  georow[81] = entry[393..399] #RESERVED
  FasterCSV.open(out_csv, "a") do |csv|
    csv << georow
  end
end