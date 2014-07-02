#ifndef __MM_MASK_H__
#define __MM_MASK_H__

#define BITS_PER_LONG 64
#define PG_shift(idx)   (BITS_PER_LONG - (idx))
#define PG_mask(x, idx) (x ## UL << PG_shift(idx))

 /* Count of uses of this frame as its current type. */
#define PGT_count_width   PG_shift(9)
#define PGT_count_mask    ((1UL<<PGT_count_width)-1)


/* 12MB LLC consists of 6 2MB cache, so both machine has same cache arch? */
#define RTXEN_L3CACHE_SIZE      (12*1024*1024 / 6)
#define RTXEN_L3CACHE_LINESIZE  (64)
#define RTXEN_L3CACHE_LINEBITS  (6)
#define RTXEN_L3CACHE_ASSOC     (16)
#define RTXEN_L3CACHE_COLORS    (2*1024)
#define RTXEN_L3CACHE_COLOR_MASK ((RTXEN_L3CACHE_COLORS-1) << 6)
#define RTXEN_GET_L3CACHE_COLOR(p)  ((p & RTXEN_L3CACHE_COLOR_MASK) >> 6)


#endif
