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

/*L1 Instruction Cache Performance Tuning Events*/
#define L1I_ALLHIT_EVENT    0x80
#define L1I_ALLHIT_MASK     0x01
#define L1I_ALLMISS_EVENT   0x80
#define L1I_ALLMISS_MASK    0x02

/*L1 Data Cache Performance Tuning Events*/
/*Intel does not have the ALLREQ Miss mask; have to add LD_miss and ST_miss*/
#define L1D_ALLREQ_EVENT    0x43
#define L1D_ALLREQ_MASK     0x01
#define L1D_LD_EVENT        0x40
#define L1D_LDMISS_MASK     0x01
#define L1D_ST_EVENT        0x28
#define L1D_STMISS_MASK     0x01

/*L2 private cache for each core*/
#define L2_ALLREQ_EVENT     0x24
#define L2_ALLREQ_MASK      0xFF
#define L2_ALLMISS_EVENT    0x24
#define L2_ALLMISS_MASK     0xAA

/*L3 shared cache*/
/*Use the last level cache event and mask*/
#define L3_ALLREQ_EVENT     0x2E
#define L3_ALLREQ_MASK      0x4F
#define L3_ALLMISS_EVENT    0x2E
#define L3_ALLMISS_EVENT    0x41 

#define USR_BIT             (0x1 << 16)
#define OS_BIT              (0x1 << 17)


#define SET_MSR_USR_BIT(eax)    eax |= USR_BIT
#define CLEAR_MSR_USR_BIT(exa)  eax &= (~USR_BIT)
#define SET_MSR_OS_BIT(eax)     eax |= OS_BIT
#define CLEAR_MSR_OS_BIT(eax)   eax &= (~OS_BIT)

#define SET_EVENT_MASK(eax, event, umask)    eax |= (event | (umask << 8))     

#define WRITE_MSR(eax, ecx)     __asm__ __volatile__(
                                "movq %0, %%rax\n\t"
                                "xor %%rdx, %%rdx\n\t"
                                "movq %1, %%ecx"
                                :
                                :"r" (eax), "r" (ecx)
                                :
                                );

#define READ_MSR(ecx, eax, edx) __asm__ __volatile__(
                                "xor %%rax, %%rax\n\t"
                                "xor %%rdx, %%rdx\n\t"
                                "movq %2, %%rcx\n\t"
                                "rdmsr"
                                :"=d" (edx), "=a" (eax)
                                :"r" (ecx)
                                :"%%eax", "%%edx", "%%rax", "rdx"
                                )

#endif
