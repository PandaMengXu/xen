#include <xenctrl.h>
#include <xc_private.h>
#include <xc_core.h>
#include <errno.h>
#include <unistd.h>

#include "xg_save_restore.h"
#include <xen/rtxen_perf.h>

#define ARRAY_SIZE(a)       (sizeof (a) / sizeof ((a)[0]))
#define CD_SHIFT            30

/*move to rtxen_perf.h*/
#define CACHE_EVENT_MISS    (0x1 << 16)
#define CACHE_EVENT_HIT     (0x2 << 16)
#define CACHE_EVENT_ALL     (0x3 << 16)
#define CACHE_EVENT_MASK    (0x0ffff << 16)

#define CACHE_LEVEL_L1      (0x1)
#define CACHE_LEVEL_L2      (0x2)
#define CACHE_LEVEL_L3      (0x3)
#define CACHE_LEVEL_MASK    (0xffff)


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
            "  count-perf [miss|hit|all] [L1|L2|L3]\n"
            "                           count cache [miss|hit|all-access] of [L1|L2|L3] cache\n" 
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
    { "L1", CACHE_LEVEL_L1},
    { "L2", CACHE_LEVEL_L2},
    { "L3", CACHE_LEVEL_L3},
};


int count_perf_func(int argc, char *argv[])
{
    int i = 0, ret = -EINVAL;
    uint64_t perf_count = 0;

    if( argc != 2 )
    {
        help_func(0,NULL);
        return 1;
    }
    
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

    perf_count |= cache_event[i].cache_event_num;
    
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
    
    perf_count |= cache_level[i].cache_level_num;
    
    printf("Before hypercall: perf_count = %#018lx\n", perf_count);

    ret = xc_count_perf(xch, &perf_count);
    
    if( ret != 0 )
        ERROR("Failed to record perf_count %#018lx\n", perf_count);
    
    printf("After hypercall: perf_count %#018lx\n", perf_count);
    
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
