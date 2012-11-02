package MuPDF::Easy;

use strict;
use warnings;
use Moo;

use MuPDF::SWIG;
use MuPDF::Easy::Doc;

has fz_context => ( is => 'lazy' );

sub _build_fz_context {
	MuPDF::SWIG::fz_new_context(undef, undef, $MuPDF::SWIG::FZ_STORE_UNLIMITED);
}

sub get_document {
	my ($self,$filename) = @_;
	MuPDF::Easy::Doc->new(filename => $filename,
		fz_document => MuPDF::SWIG::fz_open_document($self->fz_context,
			$filename));
}

sub DEMOLISH {
	my ($self, $global) = @_;
	MuPDF::SWIG::fz_free_context($self->fz_context);
}

1;
