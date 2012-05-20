#!/usr/bin/perl

my $url = $ARGV[0];
my $patt = $ARGV[1];
$patt =~ s/ /%20/g;

if(length($url)) {
  $url = $url . "/" if($url !~ /\/$/);
  $patt = "mp3\$" if !length($patt);
  print "Getting files from $url that match $patt\n";
  foreach my $line (split("\n", `curl "$url"`)) {
    if($line =~ /\<\s*a href\s*=\s*\"([^\"]+)\"\s*\>/i) {
      my $link = $1;
      $link =~ s/ /%20/g;
      if($link =~ /$patt/) {
        print "match: $link\n";
        if($link =~ /^\//) {
            if($url =~ /^(http\:\/\/[^\/]+\/)/) {
                my $baseurl = $1;
                `wget $baseurl$link`; 
            }
        } else {
            `wget "$url$link"`;
        }
      }
    }
  }
} else {
  print "Usage:\ngrepget http://url.tld [regex]\n";
}
