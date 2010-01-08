#!/usr/bin/perl

# This script transforms the 2000 U.S. Census geography (usgeo),
# national data files (Summary File 1 and Summary File 3), and
# Congressional District extract into Notation 3 RDF.
#
# Copyright (C) 2006 Joshua Tauberer.  Released under the
# Creative Commons Attribution-NonCommercial-ShareAlike 2.5 License.
#
# There are three ways to run this script.  The first generates
# roughly 500,000 triples of basic population, latitute/longitude,
# and land area statistics for the U.S. as a whole, each state,
# county, sub-county, and 'census data place'.  You will need
# to have the following file in the same directory as this
# script (see below for where to get it):
#
#   usgeo_uf1.txt                   (191MB)
#
# The second method generates roughly 1 billion triples of
# detailed Census statistics for all of those regions.
# To do that, you must get:
#
#   usgeo_uf3.txt                  (187MB)
#   table_layouts/*                (3MB)
#
# And you will need any of the much larger Summary Files:
# (The script will process whatever files it finds.)
#   SF1_all_0Final_National.zip    (1GB)
#   SF3_all_0_National-part1.zip   (2GB)
#   SF3_all_0_National-part2.zip   (816MB)
#
# The third method generates similar RDF data as for the national
# summary files, but instead for congressional districts. It creates
# around 5 million triples. For that, you'll need any of the files
# below --- plus the table_layouts/* files (read on) ---.
#   sl500-in-sl010-us_h09.zip      (31MB)   (109th Congress districts, 100% data)
#   sl500-in-sl010-us_s09.zip      (82MB)   (109th Congress districts, sample data)
#   sl500-in-sl010-us_h10.zip      (31MB)   (110th Congress districts, 100% data)
#   sl500-in-sl010-us_s10.zip      (82MB)   (110th Congress districts, sample data)
#
# When processing the Summary Files, many per-race tables are left
# out in order to keep the size of the resulting data managable.
#
# You will need to have the Perl module Unicode::MapUTF8 installed.
#
# The files referenced above come from the Census website:
#   ftp://ftp2.census.gov/census_2000/datasets/
#
# Get the usgeo_uf1.txt file from:
#   ftp://ftp2.census.gov/census_2000/datasets/Summary_File_1/0Final_National/usgeo_uf1.zip
#
# And if you want to process the Summary Files, then also get:
#   ftp://ftp2.census.gov/census_2000/datasets/Summary_File_1/0Final_National/all_0Final_National.zip
#   ftp://ftp2.census.gov/census_2000/datasets/Summary_File_3/0_National/usgeo_uf3.zip
#   ftp://ftp2.census.gov/census_2000/datasets/Summary_File_3/0_National/all_0_National-part1.zip
#   ftp://ftp2.census.gov/census_2000/datasets/Summary_File_3/0_National/all_0_National-part2.zip
# But rename the three big files by putting "SF1_" or "SF3_" in front of them
# as appropriate.
#
# And if you want to generate triples for congressional districts:
#   ftp://ftp2.census.gov/census_2000/datasets/Summary_File_Extracts/109_Congressional_Districts/109_CD_HundredPercent/United_States/sl500-in-sl010-us_h09.zip
#   ftp://ftp2.census.gov/census_2000/datasets/Summary_File_Extracts/109_Congressional_Districts/109_CD_Sample/United_States/sl500-in-sl010-us_s09.zip
#   and/or
#   ftp://ftp2.census.gov/census_2000/datasets/Summary_File_Extracts/110_Congressional_Districts/110_CD_HundredPercent/United_States/sl500-in-sl010-us_h10.zip
#   ftp://ftp2.census.gov/census_2000/datasets/Summary_File_Extracts/110_Congressional_Districts/110_CD_Sample/United_States/sl500-in-sl010-us_s10.zip
#
# You will also need the SAS layout files for processing the Summary Files
# and the congressional district files.  Grab SF1SAS.zip and SF3SAS.zip
# from:
#   http://www.census.gov/support/2000/SF1/SF1SAS.zip
#   http://www.census.gov/support/2000/SF3/SF3SAS.zip
# And then create the following directory structure:
#   ./table_layouts/sf1/ (extract files from SF1SAS.zip here)
#   ./table_layouts/sf3/ (extract files from SF3SAS.zip here)
# Then you must patch the files with the patch provided with this
# script: census_table_layouts.patch.  This corrects some format
# errors in the files and adjusts some things to make them more
# easily processed by this script.  Run:
#   patch -p0 < census_table_layouts.patch
#
# You can now run this script with Perl.  To process just the
# geographic data, which takes a few minutes, run:
#   perl census.pl GEO
# That will create four .n3 files in a new 'rdf' subdirectory (~20MB)
# called states.n3 (U.S. and states), counties.n3, towns.n3
# (i.e. "county-sub" records) and villages.n3 ("census data places").
#
# To process the Summary File data, which takes a lot longer, run:
#   perl census.pl SUMFILES
# Various RDF files will be piped through gzip and saved into a
# 'rdf' subdirectory.
# The output files total around 1 GB and have in the neighborhood
# of 500 million RDF triples.  But since the data is written out
# to many files, you can pick and choose what level of detail
# (U.S. & states: 680k triples, counties: 41M triples, towns:
# 465M triples, villages: XXXX triples) or what set of data tables
# you want to process further.
# You'll see some error messages from gzip along the way
# about not finding files, but that's OK -- that's because SF3 is
# split between part1 and part2 files and the script doesn't know how.
#
# To process the congressional district files, run:
#   perl census.pl DISTRICTS
# You'll get congressional_districts_XXX.n3, which has basic geographic
# data and metadata about each district, akin to the "GEO" output above,
# and congressional_districts_XXX.sf[13].n3.gz files which have the
# complete Summary File 1 and 3 records for each district (akin to the
# "SUMFILES" output above).  The data totals about 25MB and 5 million
# triples (per session of Congress).
#
# To get some schema information about the predicates used in the
# detailed (SUMFILES, DISTRICTS) data files, run:
#   perl census.pl SCHEMA
# which will output schema.n3 in the rdf directory.
# -------------------------------------------------------------------

