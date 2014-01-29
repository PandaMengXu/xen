#ifndef __RTXEN_PERF_H__
#define __RTXEN_PERF_H__

/*[A0-A15] for cache event*/
#define CACHE_EVENT_MISS    (0x1) 
#define CACHE_EVENT_HIT     (0x1 << 1) 

/*#define CACHE_EVENT_ALL     (0x1 << 2)*/

#define CACHE_EVENT_MISS_MASK   CACHE_EVENT_MISS
#define CACHE_EVENT_HIT_MASK    CACHE_EVENT_HIT
#define CACHE_EVENT_MASK    (0x0ffff)

/*A16-A31 for cache level*/
#define CACHE_LEVEL_L1      ( 0x1 << 16 )
#define CACHE_LEVEL_L2      ( (0x1 << 1) << 16 )
#define CACHE_LEVEL_L3      ( (0x1 << 2) << 16 )

#define CACHE_LEVEL_L1_MASK CACHE_LEVEL_L1
#define CACHE_LEVEL_L2_MASK CACHE_LEVEL_L2
#define CACHE_LEVEL_L3_MASK CACHE_LEVEL_L3
#define CACHE_LEVEL_MASK    ( 0xffff << 16 )



#endif
