use strict;
use warnings;
use Data::Dumper;
use Parse::Eyapp;

use MyParser;

open INFILE, '<', 'mem_init_asm.txt' or die "error open in:$!";
open OUTFILE, '>', 'mem_init.txt' or die "error open out:$!";

my $parser = MyParser->new;

foreach (<INFILE>) {
	chomp;
	$parser->YYData->{INPUT} = $_;
	$parser->YYParse;
}

$parser->solveLabels;

foreach my $cmd (@{$parser->YYData->{Cmd}}) {
	printBin($cmd);
	print OUTFILE "\n";
}

close OUTFILE;
close INFILE;

sub printBin {
	foreach my $bin (@{$_[0]}) {
		if (ref $bin) {
			printBin($bin);
		} else {
			defined $bin or $bin = 0;
			$bin >> 8 and die "bin > 0xFF: bin=$bin";
			print OUTFILE sprintf('%08b ', $bin);
		}
	}
}