use Unicode::MapUTF8 qw(to_utf8 from_utf8 utf8_supported_charset);

if ($ARGV[0] eq 'GEO') {
	ProcessGeoTables("usgeo_uf1.txt", 'usgeo');

} elsif ($ARGV[0] eq 'SUMFILES' || $ARGV[0] eq 'TEST') {
	# Second argument can be FINISH to skip tables already
	# processed -- skipping files that already exist.
	my $testing = ($ARGV[0] eq 'TEST');
	ProcessSummaryFile('SF1_all_0Final_National', 1, $testing, $ARGV[1] eq 'FINISH');
	ProcessSummaryFile('SF3_all_0_National-part1', 3, $testing, $ARGV[1] eq 'FINISH');
	ProcessSummaryFile('SF3_all_0_National-part2', 3, $testing, $ARGV[1] eq 'FINISH');

} elsif ($ARGV[0] eq 'DISTRICTS') {
	ProcessRedistrictingFile('sl500-in-sl010-us_h09', 109, 1);
	ProcessRedistrictingFile('sl500-in-sl010-us_s09', 109, 3);
	ProcessRedistrictingFile('sl500-in-sl010-us_h10', 110, 1);
	ProcessRedistrictingFile('sl500-in-sl010-us_s10', 110, 3);

} elsif ($ARGV[0] eq 'SCHEMA') {
	GenerateSchema();

# These are for testing...
} elsif ($ARGV[0] eq 'TESTSUMFILE') {
	if ($ARGV[1] eq '') { die "Usage: perl census.pl TESTSUMFILE SF___.zip table_layouts/sf#/__.SAS"; }
	$ARGV[1] =~ s/\.zip$//i;
	$ARGV[1] =~ /^SF(\d)/; my $n = $1;
	ProcessSumFileTable($ARGV[1], $n, $ARGV[2]);
} elsif ($ARGV[0] eq 'TESTLAYOUT') {
	# usage: perl census.pl TESTLAYOUT table_layouts/sf#/___.sas
	print ParseSumFileLayout($ARGV[1]);

} else {
	print "You must specify a command.  Read the script for details\n.";
}

sub ProcessSummaryFile {
	my ($file, $n, $testing, $skipexisting) = @_;

	if (!-e "$file.zip") { return; }

	if (!$testing) {
		ProcessGeoTables("usgeo_uf$n.txt", $file =~ /^SF1/ ? 'geo' : undef);
	}

	my $tabledir = "table_layouts/sf$n";
	opendir DIR, $tabledir;
	foreach my $table (readdir(DIR)) {
		ProcessSumFileTable($file, $n, "$tabledir/$table", undef, undef, undef, $skipexisting);
	}
	closedir DIR;
}

