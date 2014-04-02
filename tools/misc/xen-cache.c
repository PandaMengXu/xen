#include <xenctrl.h>
#include <xc_private.h>
#include <xc_core.h>
#include <errno.h>
#include <unistd.h>

#include <inttypes.h>

#include "xg_save_restore.h"
#include <xen/rtxen_perf.h>
#include "rtxen_perf_counter_func.h"

#define ARRAY_SIZE(a)       (sizeof (a) / sizeof ((a)[0]))
#define CD_SHIFT            30

/*move to rtxen_perf.h*/
/*
#define CACHE_EVENT_MISS    (0x1 << 16)
#define CACHE_EVENT_HIT     (0x2 << 16)
#define CACHE_EVENT_ALL     (0x3 << 16)
#define CACHE_EVENT_MASK    (0x0ffff)

#define CACHE_LEVEL_L1      (0x1)
#define CACHE_LEVEL_L2      (0x2)
#define CACHE_LEVEL_L3      (0x3)
#define CACHE_LEVEL_MASK    (0xffff << 16)
*/

#define INIT_RTXEN_PERF_COUNTER(counter) do{\
                                            int tmp_i;\
                                            counter.op = 0;\
                                            counter.in = 0;\
                                            for( tmp_i = 0; tmp_i < RTXEN_CPU_MAXNUM; tmp_i++ )\
                                            {                                       \
                                                counter.out[tmp_i].cpu_id = 0;      \
                                                counter.out[tmp_i].l1I_miss = 0;    \
                                                counter.out[tmp_i].l1I_hit = 0;     \
                                                counter.out[tmp_i].l1D_all = 0;     \
                                                counter.out[tmp_i].l1D_ldmiss = 0;  \
                                                counter.out[tmp_i].l1D_stmiss = 0;  \
                                                counter.out[tmp_i].l2_all = 0;      \
                                                counter.out[tmp_i].l2_miss = 0;     \
                                                counter.out[tmp_i].l3_all = 0;      \
                                                counter.out[tmp_i].l3_miss = 0;     \
                                            }                                       \
                                            }while(0)

static xc_interface *xch;

int help_func(int argc, char *argv[])
{
    fprintf(stderr,
            "Usage: xen-cache <command> [args]\n"
            "Command:\n"
            "  help                     show this help\n"
            "  show                     show cache status (30bit of CR0)\n"
            "  disable                  disable all cache levels\n"
            "  enable                   enable cache_level L1/L2/L3\n"
            "  count-perf [miss|hit|all] [L1I|L1D|L2|L3|L2L3] [OS|USER|OS_AND_USER] [delay in ms]\n"
            );
    
    return 0;
}

struct{
    const char *name;
    int64_t cache_event_num;
} cache_event[] = {
    { "miss", CACHE_EVENT_MISS},
    { "hit", CACHE_EVENT_HIT},
    { "all", CACHE_EVENT_ALL},
};

struct{
    const char *name;
    int64_t cache_level_num;
} cache_level[] = {
    { "L1I", CACHE_LEVEL_L1I},
    { "L1D", CACHE_LEVEL_L1D},
    { "L2", CACHE_LEVEL_L2},
    { "L3", CACHE_LEVEL_L3},
    { "L2L3", CACHE_LEVEL_L2 | CACHE_LEVEL_L3}
};

struct{
    const char *name;
    int64_t level;
} record_ring_level[] = {
    { "OS", COUNT_EVENT_PVL_OS_BIT},
    { "USER", COUNT_EVENT_PVL_USR_BIT},
    { "OS_AND_USER", (COUNT_EVENT_PVL_OS_BIT | COUNT_EVENT_PVL_USR_BIT)}
};

