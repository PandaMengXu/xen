#include <xenctrl.h>
#include <xc_private.h>
#include <xc_core.h>
#include <errno.h>
#include <unistd.h>
#include <xen/mm_mask.h>

#include "xg_save_restore.h"

#define ARRAY_SIZE(a) (sizeof (a) / sizeof ((a)[0]))

static xc_interface *xch;

int help_func(int argc, char *argv[])
{
    fprintf(stderr,
            "Usage: xen-cache <command> [args]\n"
            "Command:\n"
            "  help                     show this help\n"
            "  disable                  disable all cache levels\n"
            "  enable                   enable cache_level L1/L2/L3\n"
            );
    
    return 0;
}

int disable_func(int argc, char *argv[])
{
    int ret = -1;
    if ( argc > 0 )
    {
        help_func(0, NULL);
        return 1;
    }

    ret = xc_disable_cache(xch);
    printf("return value:%d\n", ret);
    if ( !ret )
        printf(" All cache levels have been disabled!\n");
    else
        ERROR("Failed to disable cache of all levels");

    return ret;
}

int enable_func(int argc, char *argv[])
{
   // int ret = -1;
    if (argc > 0 )
    {
        help_func(0, NULL);
        return 1;
    }
    
    printf("Dump func: TO Implement");
    
    return 0;
}

struct{
    const char *name;
    int (*func)(int argc, char *argv[]);
} opts[] = {
    { "help", help_func },
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