sub ProcessGeoTables {
	my ($filename, $outputfile, $congress) = @_;

	undef %LOGRECNOURI;
	undef %LOGRECNOTYPE;

	# see: http://www.census.gov/support/SF1ASCII.html
	my %CENSUSSTATES = (1 => AL, 2 => AK, 4 => AZ, 5 => AR, 6 => CA, 8 => CO,
	9 => CT, 10 => DE, 11 => DC, 12 => FL, 13 => GA, 15 => HI, 16 => ID, 17
	=> IL, 18 => IN, 19 => IA, 20 => KS, 21 => KY, 22 => LA, 23 => ME, 24 =>
	MD, 25 => MA, 26 => MI, 27 => MN, 28 => MS, 29 => MO, 30 => MT, 31 =>
	NE, 32 => NV, 33 => NH, 34 => NJ, 35 => NM, 36 => NY, 37 => NC, 38 =>
	ND, 39 => OH, 40 => OK, 41 => OR, 42 => PA, 44 => RI, 45 => SC, 46 =>
	SD, 47 => TN, 48 => TX, 49 => UT, 50 => VT, 51 => VA, 53 => WA, 54 =>
	WV, 55 => WI, 56 => WY, 60 => AS, 66 => GU, 69 => MP, 72 => PR, 78 => VI); 

	my %NONSTATES = (DC => 1, AS => 1, GU => 1, MP => 1, PR => 1, VI => 1);

	my @FIELDS = split(/,/, "FILEID:6,STUSAB:2,SUMLEV:3,GEOCOMP:2,CHARITER:3,CIFSN:2,LOGRECNO:7,REGION:1,DIVISION:1,STATECE:2,STATE:2,COUNTY:3,COUNTYSC:2,COUSUB:5,COUSUBCC:2,COUSUBSC:2,PLACE:5,PLACECC:2,PLACEDC:1,PLACESC:2,TRACT:6,BLKGRP:1,BLOCK:4,IUC:2,CONCIT:5,CONCITCC:2,CONCITSC:2,AIANHH:4,AIANHHFP:5,AIANHHCC:2,AIHHTLI:1,AITSCE:3,AITS:5,AITSCC:2,ANRC:5,ANRCCC:2,MSACMSA:4,MASC:2,CMSA:2,MACCI:1,PMSA:4,NECMA:4,NECMACCI:1,NECMASC:2,EXI:1,UA:5,UASC:2,UATYPE:1,UR:1,CD106:2,CD108:2,CD109:2,CD110:2,SLDU:3,SLDL:3,VTD:6,VTDI:1,ZCTA3:3,ZCTA5:5,SUBMCD:5,SUBMCDCC:2,AREALAND:14,AREAWATR:14,NAME:90,FUNCSTAT:1,GCUNI:1,POP100:9,HU100:9,INTPLAT:9,INTPLON:10,LSADC:2,PARTFLAG:1,SDELEM:5,SDSEC:5,SDUNI:5,TAZ:6,UGA:5,PUMA5:5,PUMA1:5,RESERVE2:15,MACC:5,UACP:5,RESERVED:7");
	my %FIELDSIZE;
	foreach my $f (@FIELDS) {
		$f =~ /(\w+):(\d+)/;
		$f = $1;
		$FIELDSIZE{$f} = $2;
	}

	my %URI; # tracks the last state seen, the last county seen, etc.
	my %POP; # track the last population seen at each level
	my %FILES;

	if (defined($outputfile)) {
		my $outputfileroot = "rdf";
		mkdir $outputfileroot;

		my $append = '';

		if ($outputfile eq 'usgeo') {
			%FILES = (STATE => 'states', COUNTY => 'counties',
				COUNTYSUB => 'towns', COUNTYSUBPLACE => 'villages',
				ZCTA => 'zctas');
		} else {
			%FILES = (DISTS => $outputfile);
			$append = '>';
		}

		foreach my $file (keys(%FILES)) {
			open $file, ">$append$outputfileroot/geo-$FILES{$file}.n3";
			print $file <<EOF;
\@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
\@prefix dc: <http://purl.org/dc/elements/1.1/> .
\@prefix dcterms: <http://purl.org/dc/terms/> .
\@prefix geo: <http://www.w3.org/2003/01/geo/wgs84_pos#> .
\@prefix census: <http://www.rdfabout.com/rdf/schema/census/> .
\@prefix usgovt: <http://www.rdfabout.com/rdf/schema/usgovt/> .
EOF
			}
	}

	#open CENSUS, "unzip -p SF1__all_0Final_National.zip usgeo_uf1.zip | gunzip |";
	open(CENSUS, "<$filename") or die "$filename: $@";
	while (!eof(CENSUS)) {
		$line = <CENSUS>; chop $line;
		my $start = 0;
		my %info;
		foreach my $f (@FIELDS) {
			my $val = substr($line, $start, $FIELDSIZE{$f});
			$start += $FIELDSIZE{$f};
			$info{$f} = $val;
		}
	
		if ($info{GEOCOMP} ne "00") { next; }
		if ($info{NAME} =~ / \(part\)/) { next; }
		if ($info{CHARITER} ne "000") { die "chariter $info{CHARITER}"; }
	
		my $file;
		my $isa;
		my $uri;
		my $parent;

		for my $key (NAME, AREALAND, AREAWATR) {
			$info{$key} =~ s/^\s+//;
			$info{$key} =~ s/\s+$//;
		}

		$info{NAME} = NicePlaceName($info{NAME});
		
		if ($info{SUMLEV} eq "010") {
			$file  = "US";
			$uri = "http://www.rdfabout.com/rdf/usgov/geo/us";
			$isa = "<http://www.rdfabout.com/rdf/schema/politico/Country>";

		} elsif ($info{SUMLEV} eq "860") {
			$file  = "ZCTA";
			$uri = "http://www.rdfabout.com/rdf/usgov/geo/census/zcta/" . $info{ZCTA5};
			$isa = "census:ZCTA";
			$info{NAME} = "ZCTA " . $info{ZCTA5};
			
			$info{ZCTA5} =~ /^(\d\d)/;
			$parent = "http://www.rdfabout.com/rdf/usgov/geo/census/zcta-group/$1";

		} elsif ($info{SUMLEV} eq "040") {
			$file  = "STATE";
			$parent = $URI{US};
			$uri = "$URI{US}/" . lc($CENSUSSTATES{0+$info{STATE}});
			$isa = "usgovt:State";
			if ($NONSTATES{$CENSUSSTATES{0+$info{STATE}}}) { $isa = "usgovt:Territory"; }
			print lc($CENSUSSTATES{0+$info{STATE}}) . "...\n";
		} elsif ($info{SUMLEV} eq "050") {
			$file  = "COUNTY";
			$parent = $URI{STATE};
			$uri = "$URI{STATE}/counties/" . MakePlaceURI($info{NAME});
			$isa = "usgovt:County";
		} elsif ($info{SUMLEV} eq "060") {
			$file  = "COUNTYSUB";
			$parent = $URI{COUNTY};
			$uri = "$URI{COUNTY}/" . MakePlaceURI($info{NAME});
			$isa = "usgovt:Town";
		} elsif ($info{SUMLEV} eq "070") {
			$file  = "COUNTYSUBPLACE";
			if ($info{NAME} =~ /Remainder of/) { next; }
			$parent = $URI{COUNTYSUB};
			$uri = "$URI{COUNTYSUB}/" . MakePlaceURI($info{NAME});
			$isa = "usgovt:Village";

			# This region is the same as its parent region? No need to
			# duplicate an entity, but we do want to record the FIPS CDP code
			# on the COUNTYSUB entity.
			if ($POP{COUNTYSUB} == $info{POP100}) {
				print $file "<$parent> usgovt:fipsStateCDPCode \"$info{STATE}:$info{PLACE}\" .\n";
				next;
			}

		} elsif ($info{SUMLEV} eq "500" && defined($congress)) { # congressional district
			$file = "DISTS";

			my $state = lc($CENSUSSTATES{0+$info{STATE}});
			if ($info{NAME} !~ /^(Congressional|Delegate|Resident Commissioner) District (\d+|\(at Large\))$/) { die $info{NAME}; }
			my $dist = $2;
			if ($dist eq "(at Large)") { next; } # it is just the parent entity; no need to duplicate

			$uri = "http://www.rdfabout.com/rdf/usgov/geo/us/$state/cd/$congress/$dist";
			$parent = "http://www.rdfabout.com/rdf/usgov/geo/us/$state";
			$isa = "usgovt:CongressionalDistrict";

		} else { next; }

		$URI{$file} = $uri;
		$POP{$file} = $info{POP100};
	
		$info{STATEUSPS} = $CENSUSSTATES{0+$info{STATE}};
	
		my $file2 = $file;
		if ($file eq "US") { $file = "STATE" } # Put the US node in the states file

		$LOGRECNOURI{$info{LOGRECNO}} = $uri;
		$LOGRECNOTYPE{$info{LOGRECNO}} = $file;
		
		$info{INTPLAT} /= 1000000;
		$info{INTPLON} /= 1000000;

		if (!defined($outputfile)) { next; }

		print $file "<$uri> \n";
		print $file "	rdf:type $isa ;\n";
		print $file "	usgovt:censusStateCode \"$info{STATECE}\" ;\n" if ($file2 eq "STATE");
		print $file "	usgovt:fipsStateCode \"$info{STATE}\" ;\n" if ($file2 eq "STATE");
		print $file "	usgovt:uspsStateCode \"$info{STATEUSPS}\" ;\n" if ($file2 eq "STATE");
		print $file "	usgovt:fipsCountyCode \"$info{COUNTY}\" ;\n" if ($file2 eq "COUNTY");
		print $file "	usgovt:fipsStateCountyCode \"$info{STATE}:$info{COUNTY}\" ;\n" if ($file2 eq "COUNTY");
		print $file "	usgovt:fipsStateCountySubCode \"$info{STATE}:$info{COUSUB}\" ;\n" if ($file2 eq "COUNTYSUB");
		print $file "	usgovt:fipsStateCDPCode \"$info{STATE}:$info{PLACE}\" ;\n" if ($file2 eq "COUNTYSUBPLACE");
		print $file "	dc:title \"$info{NAME}\" ;\n";
		print $file "	dcterms:isPartOf <$parent> ;\n" if ($file2 ne "US");
		print $file "	geo:lat $info{INTPLAT} ;\n";
		print $file "	geo:long $info{INTPLON} ;\n";
		print $file "	census:population $info{POP100} ;\n";
		print $file "	census:households $info{HU100} ;\n";
		print $file "	census:landArea \"$info{AREALAND} m^2\" ;\n";
		print $file "	census:waterArea \"$info{AREAWATR} m^2\" ;\n";
		print $file "	census:details <$uri/censustables> .\n";
		print $file "<$parent> dcterms:hasPart <$uri> .\n" if ($file2 ne "US");
		
		# Grouping ZCTAs.
		if ($info{SUMLEV} eq "860" && !$SeenZCTAGroup{$parent}) {
			$SeenZCTAGroup{$parent} = 1;
			print $file "<$parent> rdf:type census:ZCTAGroup .\n";
			print $file "<$parent> dcterms:isPartOf <http://www.rdfabout.com/rdf/usgov/geo/us> .\n";
			print $file "<http://www.rdfabout.com/rdf/usgov/geo/us> dcterms:hasPart <$parent> .\n";
		}
	}

	close CENSUS;

	if (defined($outputfile)) {
		foreach my $file (keys(%FILES)) {
			close $file;
		}
	}
}

