#!/usr/bin/perl

# BatchParseAlpinoServer.pl

# takes a list of txt files as input 
# (assumes one sentence per line)

$alpino_server_location='jerom'; # alpino.dev.ivdnt.loc
$alpino_server_port=11222;

while (($txt)=shift(@ARGV)) {
  if ($txt=~/\*/) { die "Cannot expand * in argument list\n";}
  $txtdir=$txt;
  $txtdir=~s/\.txt$//;
  unless (mkdir $txtdir) {
    warn "Can't mkdir $txtdir";
  }
  open(TXT,$txt) || warn "Can't open $txt";
  print STDERR "Processing $txt\n";
  $sentnr=0;
  while (<TXT>) {
    chomp;
     s/([\,\.\!\?\(\)\:\;\'\"])/ $1 /g; # tokenizer
     s/\s+/ /g;
    $sentnr++;
    print STDERR "\tsentence nr $sentnr: $_\n";
    s/\"/\\\"/g;
    `echo "$_" | nc $alpino_server_location $alpino_server_port > $txtdir/$sentnr.xml`;
  }
  print STDERR "\n";
}