int count_perf_func(int argc, char *argv[])
{
    int i = 0, ret = -EINVAL;
    int delay_ms;
    rtxen_perf_counter_t perf_counter;

    if( argc != 4 )
    {
        help_func(0,NULL);
        return 1;
    }    

    INIT_RTXEN_PERF_COUNTER(perf_counter);    

    /*Parse cache event*/
    for( i = 0; i < ARRAY_SIZE(cache_event); i++)
    {
        if( !strncmp(cache_event[i].name, argv[0], strlen(argv[0])) )
            break;
    }
    
    if( i == ARRAY_SIZE(cache_event) )
    {
        fprintf(stderr, "Unknown option '%s'\n", argv[0]);
        help_func(0,NULL);
        return 1;
    }

    perf_counter.in |= cache_event[i].cache_event_num;
    
    /*Parse cache level*/
    for( i = 0; i < ARRAY_SIZE(cache_level); i++)
    {
        if( !strncmp(cache_level[i].name, argv[1], strlen(argv[1])) )
            break;
    }

    if( i == ARRAY_SIZE(cache_level) )
    {
        fprintf(stderr, "Unknown option '%s'\n", argv[1]);
        help_func(0, NULL);
        return 1;
    }
    
    perf_counter.in |= cache_level[i].cache_level_num;

    /* Record events in ring 0 or ring 1,2,3 or all of them*/
    for( i = 0; i < ARRAY_SIZE(record_ring_level); i++)
    {
        if( !strncmp(record_ring_level[i].name, argv[2], strlen(argv[2])) )
            break;
    }

    if( i == ARRAY_SIZE(record_ring_level) )
    {
        fprintf(stderr, "Unknown option '%s'\n", argv[2]);
        help_func(0, NULL);
        return 1;
    }
    
    perf_counter.in |= record_ring_level[i].level;

    delay_ms = atoi(argv[3]);
    if( delay_ms < 0 )
        fprintf(stderr, "delay (%d) must be larger than 0\n", delay_ms);

    /*Count events at priviledge level 0 or (1,2,3) or both*/

    printf("Before hypercall: perf_count = %#018lx\n", perf_counter.in);

    ret = xc_count_perf(xch, &perf_counter, delay_ms);
    
    if( ret != 0 )
        ERROR("Failed to record perf_count %#018lx\n", perf_counter.in);
    
    printf("After hypercall: perf_count %#018lx\n", perf_counter.in);
    
    printf("===perf_counter difference value===\n");
    print_rtxen_perf_counter(perf_counter);
/*
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
*/    
    return 0;
}

int show_func(int argc, char *argv[])
{
    unsigned long cr0 = 2;
    int cd = -1;    

    if ( argc > 0 )
    {
        help_func(0, NULL);
        return 1;
    }

    cr0 = (unsigned long) xc_show_cache(xch);
    cd = ( (cr0 >> CD_SHIFT) & 0x1 );
    printf("return value:%#018lx\n"
            "30bit(CD) of CR0 is: %d\n", 
            cr0, cd);
    if ( cd == 1 )
        printf("The cache is disabled\n");
    else if( cd == 0 )
        printf("The cache is enabled\n");
    else
        ERROR("Failed to show 30th bit (CD) of CR0\n");

    return 0;
}

int disable_func(int argc, char *argv[])
{
    int ret = -EINVAL;
    if ( argc > 0 )
    {
        help_func(0, NULL);
        return 1;
    }

    ret = xc_disable_cache(xch);
   // ret = xc_maximum_ram_page(xch);
    printf("return value:%d\n", ret);
    if ( !ret )
        printf(" All cache levels have been disabled!\n");
    else
        ERROR("Failed to disable cache of all levels");

    return ret;
}

int enable_func(int argc, char *argv[])
{
    int ret = -EINVAL;
    if (argc > 0 )
    {
        help_func(0, NULL);
        return 1;
    }
    
    ret = xc_enable_cache(xch);
    
    printf("Enable cache return value:%d\n", ret);
    if ( !ret )
        printf(" All cache levels have been enabled!\n");
    else
        ERROR("Failed to enable cache of all levels");

    return 0;
}

struct{
    const char *name;
    int (*func)(int argc, char *argv[]);
} opts[] = {
    { "help", help_func },
    { "show", show_func},
    { "disable", disable_func },
    { "enable", enable_func },
    { "count-perf", count_perf_func },
};

int main(int argc, char *argv[])
{
    int i, ret;
    
    if(argc < 2)
    {
        help_func(0,NULL);
        return 1;
    }
    
    xch = xc_interface_open(0, 0, 0);
    if ( !xch )
    {
        ERROR("Failed to open an xc handler");
        return 1;
    }
        
    for( i = 0; i < ARRAY_SIZE(opts); i++)
    {
        if ( !strncmp(opts[i].name, argv[1], strlen(argv[1])) )
            break;
    }

    if( i == ARRAY_SIZE(opts))
    {
        fprintf(stderr, "Unknown option '%s'", argv[1]);
        help_func(0, NULL);
        return 1;
    }
    
    ret = opts[i].func(argc - 2, argv + 2);
    
    xc_interface_close(xch);

    return !!ret;
}