sub NicePlaceName {
	my $name = shift;
	$name = to_utf8({ -string => $name, -charset => 'WinLatin1' });
	$name =~ s/ CCD$//g;
	$name =~ s/ CDP$//g;
	return $name;
}

sub MakePlaceURI {
	my $name = shift;
	$name = lc($name);
	$name =~ s/\.//g;
	$name =~ s/\W/_/g;
	return $name;
}

sub ProcessSumFileTable {
	my ($file, $sf, $layout, $isCD, $state, $segment, $skipexisting) = @_;

	if ($layout !~ /sf(\d)(\d\d)\.sas$/i) { return; }
	my $table = $2;
	
	my $template = ParseSumFileLayout($layout);
	if ($template eq "") { return; }

	if (!$isCD && $skipexisting && -e "rdf/sumfile-states-$sf-$table.n3.gz") {
		return;
	}

	print STDERR "Summary File $file Table $table\n";

	my $predtype;
	if ($sf == 1) { $predtype = "100pct"; }
	elsif ($sf == 3) { $predtype = "samp"; }
	else { die; }

	my $namespaces = <<EOF;
\@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
\@prefix dc: <http://purl.org/dc/elements/1.1/> .
\@prefix : <http://www.rdfabout.com/rdf/schema/uscensus/details/$predtype/> .
EOF

	my $firstline = 1;

	my $tablefile;
	if (!$isCD) {
		$tablefile = "us000" . $table . "_uf$sf.zip | gunzip";
	} else {
		$tablefile = "sl500-in-sl040-$state"
			 . sprintf("%05d", $table) . "." . $segment;
	}

	my $counter = 0;
	my $starttime = time;

	open (DATA, "unzip -p " . $file . ".zip $tablefile |") or die "$file.zip -> $tablefile: $@";
	while (!eof(DATA)) {
		if ($firstline) {
			# Only do this if we succefully are reading the file, because there are
			# tables we attempt in the SF3-part1 file that aren't in that zip file.
			if (defined(%LOGRECNOURI)) {
				if (!$isCD) {
					open STATE, "| gzip > rdf/sumfile-states-$sf-$table.n3.gz";
					open COUNTY, "| gzip > rdf/sumfile-counties-$sf-$table.n3.gz";
					open COUNTYSUB, "| gzip > rdf/sumfile-towns-$sf-$table.n3.gz";
					open COUNTYSUBPLACE, "| gzip > rdf/sumfile-villages-$sf-$table.n3.gz";
					open ZCTA, "| gzip > rdf/sumfile-zctas-$sf-$table.n3.gz";

					print STATE $namespaces;
					print COUNTY $namespaces;
					print COUNTYSUB $namespaces;
					print COUNTYSUBPLACE $namespaces;
					print ZCTA $namespaces;
				} else {
					print DISTS2 $namespaces;
				}
			} else {
				print $namespaces;
			}
			$firstline = 0;
		}

		my $line = <DATA>;
		chop $line;
		$line =~ s/\r//g;
		
		my @fields = split(/,/, $line);
		
		my $fileid = shift(@fields);
		my $state_usps = shift(@fields);
		my $chariter = shift(@fields);
		my $charseq = shift(@fields);
		my $logrecno = shift(@fields);
		
		my $uri = $LOGRECNOURI{$logrecno};
		
		if (!defined(%LOGRECNOURI)) { $uri = ":"; } # running standalone

		if (!defined($uri)) { next; }

		my $t = $template;
		$t =~ s/%(\d+)%/$fields[$1]/eg;

		if (!defined(%LOGRECNOURI)) {
			print "<> $t";
		} else {
			my $file = $LOGRECNOTYPE{$logrecno};
			if ($file eq "DISTS") { $file = "DISTS2"; }
			print $file "<$uri/censustables> $t";
		}
		
		if (!defined(%LOGRECNOURI)) { last; } # running standalone

		$counter++;
		if (($counter % 40000) == 0) { print "Scanned $counter records at " . int($counter / (time-$starttime)) . " records/sec\n"; }
	}

	if (defined(%LOGRECNOURI)) {
		if (!$isCD) {
			close STATE;
			close COUNTY;
			close COUNTYSUB;
			close COUNTYSUBPLACE;
			close ZCTA;
		}
	}
}

