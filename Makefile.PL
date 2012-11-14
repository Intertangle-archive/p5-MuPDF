# File : Makefile.PL
use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'    => 'MuPDF::SWIG',                  # Name of package
	'LIBS'    => ['-lpng -lm -ljpeg -ljbig2dec -lopenjpeg -lfreetype -lfitz'],                    # Name of custom libraries
	#
	'OBJECT'  => 'mupdf_wrap.o'  # Object files
);
