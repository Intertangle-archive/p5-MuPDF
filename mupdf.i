/* mupdf.i */
%module example
%{
#include "fitz.h"
%}


/* <http://www.swig.org/Doc2.0/Library.html#Library_nn7> */
%include "cdata.i"

%rename next next_item;
/*%include "fitz.h"*/


extern fz_colorspace *fz_device_gray;
extern fz_colorspace *fz_device_rgb;
extern fz_colorspace *fz_device_bgr;
extern fz_colorspace *fz_device_cmyk;

fz_context *fz_new_context(fz_alloc_context *alloc, fz_locks_context *locks, unsigned int max_store);
fz_document *fz_open_document(fz_context *ctx, char *filename);
int fz_count_pages(fz_document *doc);
fz_page *fz_load_page(fz_document *doc, int number);

fz_outline *fz_load_outline(fz_document *doc);

typedef struct fz_outline_s fz_outline;
struct fz_outline_s
{
	char *title;
	fz_link_dest dest;
	fz_outline *next;
	fz_outline *down;
};

extern const fz_matrix fz_identity;
fz_matrix fz_scale(float sx, float sy);
fz_matrix fz_rotate(float degrees);
fz_matrix fz_concat(fz_matrix left, fz_matrix right);

fz_rect fz_bound_page(fz_document *doc, fz_page *page);
fz_rect fz_transform_rect(fz_matrix transform, fz_rect rect);
fz_bbox fz_round_rect(fz_rect rect);

fz_pixmap *fz_new_pixmap_with_bbox(fz_context *ctx, fz_colorspace *colorspace, fz_bbox bbox);
void fz_clear_pixmap_with_value(fz_context *ctx, fz_pixmap *pix, int value);

fz_device *fz_new_draw_device(fz_context *ctx, fz_pixmap *dest);
void fz_run_page(fz_document *doc, fz_page *page, fz_device *dev, fz_matrix transform, fz_cookie *cookie);
void fz_free_device(fz_device *dev);

void fz_write_png(fz_context *ctx, fz_pixmap *pixmap, char *filename, int savealpha);

void fz_drop_pixmap(fz_context *ctx, fz_pixmap *pix);
void fz_free_page(fz_document *doc, fz_page *page);
void fz_close_document(fz_document *doc);
void fz_free_context(fz_context *ctx);

unsigned char *fz_pixmap_samples(fz_context *ctx, fz_pixmap *pix);
int fz_pixmap_width(fz_context *ctx, fz_pixmap *pix);
int fz_pixmap_height(fz_context *ctx, fz_pixmap *pix);
int fz_pixmap_components(fz_context *ctx, fz_pixmap *pix);

enum {
        FZ_STORE_UNLIMITED = 0,
        FZ_STORE_DEFAULT = 256 << 20,
};

typedef struct fz_rect_s fz_rect;
struct fz_rect_s
{
	float x0, y0;
	float x1, y1;
};

typedef struct fz_bbox_s fz_bbox;
struct fz_bbox_s
{
	int x0, y0;
	int x1, y1;
};
