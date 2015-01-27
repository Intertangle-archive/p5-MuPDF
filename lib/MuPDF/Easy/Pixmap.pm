package MuPDF::Easy::Pixmap;

use 5.010;
use strict;
use warnings;
use Moo;
use Carp;

use Imager;
use MuPDF::SWIG;

has fz_context => ( is => 'ro', weak_ref => 1, required => 1 );
has bbox => ( is => 'ro', required => 1 );
has type => ( is => 'ro', required => 1);

has fz_pixmap => ( is => 'lazy' );
has byte_length => ( is => 'lazy' );
has height => ( is => 'lazy' );
has width => ( is => 'lazy' );
has components => ( is => 'lazy' );


sub _build_fz_pixmap {
	my ($self) = @_;
	my $colorspace;
	if( $self->type eq 'rgb' ) {
		$colorspace = $MuPDF::SWIG::fz_device_rgb;
	} else {
		# TODO turn Str into a type
		croak 'not a colorspace';
	}
	my $pixmap = MuPDF::SWIG::fz_new_pixmap_with_bbox(
		$self->fz_context,
		$colorspace,
		$self->bbox
	);
	MuPDF::SWIG::fz_clear_pixmap_with_value($self->fz_context, $pixmap, 0xff);
	return $pixmap;
}

sub write_png {
	my ($self, $out_filename) = @_;
	MuPDF::SWIG::fz_write_png($self->fz_context, $self->fz_pixmap, $out_filename, 0);
}

sub get_samples {
	my ($self) = @_;
	my $byte_ptr = MuPDF::SWIG::fz_pixmap_samples($self->fz_context, $self->fz_pixmap);
	my $length = $self->byte_length;
	my $bytes = MuPDF::SWIG::cdata($byte_ptr, $length);
	# TODO : use colorspace
	$bytes = pack('C*', unpack( '(C[3]x[C])*', $bytes)); # drop every 4th uchar
	return $bytes;
}

sub _build_height {
	my ($self) = @_;
	MuPDF::SWIG::fz_pixmap_height($self->fz_context, $self->fz_pixmap);
}
sub _build_width {
	my ($self) = @_;
	MuPDF::SWIG::fz_pixmap_width($self->fz_context, $self->fz_pixmap);
}
sub _build_components {
	my ($self) = @_;
	MuPDF::SWIG::fz_pixmap_components($self->fz_context, $self->fz_pixmap);
}
sub _build_byte_length {
	my ($self) = @_;
	$self->width * $self->height * $self->components;
}

sub get_imager {
	my ($self) = @_;
	my $bytes = $self->get_samples();
	my $imager = Imager->new();
	$imager->read(type=>'pnm', data=>"P6\n@{[$self->width]} @{[$self->height]}\n255\n$bytes") or croak $imager->errstr;
	# TODO : use colorspace
	return $imager;
}

sub DEMOLISH {
	my ($self) = @_;
	MuPDF::SWIG::fz_drop_pixmap($self->fz_context, $self->fz_pixmap);
}

1;
