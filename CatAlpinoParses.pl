# CatAlpinoParses.pl
#-------------------
# creates treebank path.xml

$version='0.4'; # sorts by filename instead of timestamp
#$version='0.3'; # checks whether input args are directories
#$version='0.2'; # can now run in batch

while ($path=shift(@ARGV)) {
    unless (-d $path) {
	next;
    }
    $output=$path.'.xml';
    print STDERR "Writing $path to $output\n";
    open(OUTPUT,">:utf8",$output);
    $declar=undef;
    @files=<$path/*.xml>;
#    @sorted=sort {[stat($a)]->[9] <=>[stat($b)]->[9]} @files; # sorts by oldest first
    @sorted=sort{ my ($anum,$bnum); 
                  ($anum)=$a=~/-(\d+)\.xml/; 
                  ($bnum)=$b=~/-(\d+)\.xml/; 
                  $anum <=> $bnum } @files;
    foreach $file (@sorted) {
	open(IN,"<:utf8",$file);
	while (<IN>) {
	    if (/<\?xml/) {
		unless ($declar) {
		    $declar=$_;
		    print OUTPUT $declar;
		    print OUTPUT "<treebank>\n";
		}
	    }
	    else {
		print OUTPUT $_;
	    }
	}
    }
    print OUTPUT "</treebank>\n";
    close OUTPUT;
}
    





