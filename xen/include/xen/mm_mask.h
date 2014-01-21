#ifndef __MM_MASK_H__
#define __MM_MASK_H__

#define BITS_PER_LONG 64
#define PG_shift(idx)   (BITS_PER_LONG - (idx))
#define PG_mask(x, idx) (x ## UL << PG_shift(idx))

 /* Count of uses of this frame as its current type. */
#define PGT_count_width   PG_shift(9)
#define PGT_count_mask    ((1UL<<PGT_count_width)-1)


#endif

