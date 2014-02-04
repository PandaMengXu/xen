#ifndef __RTXEN_PERF_H__
#define __RTXEN_PERF_H__

/*[A0-A15] for cache event*/
#define CACHE_EVENT_MISS    (0x1UL) 
#define CACHE_EVENT_HIT     (0x1UL << 1) 
#define CACHE_EVENT_ALL     (0x1UL << 2)

#define CACHE_EVENT_MISS_MASK   CACHE_EVENT_MISS
#define CACHE_EVENT_HIT_MASK    CACHE_EVENT_HIT
#define CACHE_EVENT_MASK    (0x0ffffUL)

/*A16-A31 for cache level*/
#define CACHE_LEVEL_L1I      ( 0x1UL << 16 )
#define CACHE_LEVEL_L1D     ( (0x1UL << 1) << 16)
#define CACHE_LEVEL_L2      ( (0x1UL << 2) << 16 )
#define CACHE_LEVEL_L3      ( (0x1UL << 3) << 16 )

#define CACHE_LEVEL_L1I_MASK    CACHE_LEVEL_L1I
#define CACHE_LEVEL_L1D_MASK    CACHE_LEVEL_L1D
#define CACHE_LEVEL_L2_MASK     CACHE_LEVEL_L2
#define CACHE_LEVEL_L3_MASK     CACHE_LEVEL_L3
#define CACHE_LEVEL_MASK        ( 0xffffUL << 16 )

/*A32 count event at ring 0 (OS bit)?*/
#define COUNT_EVENT_PVL_OS                  (0x1UL << 32)
#define COUNT_EVENT_PVL_OS_MASK             (0x1UL << 32)
#define SET_COUNT_EVENT_PVL_OS(counter)     ( counter |= COUNT_EVENT_PVL_OS )
#define CLEAR_COUNT_EVENT_PVL_OS(counter)   ( counter &= (~COUNT_EVENT_PVL_OS) )
#define IS_COUNT_EVENT_PVL_OS(counter)      ( counter & COUNT_EVENT_PVL_OS_MASK )  

/*A33 count event at ring 1,2,3 (USR bit)*/
#define COUNT_EVENT_PVL_USR (0x1UL << 33)
#define COUNT_EVENT_PVL_USR_MASK (0x1UL << 33)
#define SET_COUNT_EVENT_PVL_USR(counter)    ( counter |= COUNT_EVENT_PVL_USR )
#define CLEAR_COUNT_EVENT_PVL_USR(counter)  ( counter &= (~COUNT_EVENT_PVL_USR) )
#define IS_COUNT_EVENT_PVL_USR( counter )   ( counter & COUNT_EVENT_PVL_USR_MASK)

#define READ_MSR_BIT            (0x1U)
#define SET_MSR                 SET_MSR_BIT
#define SET_MSR_BIT             (0x1U << 1)
#define READ_MSR                READ_MSR_BIT

#define IS_SET_MSR(op)          (op & SET_MSR_BIT)
#define IS_READ_MSR(op)         (op & READ_MSR_BIT)
/*#define READSET_MSR_MASK    (0x3)*/


#define RTXEN_CPU_MAXNUM   16

typedef struct rtxen_cpu_perf
{
    uint32_t cpu_id;
    uint64_t l1I_miss;
    uint64_t l1I_hit;
    uint64_t l1D_all;
    uint64_t l1D_ldmiss;
    uint64_t l1D_stmiss;
    uint64_t l2_all;
    uint64_t l2_miss;
    uint64_t l3_all;
    uint64_t l3_miss;
} rtxen_cpu_perf_t;

typedef struct rtxen_perf_counter{
    uint32_t op; /*read/set MSR*/
    uint64_t in;/*perf_count*/
    rtxen_cpu_perf_t out[RTXEN_CPU_MAXNUM];    
} rtxen_perf_counter_t;

/*
static inline print_rtxen_perf_counter(rtxen_perf_counter_t perf_counter)
{
    printf("#cpu_id\tL1Imiss\tL1Iall\tL1I_MR\tL1Dmiss\tL1Dall\tL1D_MR\tL2miss\tL2all\tL2_MR\tL3_miss\tL3_all\tL3_MR\n");
    for( i = 0; i < RTXEN_CPU_MAXNUM; i++ )
    {
        printf( "cpu %d :", i );
        printf( "%"PRIu64 "\t%"PRIu64 "\t""%.2f\t",
                 perf_counter.out[i].l1I_miss, perf_counter.out[i].l1I_miss + perf_counter.out[i].l1I_hit,
                 perf_counter.out[i].l1I_miss * 1.0 / (perf_counter.out[i].l1I_miss + perf_counter.out[i].l1I_hit) );
        printf( "%"PRIu64 "\t%"PRIu64 "\t""%.2f\t",
                perf_counter.out[i].l1D_ldmiss + perf_counter.out[i].l1D_stmiss, perf_counter.out[i].l1D_all,
                (perf_counter.out[i].l1D_ldmiss + perf_counter.out[i].l1D_stmiss) * 1.0 / perf_counter.out[i].l1D_all );
        printf( "%"PRIu64 "\t%"PRIu64 "\t""%.2f\t",
                perf_counter.out[i].l2_miss, perf_counter.out[i].l2_all,  perf_counter.out[i].l2_miss * 1.0 / perf_counter.out[i].l2_all );
        printf( "%"PRIu64 "\t%"PRIu64 "\t""%.2f\t",
                perf_counter.out[i].l3_miss, perf_counter.out[i].l3_all,  perf_counter.out[i].l3_miss * 1.0 / perf_counter.out[i].l3_all );
        printf("\n");
    }
}
*/
#endif
