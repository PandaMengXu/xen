#ifndef __RTXEN_PERF_COUNTER_FUNC_H__
#define __RTXEN_PERF_COUNTER_FUNC_H__

#include <stdio.h>
#include <inttypes.h>
#include <xen/rtxen_perf.h>

static inline void print_rtxen_perf_counter(rtxen_perf_counter_t perf_counter)
{
    int i;
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

#endif
