#ifndef __RTXEN_PERF_COUNT_H__
#define __RTXEN_PERF_COUNT_H__

#include <public/rtxen_perf.h>

/*4 Performance Counters Selector for %ecx in insn wrmsr*/
#define PERFEVTSEL0    0x186
#define PERFEVTSEL1    0x187
#define PERFEVTSEL2    0x188
#define PERFEVTSEL3    0x189

/*4 MSR Performance Counter for the above selector*/
#define PMC0    0xc1
#define PMC1    0xc2
#define PMC2    0xc3
#define PMC3    0xc4

/*MSR EN flag: when set start the counter!*/
#define MSR_ENFLAG      (0x01U << 22)
#define MSR_INTFLAG     (0x01U << 20)

/*Intel Software Developer Manual Page 2549*/ /*L1I L1D cache events has not been confirmed!*/
/*L1 Instruction Cache Performance Tuning Events*/
#define L1I_ALLHIT_EVENT    0x80
#define L1I_ALLHIT_MASK     0x01
#define L1I_ALLMISS_EVENT   0x80    /*confirmed*/
#define L1I_ALLMISS_MASK    0x02    /*confirmed*/

/*L1 Data Cache Performance Tuning Events*/
/*Intel does not have the ALLREQ Miss mask; have to add LD_miss and ST_miss*/
#define L1D_ALLREQ_EVENT    0x43
#define L1D_ALLREQ_MASK     0x01
#define L1D_LDMISS_EVENT    0x40
#define L1D_LDMISS_MASK     0x01
#define L1D_STMISS_EVENT    0x28
#define L1D_STMISS_MASK     0x01

/*L2 private cache for each core*/ /*confirmed*/
/* Page 2550 for Intel 3rd generation CPU (Ivebridge) in Intel Developer manual*/
/* Page 2560 for Intel 2nd generation CPU (SandyBridge) in Intel Developer manual*/
#define L2_ALLREQ_EVENT     0x24
#define L2_ALLREQ_MASK      L2_ALLCODEREQ_MASK  /*0xFF*/
#define L2_ALLMISS_EVENT    0x24
#define L2_ALLMISS_MASK     L2_ALLCODEMISS_MASK /*0xAA*/

#define L2_ALLCODEREQ_MASK  0x30
#define L2_ALLCODEMISS_MASK 0x20

/*L3 shared cache*/ /*confirmed*/
/*Use the last level cache event and mask*/
#define L3_ALLREQ_EVENT     0x2E
#define L3_ALLREQ_MASK      0x4F
#define L3_ALLMISS_EVENT    0x2E
#define L3_ALLMISS_MASK     0x41 

#define USR_BIT             (0x1 << 16)
#define OS_BIT              (0x1 << 17)


#define SET_MSR_USR_BIT(eax)    eax |= USR_BIT
#define CLEAR_MSR_USR_BIT(exa)  eax &= (~USR_BIT)
#define SET_MSR_OS_BIT(eax)     eax |= OS_BIT
#define CLEAR_MSR_OS_BIT(eax)   eax &= (~OS_BIT)

#define SET_EVENT_MASK(eax, event, umask)    eax |= (event | (umask << 8))     

/*#define RTXEN_WRITE_MSR(eax, ecx)   do{\
                                __asm__ __volatile__(\
                                "movl %0, %%eax\n\t"\
                                "xorl %%edx, %%edx\n\t"\
                                "movl %1, %%ecx\n\t"\
                                "wrmsr"\
                                :\
                                :"r" (eax), "r" (ecx)\
                                :\
                                );\
                                } while(0)*/
/*                               dprintk(XENLOG_INFO, "RTXEN_WRITE_MSR(eax=%#010x, ecx=%#010x)\n", eax, ecx);\*/
/*
#define RTXEN_READ_MSR(ecx, eax, edx) do{\
                                __asm__ __volatile__(\
                                "xorl %%eax, %%eax\n\t"\
                                "xorl %%edx, %%edx\n\t"\
                                "movl %2, %%ecx\n\t"\
                                "rdmsr"\
                                :"=d" (edx), "=a" (eax)\
                                :"r" (ecx)\
                                :\
                                );\
                                } while(0)
*/
/*                                dprintk(XENLOG_INFO, "RTXEN_READ_MSR(ecx=%#010x, eax=%#010x, edx=%#010x)\n", ecx, eax, edx);\*/

