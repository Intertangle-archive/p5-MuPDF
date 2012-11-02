package MuPDF::Easy::Transform;

use strict;
use warnings;
use MuPDF::SWIG;

sub identity {
	#my ($self) = @_;
	$MuPDF::SWIG::fz_identity;
}

sub percentage_zoom {
	my ($self, $zoom) = @_;
	MuPDF::SWIG::fz_scale($zoom/100.0, $zoom/100.0);
}

sub rotate {
	my ($self, $angle) = @_;
	MuPDF::SWIG::fz_rotate($angle);
}

sub concat {
	my ($self, $a, $b) = @_;
	MuPDF::SWIG::fz_concat($a, $b);
}

1;
