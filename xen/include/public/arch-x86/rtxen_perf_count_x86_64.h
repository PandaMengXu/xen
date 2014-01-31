#ifndef __RTXEN_PERF_COUNT_H__
#define __RTXEN_PERF_COUNT_H__

/*4 Performance Counters Selector for %ecx in insn wrmsr*/
#define PERFEVTSEL0    0x186
#define PERFEVTSEL1    0x187
#define PERFEVTSEL2    0x188
#define PERFEVTSEL3    0x189

/*4 MSR Performance Counter for the above selector*/
#define PMC0    0xc1
#define PMC1    0xc2
#define PMC2    0xc2
#define PMC3    0xc3

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
                                "movl %0, %%eax\n\t"\
                                "xorl %%edx, %%edx\n\t"\
                                "movl %1, %%ecx\n\t"\
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

#define RTXEN_WRITE_MSR(eax, ecx)     __asm__ __volatile__(\
                                "movq %0, %%rax\n\t"\
                                "xorq %%rdx, %%rdx\n\t"\
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

#endif
