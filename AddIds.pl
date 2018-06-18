# AddIds.pl
#---------------
# takes an alpino treebank file as input and adds ids to the trees

$version='0.5'; # adds filename to identifier
#$version='0.4'; # shows progress
#$version='0.3'; # creates ids.xml files as output
#$version='0.2'; # works on sets of treebank files

use XML::Twig;

while ($in=shift(@ARGV)) {
    $out=$in;
    $out=~s/xml$/ids.xml/;
    $identifier=$in;
    $identifier=~s/\.alpinoxml.xml//;
    print STDERR "Processing $in > $out\n";
    open(OUT,">:utf8",$out);
    my $twig=XML::Twig->new(pretty_print=>'indented',
			    twig_handlers => { alpino_ds => \&alpino});
    $twig->parsefile($in);
    $twig->flush(\*OUT);
    close OUT;
}
print STDERR "\n";

sub alpino {
  my ($t,$tree)=@_;
  $treenr++;
  print STDERR "\tTree nr $treenr\r";
  # find sentence id
  my @comment=$tree->descendants(comment);
  my $comment_text=$comment[0]->text;
  my ($sentid)=$comment_text=~/Q#(.*?\d+)\|/;
  $full_sentid=$identifier.'.s.'.$sentid;
  $comment_text=~s/$sentid/$full_sentid/;
  $comment[0]->set_text($comment_text);
  $tree->set_att('id' => $full_sentid);
  my @desc=$tree->descendants(node);
  foreach (@desc) {
    $oldid=$_->att('id');
    $_->set_att('id' => $full_sentid.'.'.$oldid);
  }
  $tree->flush(\*OUT);
}