/* 32bit insn */
/*
#define RTXEN_WRITE_MSR(eax, ecx)     __asm__ __volatile__(\
                                "movl %1, %%ecx\n\t"\
                                "movl %0, %%eax\n\t"\
                                "xorl %%edx, %%edx\n\t"\
                                "wrmsr"\
                                :\
                                :"r" (eax), "r" (ecx)\
                                :\
                                )

#define RTXEN_READ_MSR(ecx, eax, edx) __asm__ __volatile__(\
                                "xorl %%eax, %%eax\n\t"\
                                "xorl %%edx, %%edx\n\t"\
                                "movl %2, %%ecx\n\t"\
                                "rdmsr"\
                                :"=d" (edx), "=a" (eax)\
                                :"r" (ecx)\
                                :\
                                )
*/
/* 32bit insn v2  need to set enable bit*/
/*#define RTXEN_WRITE_MSR(eax, ecx)     __asm__ __volatile__(\
                                "wrmsr"\
                                :"=a" (eax), "=c" (ecx)\
                                :"a" ((uint32_t)eax), "c" ((uint32_t)ecx), "d" ((uint32_t)0)\
                                )

#define RTXEN_READ_MSR(ecx, eax, edx) __asm__ __volatile__(\
                                "rdmsr"\
                                :"=d" ((uint32_t)edx), "=a" ((uint32_t)eax)\
                                :"c" ((uint32_t)ecx)\
                                :\
                                )
*/
/* 32bit insn v3*/
static inline void RTXEN_WRITE_MSR(uint32_t eax, uint32_t ecx)
{     
    /*clear counter first*/
   __asm__ __volatile__ ("movl %0, %%ecx\n\t"
        "xorl %%edx, %%edx\n\t"
        "xorl %%eax, %%eax\n\t"
        "wrmsr\n\t"
        : /* no outputs */
        : "m" (ecx)
        : "eax", "ecx", "edx" /* all clobbered */);
 
//   eax |= MSR_ENFLAG; /* Start the counter */
//   eax |= MSR_INTFLAG; /* Trigger interrupt when counter overflow*/

   __asm__("movl %0, %%ecx\n\t" /* ecx contains the number of the MSR to set */
        "xorl %%edx, %%edx\n\t"/* edx contains the high bits to set the MSR to */
        "movl %1, %%eax\n\t" /* eax contains the log bits to set the MSR to */
        "wrmsr\n\t"
        : /* no outputs */
        : "m" (ecx), "m" (eax)
        : "eax", "ecx", "edx" /* clobbered */);
}

static inline void stop_counter(uint64_t in, uint32_t event_mask, uint32_t umask, uint32_t perfevtsel)
{
    uint32_t eax = 0, ecx = 0; 
    if( IS_COUNT_EVENT_PVL_USR(in) )
        SET_MSR_USR_BIT(eax);
    if( IS_COUNT_EVENT_PVL_OS(in) )
        SET_MSR_OS_BIT(eax);
    SET_EVENT_MASK(eax, event_mask, umask);
    eax |= MSR_INTFLAG;
    eax &= (~MSR_ENFLAG);
    ecx = perfevtsel;
    RTXEN_WRITE_MSR(eax, ecx);

}

static inline void  rtxen_read_msr(uint32_t pmc_num, uint32_t* eax, uint32_t* edx)
{
    uint32_t ecx = pmc_num;    
    __asm__ __volatile__(
        "rdmsr"
        :"=d" (*edx), "=a" (*eax)
        :"c" (ecx)
        :
        );
    dprintk(XENLOG_INFO,"read_msr (pmc=%d), edx=%u (%#010x), eax=%u (%#010x)\n",pmc_num, *edx, *edx, *eax, *eax );
}
/*64 bit insn*/
/*
#define RTXEN_WRITE_MSR(eax, ecx)     __asm__ __volatile__(\
                                "movq %0, %%rax\n\t"\
                                "xorq %%rdx, %%rdx\n\t"\
                                "xorq %%rcx, %%rcx\n\t"\
                                "movq %1, %%rcx\n\t"\
                                "wrmsr"\
                                :\
                                :"r" (eax), "r" (ecx)\
                                :\
                                )

#define RTXEN_READ_MSR(ecx, eax, edx) __asm__ __volatile__(\
                                "xorq %%rax, %%rax\n\t"\
                                "xorq %%rdx, %%rdx\n\t"\
                                "movq %2, %%rcx\n\t"\
                                "rdmsr"\
                                :"=d" (edx), "=a" (eax)\
                                :"r" (ecx)\
                                :\
                                )
*/
#endif
