package MuPDF::Easy::Doc;

use Moo;

use MuPDF::SWIG;
use MuPDF::Easy::Page;

has filename => ( is => 'ro' );
has fz_document => ( is => 'ro', required => 1 );
has page_count => ( is => 'lazy' );

sub _build_page_count {
	my $self = shift;
	MuPDF::SWIG::fz_count_pages($self->fz_document);
}

sub get_page {
	my ($self, $context, $page_number) = @_;
	my $page = MuPDF::SWIG::fz_load_page($self->fz_document, $page_number);
	MuPDF::Easy::Page->new(document => $self, fz_context => $context, fz_page => $page);
}

sub DEMOLISH {
	my ($self, $global) = @_;
	MuPDF::SWIG::fz_close_document($self->fz_document);
}

1;