sub ParseSumFileLayout {
	# This sub reads a SAS table layout file and generates
	# a N3 template representing the table structure where
	# actual numbers can be filled in for each place later.

	my $file = shift;
	my $writeschema = shift;

	if ($file !~ /sf(\d)(\d\d)\.sas$/i) { die; }
	my $sf = $1;
	my $table = $2;

	my $title;
	my $universe;
	my $specialtotal;
	my $nextstartsgroup;
	my $isfirst;
	my $tabs = '';
	my @indents;
	my @hierarchy;

	my $ret = "";

	open LAYOUT, "<$file";
	while (!eof(LAYOUT)) {
		my $line = <LAYOUT>;
		chop $line;
		$line =~ s/\r$//;

		if ($line =~ /^#/) { next; }
		if ($line !~ /\S/) { next; }
		if ($line =~ /\/\*Process Summary File \d+ Data File Number \d+\*\//) { next; }
		if ($line =~ /^\s*(TITLE|DATA|INFILE)/) { next; }
		if ($line =~ /FILEID|STUSAB|CHARITER|CIFSN|LOGRECNO/) { next; }

		$line =~ s/<BR>\&nbsp;\&nbsp;/ /g;

		if ($line =~ /\/\*(.*\S)\s*\[(\d+)\]\*\//) {
			$title = $1;
			$title =~ s/"|\\//g;
			$isfirst = 1;
			$specialtotal = '';
			$nextstartgroup = '';
			next;
		}

		if ($line =~ /\/\*Universe: (.*)\*\//) {
			$universe = $1;
			$nextstartgroup = '';
			next;
		}

		if ($line =~ /\/\*((Average|Median|Percent) .*\S)\s*--\*\//) {
			$specialtotal = $1;
			$nextstartgroup = '';
			next;
		}

		if ($line =~ /\/\*  \s*(\S.*\S)\s*--\*\//) {
			$nextstartgroup = $1;
			next;
		}
		
		if ($line =~ /^\s+(LABEL\s+)?([A-Z0-9]+)='(.*)'[\s;]*$/) {
			if ($title eq "") { next; }
			if ($title =~ /IMPUTATION/) { next; }
			# if ($universe =~ /who is|who are|white|black|hispanic|asian|american indian|native hawaiian|some other race|two or more races/i) { next; } # skip race-by-race tables

			my ($id, $name) = ($2, $3);

			my $isgroup = 0;
			if ($name =~ s/:$//) { $isgroup = 1; }

			my $indent;
			$name =~ s/^(\s*)//;
			$indent = length($1);
			if ($nextstartgroup eq 'INGROUP') { $indent++; }

			while (scalar(@indents) > 0 && $indent <= $indents[scalar(@indents)-1] || ($isfirst && scalar(@indents) > 0)) {
				pop @indents;
				pop @hierarchy;
				$ret .= "$tabs] ;\n";
				$tabs =~ s/\t//;
			}

			my $predicate = MakePredicate($name);
			my $predicatename = $name;
			my $groupvalue = 'rdf:value';

			if ($nextstartgroup ne '' && $nextstartgroup ne 'INGROUP') {
				if ($name !~ /^Total/i) { die "Had a special group before a non-'total' line: $nextstartgroup / $name"; }
				$predicate = MakePredicate($nextstartgroup);
				$predicatename = $nextstartgroup;
				$nextstartgroup = 'INGROUP';
			}

			if (scalar(@indents) == 0) {
				if ($specialtotal ne '') {
					if ($name !~ /^Total/i) {
						$ret .= $tabs . MakePredicate($universe);
						$ret .= " [ dc:title \"$title\";\n";
						push @indents, 0;
						push @hierarchy, MakePredicate($universe);
					} else {
						$predicate = MakePredicate($universe);
						$predicatename = $universe;
						$indent--;
					}
				} else {
					if ($name !~ /^Total/i) {
						$groupvalue = $predicate;
						$isgroup = 1;
					}
					$predicate = MakePredicate($universe);
					$predicatename = $universe;
				}
			}
			if ($specialtotal ne '') {
				$groupvalue = MakePredicate($specialtotal);
				$isgroup = 1;

				if ($writeschema && SchemaOnce($groupvalue)) {
					print SCHEMA "$groupvalue a rdf:Property ; rdfs:label \"" . EscapeN3String($specialtotal) . "\" .\n";
				}
				if ($writeschema && SchemaOnce("$sf-$table|" . $groupvalue)) {
					print SCHEMA $groupvalue . " census:inTable \"$sf-$table\" .\n";
				}
				if ($writeschema && SchemaOnce($predicate . "|" . $groupvalue)) {
					print SCHEMA $predicate . " census:hasValue " . $groupvalue . " .\n";
				}
			}

			if ($writeschema && SchemaOnce($predicate)) {
				print SCHEMA "$predicate a rdf:Property ; census:colid \"$id\" ; rdfs:label \"" . EscapeN3String($predicatename) . "\" .\n";
				if (scalar(@indents) == 0) {
					print SCHEMA "$predicate a census:Universe .\n";
				}
			}
			if ($writeschema && SchemaOnce("$sf-$table|" . $predicate)) {
				print SCHEMA $predicate . " census:inTable \"$sf-$table\" .\n";
			}
			if ($writeschema && scalar(@hierarchy) > 0 && SchemaOnce($hierarchy[scalar(@hierarchy)-1] . "|" . $predicate)) {
				print SCHEMA $hierarchy[scalar(@hierarchy)-1] . " census:hasSlice " . $predicate . " .\n";
			}

			$ret .= "$tabs$predicate ";
			
			if ($isgroup) {
				$tabs .= "\t";
				if ($isfirst) {
					$ret .= "[ dc:title \"$title ($id)\";\n";
					$ret .= $tabs . "$groupvalue ";
				} else {
					$ret .= "[ $groupvalue ";
				}
				push @indents, $indent;
				push @hierarchy, $predicate;
			}

			$ret .= "%%$id%% ; \t# $id\n";

			$isfirst = 0;

			next;
		}

		if ($line =~ /INPUT/) {
			my $ctr = 0;
			while (!eof(LAYOUT)) {
				my $line = <LAYOUT>;
				chop $line;

				my $islast = ($line =~ s/;//);
				$line =~ s/\s//g;
				if ($line =~ /\$/ || $line eq '') { next; }
				$ret =~ s/%%$line%%/%$ctr%/;
				$ctr++;
				if ($islast) { last; }
			}

			if ($ret =~ /%%(.*?)%%/) {
				die "Field $1 not found in input list.";
			}

			last;
		}

		die "Invalid line in SAS layout in file $file: " . $line;
	}
	close LAYOUT;
	
	while (scalar(@indents) > 0) {
		pop @indents;
		$ret .= "$tabs] ;\n";
	}

	$ret =~ s/;(\s*\#.*)?\n$/.$1\n/;

	return $ret;
}

sub MakePredicate {
	my $predicate = shift;
	if ($predicate eq 'rdf:value') { return $predicate; }
	$predicate =~ s/ (\w)/uc($1)/ge;
	$predicate =~ s/^(\w)/lc($1)/ge;
	$predicate =~ s/-//g;
	$predicate =~ s/\$/D/g;
	$predicate =~ s/[^a-zA-Z0-9]/_/g;
	$predicate =~ s/_+$//g;
	if ($predicate =~ /^[^a-z]/) { $predicate = "_$predicate"; }
	$predicate = ":$predicate";
	return $predicate;
}

sub EscapeN3String {
	my $str = shift;
	$str =~ s/"/\\"/g;
	return $str;
}

sub SchemaOnce {
	my $key = shift;
	my $ret = !$SchemaSeen{$key};
	$SchemaSeen{$key} = 1;
	return $ret;
}

sub ProcessRedistrictingFile {
	my ($file, $congress, $n) = @_;

	if (!-e "$file.zip") { return; }

	my $geon3filename;
	if ($n == 1) {	
		$geon3filename = "congressional_districts_$congress";
		unlink "rdf/geo-$geon3filename.n3";
	}

	my $mainoutputfile = "rdf/congressional_districts_${congress}_sf$n.n3.gz";
	open DISTS2, "| gzip > $mainoutputfile";

	# get a list of the states in the file
	my $statelisting = `unzip -l $file.zip`;

	while ($statelisting =~ /(sl500-in-sl040-(..)_([hs]\d+))\.zip/g) {
		my $statefile = $1;
		my $statename = $2;
		my $segment = $3;

		print "$file $statename\n";

		# extract the state file from the main zip file
		system("unzip -q $file.zip $statefile.zip");

		# process the geo file
		my $geofile = "sl500-in-sl040-${statename}geo.$segment";
		system("unzip -q $statefile.zip $geofile");
		ProcessGeoTables($geofile, $geon3filename, $congress);
		unlink $geofile;
		
		if (!defined(%LOGRECNOURI)) {
			print "No districts in this state...\n";
		} else {
			# process the sumfile tables
			my $tabledir = "table_layouts/sf$n";
			opendir DIR, $tabledir;
			foreach my $table (readdir(DIR)) {
				ProcessSumFileTable($statefile, $n, "$tabledir/$table", 1, $statename, $segment);
			}
			closedir DIR;
		}

		# get rid of the state file that we extracted from the main zip file
		unlink "$statefile.zip";
	}

	close DISTS2;
}

sub GenerateSchema {
	mkdir "rdf";

	open SCHEMA, ">rdf/schema.n3";
	print SCHEMA <<EOF;
\@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
\@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
\@prefix dc: <http://purl.org/dc/elements/1.1/> .
\@prefix census: <http://www.rdfabout.com/rdf/schema/census/> .
EOF

	foreach my $sf (1,3) {
		my $predtype;
		if ($sf == 1) { $predtype = "100pct"; }
		elsif ($sf == 3) { $predtype = "samp"; }
		else { die; }

		print SCHEMA "\@prefix : <http://www.rdfabout.com/rdf/schema/uscensus/details/$predtype/> .\n";
	
		my $tabledir = "table_layouts/sf$sf";
		opendir DIR, $tabledir;
		foreach my $table (readdir(DIR)) {
			if ($table !~ /sf$sf(\d\d)\.sas$/i) { next; }
			my $template = ParseSumFileLayout("table_layouts/sf$sf/$table", 1);
			if ($template eq "") { next; }
		}
		closedir DIR;
	}
	close SCHEMA;
}
