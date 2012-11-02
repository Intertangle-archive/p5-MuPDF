package MuPDF::Easy::Page;

use strict;
use warnings;
use Moo;
use Imager;

use MuPDF::SWIG;
use MuPDF::Easy::Transform;

has document => ( is => 'ro', required => 1, weak_ref => 1 );
has fz_context => ( is => 'ro', required => 1, weak_ref => 1 );
has fz_page => ( is => 'ro', required => 1 );

has bounds => ( is => 'lazy' );

sub _build_bounds {
	my ($self) = @_;
	MuPDF::SWIG::fz_bound_page($self->document->fz_document, $self->fz_page);
}

sub run_page {
	my ($self, $pixmap, $transform) = @_;
	my $device = MuPDF::SWIG::fz_new_draw_device($self->fz_context, $pixmap->fz_pixmap);
	MuPDF::SWIG::fz_run_page($self->document->fz_document, $self->fz_page, $device, $transform, undef);
	MuPDF::SWIG::fz_free_device($device);
}


sub DEMOLISH {
	my ($self, $global) = @_;
	MuPDF::SWIG::fz_free_page($self->document->fz_document, $self->fz_page);
}

1;
