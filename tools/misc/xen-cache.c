#include <xenctrl.h>
#include <xc_private.h>
#include <xc_core.h>
#include <errno.h>
#include <unistd.h>
#include <xen/mm_mask.h>

#include "xg_save_restore.h"

#define ARRAY_SIZE(a) (sizeof (a) / sizeof ((a)[0]))
#define CD_SHIFT 30
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
            );
    
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
