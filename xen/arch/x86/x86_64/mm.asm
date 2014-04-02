
xen/arch/x86/x86_64/mm.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <disable_cache>:
    }
}

void disable_cache(void *cr0)
{
    __asm__ __volatile__(
       0:	50                   	push   %rax
       1:	0f 20 c0             	mov    %cr0,%rax
       4:	48 0d 00 00 00 40    	or     $0x40000000,%rax
       a:	0f 22 c0             	mov    %rax,%cr0
       d:	0f 20 c0             	mov    %cr0,%rax
      10:	0f 09                	wbinvd 
      12:	58                   	pop    %rax
      13:	48 89 07             	mov    %rax,(%rdi)
        "popq  %%rax"
        :"=r" ( *((unsigned long*) cr0) )
        :
        :
        );
}
      16:	c3                   	retq   
      17:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
      1e:	00 00 

0000000000000020 <enable_cache>:

void enable_cache(void *cr0)
{
     __asm__ __volatile__(
      20:	50                   	push   %rax
      21:	0f 20 c0             	mov    %cr0,%rax
      24:	48 25 ff ff ff bf    	and    $0xffffffffbfffffff,%rax
      2a:	0f 22 c0             	mov    %rax,%cr0
      2d:	0f 20 c0             	mov    %cr0,%rax
      30:	58                   	pop    %rax
      31:	48 89 07             	mov    %rax,(%rdi)
        "popq  %%rax"
        :"=r" ( *((unsigned long*) cr0) )
        :
        :
        );
}
      34:	c3                   	retq   
      35:	66 66 2e 0f 1f 84 00 	data32 nopw %cs:0x0(%rax,%rax,1)
      3c:	00 00 00 00 

0000000000000040 <setread_perf_counter>:

void setread_perf_counter(void* arg_perf_counter)
{
      40:	48 83 ec 38          	sub    $0x38,%rsp
};

static inline struct cpu_info *get_cpu_info(void)
{
    unsigned long tos;
    __asm__ ( "and %%rsp,%0" : "=r" (tos) : "0" (~(STACK_SIZE-1)) );
      44:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
      4b:	48 89 5c 24 10       	mov    %rbx,0x10(%rsp)
      50:	48 89 6c 24 18       	mov    %rbp,0x18(%rsp)
      55:	48 89 fb             	mov    %rdi,%rbx
      58:	4c 89 64 24 20       	mov    %r12,0x20(%rsp)
      5d:	4c 89 6c 24 28       	mov    %r13,0x28(%rsp)
      62:	4c 89 74 24 30       	mov    %r14,0x30(%rsp)
    rtxen_perf_counter_t* perf_counter = (rtxen_perf_counter_t*) arg_perf_counter;

    cpu_id = smp_processor_id();

    /*Note: Intel SandyBridge only has four counters, so only L2 and L3 can be monitored at the same time; L1I and L1D has to be monitored separately*/
    if( (perf_counter->in & CACHE_LEVEL_L1I_MASK) == CACHE_LEVEL_L1I )
      67:	48 8b 77 08          	mov    0x8(%rdi),%rsi
      6b:	48 21 e0             	and    %rsp,%rax
    uint64_t l2_miss, l2_all;
    uint64_t l3_miss, l3_all;
    int cpu_id = 0;
    rtxen_perf_counter_t* perf_counter = (rtxen_perf_counter_t*) arg_perf_counter;

    cpu_id = smp_processor_id();
      6e:	8b a8 e0 7f 00 00    	mov    0x7fe0(%rax),%ebp

    /*Note: Intel SandyBridge only has four counters, so only L2 and L3 can be monitored at the same time; L1I and L1D has to be monitored separately*/
    if( (perf_counter->in & CACHE_LEVEL_L1I_MASK) == CACHE_LEVEL_L1I )
      74:	f7 c6 00 00 01 00    	test   $0x10000,%esi
      7a:	74 67                	je     e3 <setread_perf_counter+0xa3>
    {
        if( IS_SET_MSR(perf_counter->op) )
      7c:	8b 07                	mov    (%rdi),%eax
      7e:	a8 02                	test   $0x2,%al
      80:	74 55                	je     d7 <setread_perf_counter+0x97>
        {
            /*set counter for L1 Instruction cache all hit event*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
      82:	48 b8 00 00 00 00 02 	movabs $0x200000000,%rax
      89:	00 00 00 
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L1I_ALLHIT_EVENT, L1I_ALLHIT_MASK);
            ecx = PERFEVTSEL0;
            RTXEN_WRITE_MSR(eax, ecx);        
      8c:	b9 86 01 00 00       	mov    $0x186,%ecx
    {
        if( IS_SET_MSR(perf_counter->op) )
        {
            /*set counter for L1 Instruction cache all hit event*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
      91:	48 21 c6             	and    %rax,%rsi
      94:	48 83 fe 01          	cmp    $0x1,%rsi
      98:	19 c0                	sbb    %eax,%eax
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L1I_ALLHIT_EVENT, L1I_ALLHIT_MASK);
            ecx = PERFEVTSEL0;
            RTXEN_WRITE_MSR(eax, ecx);        
      9a:	31 d2                	xor    %edx,%edx
    {
        if( IS_SET_MSR(perf_counter->op) )
        {
            /*set counter for L1 Instruction cache all hit event*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
      9c:	66 31 c0             	xor    %ax,%ax
      9f:	05 80 01 01 00       	add    $0x10180,%eax
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L1I_ALLHIT_EVENT, L1I_ALLHIT_MASK);
            ecx = PERFEVTSEL0;
            RTXEN_WRITE_MSR(eax, ecx);        
      a4:	0f 30                	wrmsr  
            /*set counter for L1 Instruction cache all miss event*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
      a6:	48 83 fe 01          	cmp    $0x1,%rsi
      aa:	48 89 77 08          	mov    %rsi,0x8(%rdi)
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L1I_ALLMISS_EVENT, L1I_ALLMISS_MASK);
            ecx = PERFEVTSEL1;
            RTXEN_WRITE_MSR(eax, ecx);
      ae:	b1 87                	mov    $0x87,%cl
            SET_EVENT_MASK(eax, L1I_ALLHIT_EVENT, L1I_ALLHIT_MASK);
            ecx = PERFEVTSEL0;
            RTXEN_WRITE_MSR(eax, ecx);        
            /*set counter for L1 Instruction cache all miss event*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
      b0:	19 c0                	sbb    %eax,%eax
      b2:	66 31 c0             	xor    %ax,%ax
      b5:	05 80 02 01 00       	add    $0x10280,%eax
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L1I_ALLMISS_EVENT, L1I_ALLMISS_MASK);
            ecx = PERFEVTSEL1;
            RTXEN_WRITE_MSR(eax, ecx);
      ba:	0f 30                	wrmsr  
            dprintk(XENLOG_INFO, "L1I SET MSR PMC0 and PMC1\n");
      bc:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # c3 <setread_perf_counter+0x83>
      c3:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # ca <setread_perf_counter+0x8a>
      ca:	31 c0                	xor    %eax,%eax
      cc:	66 ba 40 04          	mov    $0x440,%dx
      d0:	e8 00 00 00 00       	callq  d5 <setread_perf_counter+0x95>
      d5:	8b 03                	mov    (%rbx),%eax
        }
        if( IS_READ_MSR(perf_counter->op)  )
      d7:	a8 01                	test   $0x1,%al
      d9:	0f 85 91 02 00 00    	jne    370 <setread_perf_counter+0x330>
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l1I_miss = ( ((uint64_t) edx << 32) | eax );
            perf_counter->out[cpu_id].l1I_miss = l1I_miss;
            perf_counter->out[cpu_id].l1I_hit = l1I_hit;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L1 Instruction cache miss:%llu\t cache hit:%llu\n", cpu_id,0, (unsigned long long) l1I_miss,(unsigned long long) l1I_hit);
      df:	48 8b 73 08          	mov    0x8(%rbx),%rsi
        }
    }

    if( (perf_counter->in & CACHE_LEVEL_L1D_MASK) == CACHE_LEVEL_L1D )
      e3:	f7 c6 00 00 02 00    	test   $0x20000,%esi
      e9:	74 79                	je     164 <setread_perf_counter+0x124>
    {
        if( IS_SET_MSR(perf_counter->op) )
      eb:	8b 03                	mov    (%rbx),%eax
      ed:	a8 02                	test   $0x2,%al
      ef:	74 67                	je     158 <setread_perf_counter+0x118>
        {
            /*set counter for L1 Data cache all request event*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
      f1:	48 b8 00 00 00 00 02 	movabs $0x200000000,%rax
      f8:	00 00 00 
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L1D_ALLREQ_EVENT, L1D_ALLREQ_MASK);
            ecx = PERFEVTSEL0;
            RTXEN_WRITE_MSR(eax, ecx);        
      fb:	b9 86 01 00 00       	mov    $0x186,%ecx
    {
        if( IS_SET_MSR(perf_counter->op) )
        {
            /*set counter for L1 Data cache all request event*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     100:	48 21 c6             	and    %rax,%rsi
     103:	48 83 fe 01          	cmp    $0x1,%rsi
     107:	19 c0                	sbb    %eax,%eax
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L1D_ALLREQ_EVENT, L1D_ALLREQ_MASK);
            ecx = PERFEVTSEL0;
            RTXEN_WRITE_MSR(eax, ecx);        
     109:	31 d2                	xor    %edx,%edx
    {
        if( IS_SET_MSR(perf_counter->op) )
        {
            /*set counter for L1 Data cache all request event*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     10b:	66 31 c0             	xor    %ax,%ax
     10e:	05 43 01 01 00       	add    $0x10143,%eax
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L1D_ALLREQ_EVENT, L1D_ALLREQ_MASK);
            ecx = PERFEVTSEL0;
            RTXEN_WRITE_MSR(eax, ecx);        
     113:	0f 30                	wrmsr  
            /*set counter for L1 Data cache Load miss event*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     115:	48 83 fe 01          	cmp    $0x1,%rsi
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L1D_LDMISS_EVENT, L1D_LDMISS_MASK);
            ecx = PERFEVTSEL1;
            RTXEN_WRITE_MSR(eax, ecx);
     119:	b1 87                	mov    $0x87,%cl
            SET_EVENT_MASK(eax, L1D_ALLREQ_EVENT, L1D_ALLREQ_MASK);
            ecx = PERFEVTSEL0;
            RTXEN_WRITE_MSR(eax, ecx);        
            /*set counter for L1 Data cache Load miss event*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     11b:	19 c0                	sbb    %eax,%eax
     11d:	66 31 c0             	xor    %ax,%ax
     120:	05 40 01 01 00       	add    $0x10140,%eax
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L1D_LDMISS_EVENT, L1D_LDMISS_MASK);
            ecx = PERFEVTSEL1;
            RTXEN_WRITE_MSR(eax, ecx);
     125:	0f 30                	wrmsr  
            /*set counter for L1 Data cache Store miss event*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     127:	48 83 fe 01          	cmp    $0x1,%rsi
     12b:	48 89 73 08          	mov    %rsi,0x8(%rbx)
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L1D_STMISS_EVENT, L1D_STMISS_MASK);
            ecx = PERFEVTSEL2;
            RTXEN_WRITE_MSR(eax, ecx);
     12f:	b1 88                	mov    $0x88,%cl
            SET_EVENT_MASK(eax, L1D_LDMISS_EVENT, L1D_LDMISS_MASK);
            ecx = PERFEVTSEL1;
            RTXEN_WRITE_MSR(eax, ecx);
            /*set counter for L1 Data cache Store miss event*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     131:	19 c0                	sbb    %eax,%eax
     133:	66 31 c0             	xor    %ax,%ax
     136:	05 28 01 01 00       	add    $0x10128,%eax
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L1D_STMISS_EVENT, L1D_STMISS_MASK);
            ecx = PERFEVTSEL2;
            RTXEN_WRITE_MSR(eax, ecx);
     13b:	0f 30                	wrmsr  
            dprintk(XENLOG_INFO, "L1D SET MSR PMC0 PMC1, PMC2\n");
     13d:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 144 <setread_perf_counter+0x104>
     144:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 14b <setread_perf_counter+0x10b>
     14b:	31 c0                	xor    %eax,%eax
     14d:	66 ba 75 04          	mov    $0x475,%dx
     151:	e8 00 00 00 00       	callq  156 <setread_perf_counter+0x116>
     156:	8b 03                	mov    (%rbx),%eax
        }
        if( IS_READ_MSR(perf_counter->op) )
     158:	a8 01                	test   $0x1,%al
     15a:	0f 85 78 02 00 00    	jne    3d8 <setread_perf_counter+0x398>
            RTXEN_READ_MSR(ecx, eax, edx);
            l1D_stmiss = ( ((uint64_t) edx << 32) | eax );
            perf_counter->out[cpu_id].l1D_all = l1D_all;
            perf_counter->out[cpu_id].l1D_ldmiss = l1D_ldmiss;
            perf_counter->out[cpu_id].l1D_stmiss = l1D_stmiss;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L1 Data cache all req:%llu\t cacheload miss:%llu cache store miss %llu\n", cpu_id,0, (unsigned long long) l1D_all,(unsigned long long) l1D_ldmiss, (unsigned long long) l1D_stmiss);
     160:	48 8b 73 08          	mov    0x8(%rbx),%rsi
        }
    }

    if( (perf_counter->in & CACHE_LEVEL_L2_MASK) == CACHE_LEVEL_L2 )
     164:	f7 c6 00 00 04 00    	test   $0x40000,%esi
     16a:	74 67                	je     1d3 <setread_perf_counter+0x193>
    {
        if( IS_SET_MSR(perf_counter->op) )
     16c:	8b 03                	mov    (%rbx),%eax
     16e:	a8 02                	test   $0x2,%al
     170:	74 55                	je     1c7 <setread_perf_counter+0x187>
        {
            /*set counter for L2 cache all req*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     172:	48 b8 00 00 00 00 02 	movabs $0x200000000,%rax
     179:	00 00 00 
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L2_ALLREQ_EVENT, L2_ALLREQ_MASK);
            ecx = PERFEVTSEL0; /*use Performance Counter 0 to record the event*/
            RTXEN_WRITE_MSR(eax, ecx);
     17c:	b9 86 01 00 00       	mov    $0x186,%ecx
    {
        if( IS_SET_MSR(perf_counter->op) )
        {
            /*set counter for L2 cache all req*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     181:	48 21 c6             	and    %rax,%rsi
     184:	48 83 fe 01          	cmp    $0x1,%rsi
     188:	19 c0                	sbb    %eax,%eax
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L2_ALLREQ_EVENT, L2_ALLREQ_MASK);
            ecx = PERFEVTSEL0; /*use Performance Counter 0 to record the event*/
            RTXEN_WRITE_MSR(eax, ecx);
     18a:	31 d2                	xor    %edx,%edx
    {
        if( IS_SET_MSR(perf_counter->op) )
        {
            /*set counter for L2 cache all req*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     18c:	66 31 c0             	xor    %ax,%ax
     18f:	05 24 30 01 00       	add    $0x13024,%eax
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L2_ALLREQ_EVENT, L2_ALLREQ_MASK);
            ecx = PERFEVTSEL0; /*use Performance Counter 0 to record the event*/
            RTXEN_WRITE_MSR(eax, ecx);
     194:	0f 30                	wrmsr  
            /*set counter for L2 cache all miss*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     196:	48 83 fe 01          	cmp    $0x1,%rsi
     19a:	48 89 73 08          	mov    %rsi,0x8(%rbx)
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L2_ALLMISS_EVENT, L2_ALLMISS_MASK);        
            ecx = PERFEVTSEL1;
            RTXEN_WRITE_MSR(eax, ecx);
     19e:	b1 87                	mov    $0x87,%cl
            SET_EVENT_MASK(eax, L2_ALLREQ_EVENT, L2_ALLREQ_MASK);
            ecx = PERFEVTSEL0; /*use Performance Counter 0 to record the event*/
            RTXEN_WRITE_MSR(eax, ecx);
            /*set counter for L2 cache all miss*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     1a0:	19 c0                	sbb    %eax,%eax
     1a2:	66 31 c0             	xor    %ax,%ax
     1a5:	05 24 20 01 00       	add    $0x12024,%eax
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L2_ALLMISS_EVENT, L2_ALLMISS_MASK);        
            ecx = PERFEVTSEL1;
            RTXEN_WRITE_MSR(eax, ecx);
     1aa:	0f 30                	wrmsr  
            dprintk(XENLOG_INFO, "L2 SET MSR PMC0 and PMC1\n");
     1ac:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 1b3 <setread_perf_counter+0x173>
     1b3:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 1ba <setread_perf_counter+0x17a>
     1ba:	31 c0                	xor    %eax,%eax
     1bc:	66 ba a8 04          	mov    $0x4a8,%dx
     1c0:	e8 00 00 00 00       	callq  1c5 <setread_perf_counter+0x185>
     1c5:	8b 03                	mov    (%rbx),%eax
        }
        if( IS_READ_MSR(perf_counter->op) )
     1c7:	a8 01                	test   $0x1,%al
     1c9:	0f 85 81 02 00 00    	jne    450 <setread_perf_counter+0x410>
            RTXEN_READ_MSR(ecx, eax, edx);
            l2_miss = ( ((uint64_t) edx << 32) | eax );
            /*set perf_counter to return*/
            perf_counter->out[cpu_id].l2_miss = l2_miss;
            perf_counter->out[cpu_id].l2_all  = l2_all;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L2 cache miss:%llu\t cache all req:%llu\n", smp_processor_id(),0, (unsigned long long) l2_miss,(unsigned long long) l2_all);
     1cf:	48 8b 73 08          	mov    0x8(%rbx),%rsi
        }
    }

    if( (perf_counter->in & CACHE_LEVEL_L3_MASK) == CACHE_LEVEL_L3 )
     1d3:	f7 c6 00 00 08 00    	test   $0x80000,%esi
     1d9:	0f 84 db 00 00 00    	je     2ba <setread_perf_counter+0x27a>
    {
        if( IS_SET_MSR(perf_counter->op) )
     1df:	8b 03                	mov    (%rbx),%eax
     1e1:	a8 02                	test   $0x2,%al
     1e3:	0f 84 cd 00 00 00    	je     2b6 <setread_perf_counter+0x276>
        {
            /*set counter for L3 cache all req*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     1e9:	49 bd 00 00 00 00 02 	movabs $0x200000000,%r13
     1f0:	00 00 00 
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L3_ALLREQ_EVENT, L3_ALLREQ_MASK);
            ecx = PERFEVTSEL2; /*use Performance Counter 2 to record the event*/
            dprintk(XENLOG_INFO,"Before WRMSR: eax=%#010x, ecx=%#010x\n", eax, ecx);
     1f3:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 1fa <setread_perf_counter+0x1ba>
     1fa:	41 b8 88 01 00 00    	mov    $0x188,%r8d
    {
        if( IS_SET_MSR(perf_counter->op) )
        {
            /*set counter for L3 cache all req*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     200:	4c 21 ee             	and    %r13,%rsi
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L3_ALLREQ_EVENT, L3_ALLREQ_MASK);
            ecx = PERFEVTSEL2; /*use Performance Counter 2 to record the event*/
            dprintk(XENLOG_INFO,"Before WRMSR: eax=%#010x, ecx=%#010x\n", eax, ecx);
     203:	ba cb 04 00 00       	mov    $0x4cb,%edx
    {
        if( IS_SET_MSR(perf_counter->op) )
        {
            /*set counter for L3 cache all req*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     208:	48 83 fe 01          	cmp    $0x1,%rsi
     20c:	48 89 73 08          	mov    %rsi,0x8(%rbx)
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L3_ALLREQ_EVENT, L3_ALLREQ_MASK);
            ecx = PERFEVTSEL2; /*use Performance Counter 2 to record the event*/
            dprintk(XENLOG_INFO,"Before WRMSR: eax=%#010x, ecx=%#010x\n", eax, ecx);
     210:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 217 <setread_perf_counter+0x1d7>
    {
        if( IS_SET_MSR(perf_counter->op) )
        {
            /*set counter for L3 cache all req*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     217:	45 19 e4             	sbb    %r12d,%r12d
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L3_ALLREQ_EVENT, L3_ALLREQ_MASK);
            ecx = PERFEVTSEL2; /*use Performance Counter 2 to record the event*/
            dprintk(XENLOG_INFO,"Before WRMSR: eax=%#010x, ecx=%#010x\n", eax, ecx);
     21a:	31 c0                	xor    %eax,%eax
            RTXEN_WRITE_MSR(eax, ecx);
     21c:	45 31 f6             	xor    %r14d,%r14d
    {
        if( IS_SET_MSR(perf_counter->op) )
        {
            /*set counter for L3 cache all req*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     21f:	66 45 31 e4          	xor    %r12w,%r12w
     223:	41 81 c4 2e 4f 01 00 	add    $0x14f2e,%r12d
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L3_ALLREQ_EVENT, L3_ALLREQ_MASK);
            ecx = PERFEVTSEL2; /*use Performance Counter 2 to record the event*/
            dprintk(XENLOG_INFO,"Before WRMSR: eax=%#010x, ecx=%#010x\n", eax, ecx);
     22a:	44 89 e1             	mov    %r12d,%ecx
     22d:	e8 00 00 00 00       	callq  232 <setread_perf_counter+0x1f2>
            RTXEN_WRITE_MSR(eax, ecx);
     232:	b9 88 01 00 00       	mov    $0x188,%ecx
     237:	44 89 e0             	mov    %r12d,%eax
     23a:	44 89 f2             	mov    %r14d,%edx
     23d:	0f 30                	wrmsr  
            dprintk(XENLOG_INFO,"After WRMSR: eax=%#010x, ecx=%#010x\n", eax, ecx);
     23f:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 246 <setread_perf_counter+0x206>
     246:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 24d <setread_perf_counter+0x20d>
     24d:	44 89 e1             	mov    %r12d,%ecx
     250:	41 b8 88 01 00 00    	mov    $0x188,%r8d
     256:	31 c0                	xor    %eax,%eax
     258:	66 ba cd 04          	mov    $0x4cd,%dx
     25c:	e8 00 00 00 00       	callq  261 <setread_perf_counter+0x221>
            dprintk(XENLOG_INFO, "L3 SET MSR PMC2\n");
     261:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 268 <setread_perf_counter+0x228>
     268:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 26f <setread_perf_counter+0x22f>
     26f:	31 c0                	xor    %eax,%eax
     271:	ba ce 04 00 00       	mov    $0x4ce,%edx
     276:	e8 00 00 00 00       	callq  27b <setread_perf_counter+0x23b>
            /*set counter for L3 cache all miss*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     27b:	4c 23 6b 08          	and    0x8(%rbx),%r13
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L3_ALLMISS_EVENT, L3_ALLMISS_MASK);        
            ecx = PERFEVTSEL3;
            RTXEN_WRITE_MSR(eax, ecx);
     27f:	b9 89 01 00 00       	mov    $0x189,%ecx
     284:	44 89 f2             	mov    %r14d,%edx
            RTXEN_WRITE_MSR(eax, ecx);
            dprintk(XENLOG_INFO,"After WRMSR: eax=%#010x, ecx=%#010x\n", eax, ecx);
            dprintk(XENLOG_INFO, "L3 SET MSR PMC2\n");
            /*set counter for L3 cache all miss*/
            eax = 0;
            if( IS_COUNT_EVENT_PVL_USR(perf_counter->in) )
     287:	49 83 fd 01          	cmp    $0x1,%r13
     28b:	4c 89 6b 08          	mov    %r13,0x8(%rbx)
     28f:	19 c0                	sbb    %eax,%eax
     291:	66 31 c0             	xor    %ax,%ax
     294:	05 2e 41 01 00       	add    $0x1412e,%eax
                SET_MSR_USR_BIT(eax);
            if( IS_COUNT_EVENT_PVL_OS(perf_counter->in) )
                SET_MSR_OS_BIT(eax);
            SET_EVENT_MASK(eax, L3_ALLMISS_EVENT, L3_ALLMISS_MASK);        
            ecx = PERFEVTSEL3;
            RTXEN_WRITE_MSR(eax, ecx);
     299:	0f 30                	wrmsr  
            dprintk(XENLOG_INFO, "L3 SET MSR PMC3\n");
     29b:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 2a2 <setread_perf_counter+0x262>
     2a2:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 2a9 <setread_perf_counter+0x269>
     2a9:	31 c0                	xor    %eax,%eax
     2ab:	66 ba d8 04          	mov    $0x4d8,%dx
     2af:	e8 00 00 00 00       	callq  2b4 <setread_perf_counter+0x274>
     2b4:	8b 03                	mov    (%rbx),%eax
        }
        if( IS_READ_MSR(perf_counter->op) )
     2b6:	a8 01                	test   $0x1,%al
     2b8:	75 26                	jne    2e0 <setread_perf_counter+0x2a0>
            perf_counter->out[cpu_id].l3_miss = l3_miss;
            perf_counter->out[cpu_id].l3_all  = l3_all;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L3 cache miss:%llu\t cache all req:%llu\n", smp_processor_id(),0, (unsigned long long) l3_miss,(unsigned long long) l3_all);
        }
    }
}
     2ba:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
     2bf:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
     2c4:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
     2c9:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
     2ce:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
     2d3:	48 83 c4 38          	add    $0x38,%rsp
     2d7:	c3                   	retq   
     2d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
     2df:	00 
        {
            /*read counter of L3 cache all req*/        
            ecx = PMC2;
            eax = 0;
            edx = 0;
            dprintk(XENLOG_INFO,"RDMSR: ecx=%#010x\n", ecx);
     2e0:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 2e7 <setread_perf_counter+0x2a7>
     2e7:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 2ee <setread_perf_counter+0x2ae>
     2ee:	b9 c2 00 00 00       	mov    $0xc2,%ecx
     2f3:	ba e0 04 00 00       	mov    $0x4e0,%edx
     2f8:	31 c0                	xor    %eax,%eax
     2fa:	e8 00 00 00 00       	callq  2ff <setread_perf_counter+0x2bf>
            RTXEN_READ_MSR(ecx, eax, edx);
     2ff:	b9 c2 00 00 00       	mov    $0xc2,%ecx
     304:	0f 32                	rdmsr  
            l3_all = ( ((uint64_t) edx << 32) | eax );
     306:	48 89 d6             	mov    %rdx,%rsi
     309:	89 c0                	mov    %eax,%eax
            /*read counter of L3 cache all miss*/
            ecx = PMC3;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
     30b:	b1 c3                	mov    $0xc3,%cl
            ecx = PMC2;
            eax = 0;
            edx = 0;
            dprintk(XENLOG_INFO,"RDMSR: ecx=%#010x\n", ecx);
            RTXEN_READ_MSR(ecx, eax, edx);
            l3_all = ( ((uint64_t) edx << 32) | eax );
     30d:	48 c1 e6 20          	shl    $0x20,%rsi
     311:	48 09 c6             	or     %rax,%rsi
            /*read counter of L3 cache all miss*/
            ecx = PMC3;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
     314:	0f 32                	rdmsr  
            l3_miss = ( ((uint64_t) edx << 32) | eax );
     316:	49 89 d1             	mov    %rdx,%r9
     319:	89 c0                	mov    %eax,%eax
            /*set perf_counter to return*/
            perf_counter->out[cpu_id].l3_miss = l3_miss;
     31b:	48 63 ed             	movslq %ebp,%rbp
            /*read counter of L3 cache all miss*/
            ecx = PMC3;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l3_miss = ( ((uint64_t) edx << 32) | eax );
     31e:	49 c1 e1 20          	shl    $0x20,%r9
            /*set perf_counter to return*/
            perf_counter->out[cpu_id].l3_miss = l3_miss;
            perf_counter->out[cpu_id].l3_all  = l3_all;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L3 cache miss:%llu\t cache all req:%llu\n", smp_processor_id(),0, (unsigned long long) l3_miss,(unsigned long long) l3_all);
     322:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 329 <setread_perf_counter+0x2e9>
     329:	45 31 c0             	xor    %r8d,%r8d
            /*read counter of L3 cache all miss*/
            ecx = PMC3;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l3_miss = ( ((uint64_t) edx << 32) | eax );
     32c:	49 09 c1             	or     %rax,%r9
            /*set perf_counter to return*/
            perf_counter->out[cpu_id].l3_miss = l3_miss;
     32f:	48 8d 44 ad 05       	lea    0x5(%rbp,%rbp,4),%rax
            perf_counter->out[cpu_id].l3_all  = l3_all;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L3 cache miss:%llu\t cache all req:%llu\n", smp_processor_id(),0, (unsigned long long) l3_miss,(unsigned long long) l3_all);
     334:	ba ec 04 00 00       	mov    $0x4ec,%edx
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l3_miss = ( ((uint64_t) edx << 32) | eax );
            /*set perf_counter to return*/
            perf_counter->out[cpu_id].l3_miss = l3_miss;
     339:	48 c1 e0 04          	shl    $0x4,%rax
     33d:	48 01 c3             	add    %rax,%rbx
     340:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
            perf_counter->out[cpu_id].l3_all  = l3_all;
     347:	48 89 33             	mov    %rsi,(%rbx)
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l3_miss = ( ((uint64_t) edx << 32) | eax );
            /*set perf_counter to return*/
            perf_counter->out[cpu_id].l3_miss = l3_miss;
     34a:	4c 89 4b 08          	mov    %r9,0x8(%rbx)
     34e:	48 21 e0             	and    %rsp,%rax
            perf_counter->out[cpu_id].l3_all  = l3_all;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L3 cache miss:%llu\t cache all req:%llu\n", smp_processor_id(),0, (unsigned long long) l3_miss,(unsigned long long) l3_all);
     351:	8b 88 e0 7f 00 00    	mov    0x7fe0(%rax),%ecx
     357:	48 89 34 24          	mov    %rsi,(%rsp)
     35b:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 362 <setread_perf_counter+0x322>
     362:	31 c0                	xor    %eax,%eax
     364:	e8 00 00 00 00       	callq  369 <setread_perf_counter+0x329>
     369:	e9 4c ff ff ff       	jmpq   2ba <setread_perf_counter+0x27a>
     36e:	66 90                	xchg   %ax,%ax
        {
            /*read counter of L1I cache all hit*/
            ecx = PMC0;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
     370:	b9 c1 00 00 00       	mov    $0xc1,%ecx
     375:	0f 32                	rdmsr  
            l1I_hit = ( ((uint64_t) edx << 32) | eax );
     377:	48 89 d6             	mov    %rdx,%rsi
     37a:	89 c0                	mov    %eax,%eax
            /*read counter of L1I cache all miss*/
            ecx = PMC1;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
     37c:	b1 c2                	mov    $0xc2,%cl
            /*read counter of L1I cache all hit*/
            ecx = PMC0;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l1I_hit = ( ((uint64_t) edx << 32) | eax );
     37e:	48 c1 e6 20          	shl    $0x20,%rsi
     382:	48 09 c6             	or     %rax,%rsi
            /*read counter of L1I cache all miss*/
            ecx = PMC1;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
     385:	0f 32                	rdmsr  
            l1I_miss = ( ((uint64_t) edx << 32) | eax );
     387:	49 89 d1             	mov    %rdx,%r9
     38a:	89 c0                	mov    %eax,%eax
            perf_counter->out[cpu_id].l1I_miss = l1I_miss;
            perf_counter->out[cpu_id].l1I_hit = l1I_hit;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L1 Instruction cache miss:%llu\t cache hit:%llu\n", cpu_id,0, (unsigned long long) l1I_miss,(unsigned long long) l1I_hit);
     38c:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 393 <setread_perf_counter+0x353>
            /*read counter of L1I cache all miss*/
            ecx = PMC1;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l1I_miss = ( ((uint64_t) edx << 32) | eax );
     393:	49 c1 e1 20          	shl    $0x20,%r9
            perf_counter->out[cpu_id].l1I_miss = l1I_miss;
            perf_counter->out[cpu_id].l1I_hit = l1I_hit;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L1 Instruction cache miss:%llu\t cache hit:%llu\n", cpu_id,0, (unsigned long long) l1I_miss,(unsigned long long) l1I_hit);
     397:	45 31 c0             	xor    %r8d,%r8d
     39a:	89 e9                	mov    %ebp,%ecx
            /*read counter of L1I cache all miss*/
            ecx = PMC1;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l1I_miss = ( ((uint64_t) edx << 32) | eax );
     39c:	49 09 c1             	or     %rax,%r9
            perf_counter->out[cpu_id].l1I_miss = l1I_miss;
     39f:	48 63 c5             	movslq %ebp,%rax
            perf_counter->out[cpu_id].l1I_hit = l1I_hit;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L1 Instruction cache miss:%llu\t cache hit:%llu\n", cpu_id,0, (unsigned long long) l1I_miss,(unsigned long long) l1I_hit);
     3a2:	ba 52 04 00 00       	mov    $0x452,%edx
            ecx = PMC1;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l1I_miss = ( ((uint64_t) edx << 32) | eax );
            perf_counter->out[cpu_id].l1I_miss = l1I_miss;
     3a7:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
     3ab:	48 c1 e0 04          	shl    $0x4,%rax
     3af:	48 01 d8             	add    %rbx,%rax
     3b2:	4c 89 48 18          	mov    %r9,0x18(%rax)
            perf_counter->out[cpu_id].l1I_hit = l1I_hit;
     3b6:	48 89 70 20          	mov    %rsi,0x20(%rax)
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L1 Instruction cache miss:%llu\t cache hit:%llu\n", cpu_id,0, (unsigned long long) l1I_miss,(unsigned long long) l1I_hit);
     3ba:	31 c0                	xor    %eax,%eax
     3bc:	48 89 34 24          	mov    %rsi,(%rsp)
     3c0:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 3c7 <setread_perf_counter+0x387>
     3c7:	e8 00 00 00 00       	callq  3cc <setread_perf_counter+0x38c>
     3cc:	e9 0e fd ff ff       	jmpq   df <setread_perf_counter+0x9f>
     3d1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
        {
            /*read counter of L1 Data cache all req*/
            ecx = PMC0;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
     3d8:	b9 c1 00 00 00       	mov    $0xc1,%ecx
     3dd:	0f 32                	rdmsr  
            l1D_all = ( ((uint64_t) edx << 32) | eax );
     3df:	49 89 d1             	mov    %rdx,%r9
     3e2:	89 c0                	mov    %eax,%eax
            /*read counter of L1ID cache all load miss*/
            ecx = PMC1;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
     3e4:	b1 c2                	mov    $0xc2,%cl
            /*read counter of L1 Data cache all req*/
            ecx = PMC0;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l1D_all = ( ((uint64_t) edx << 32) | eax );
     3e6:	49 c1 e1 20          	shl    $0x20,%r9
     3ea:	49 09 c1             	or     %rax,%r9
            /*read counter of L1ID cache all load miss*/
            ecx = PMC1;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
     3ed:	0f 32                	rdmsr  
            l1D_ldmiss = ( ((uint64_t) edx << 32) | eax );
     3ef:	48 89 d6             	mov    %rdx,%rsi
     3f2:	89 c0                	mov    %eax,%eax
     3f4:	48 c1 e6 20          	shl    $0x20,%rsi
     3f8:	48 09 c6             	or     %rax,%rsi
            /*read counter of L1D cache all store miss*/
            ecx = PMC2;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
     3fb:	0f 32                	rdmsr  
            l1D_stmiss = ( ((uint64_t) edx << 32) | eax );
     3fd:	48 c1 e2 20          	shl    $0x20,%rdx
     401:	89 c0                	mov    %eax,%eax
            perf_counter->out[cpu_id].l1D_all = l1D_all;
            perf_counter->out[cpu_id].l1D_ldmiss = l1D_ldmiss;
            perf_counter->out[cpu_id].l1D_stmiss = l1D_stmiss;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L1 Data cache all req:%llu\t cacheload miss:%llu cache store miss %llu\n", cpu_id,0, (unsigned long long) l1D_all,(unsigned long long) l1D_ldmiss, (unsigned long long) l1D_stmiss);
     403:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 40a <setread_perf_counter+0x3ca>
            /*read counter of L1D cache all store miss*/
            ecx = PMC2;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l1D_stmiss = ( ((uint64_t) edx << 32) | eax );
     40a:	48 09 c2             	or     %rax,%rdx
            perf_counter->out[cpu_id].l1D_all = l1D_all;
     40d:	48 63 c5             	movslq %ebp,%rax
            perf_counter->out[cpu_id].l1D_ldmiss = l1D_ldmiss;
            perf_counter->out[cpu_id].l1D_stmiss = l1D_stmiss;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L1 Data cache all req:%llu\t cacheload miss:%llu cache store miss %llu\n", cpu_id,0, (unsigned long long) l1D_all,(unsigned long long) l1D_ldmiss, (unsigned long long) l1D_stmiss);
     410:	45 31 c0             	xor    %r8d,%r8d
            ecx = PMC2;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l1D_stmiss = ( ((uint64_t) edx << 32) | eax );
            perf_counter->out[cpu_id].l1D_all = l1D_all;
     413:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
            perf_counter->out[cpu_id].l1D_ldmiss = l1D_ldmiss;
            perf_counter->out[cpu_id].l1D_stmiss = l1D_stmiss;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L1 Data cache all req:%llu\t cacheload miss:%llu cache store miss %llu\n", cpu_id,0, (unsigned long long) l1D_all,(unsigned long long) l1D_ldmiss, (unsigned long long) l1D_stmiss);
     417:	89 e9                	mov    %ebp,%ecx
            ecx = PMC2;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l1D_stmiss = ( ((uint64_t) edx << 32) | eax );
            perf_counter->out[cpu_id].l1D_all = l1D_all;
     419:	48 c1 e0 04          	shl    $0x4,%rax
     41d:	48 01 d8             	add    %rbx,%rax
     420:	4c 89 48 28          	mov    %r9,0x28(%rax)
            perf_counter->out[cpu_id].l1D_ldmiss = l1D_ldmiss;
     424:	48 89 70 30          	mov    %rsi,0x30(%rax)
            perf_counter->out[cpu_id].l1D_stmiss = l1D_stmiss;
     428:	48 89 50 38          	mov    %rdx,0x38(%rax)
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L1 Data cache all req:%llu\t cacheload miss:%llu cache store miss %llu\n", cpu_id,0, (unsigned long long) l1D_all,(unsigned long long) l1D_ldmiss, (unsigned long long) l1D_stmiss);
     42c:	48 89 34 24          	mov    %rsi,(%rsp)
     430:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 437 <setread_perf_counter+0x3f7>
     437:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
     43c:	31 c0                	xor    %eax,%eax
     43e:	ba 8e 04 00 00       	mov    $0x48e,%edx
     443:	e8 00 00 00 00       	callq  448 <setread_perf_counter+0x408>
     448:	e9 13 fd ff ff       	jmpq   160 <setread_perf_counter+0x120>
     44d:	0f 1f 00             	nopl   (%rax)
        {
            /*read counter of L2 cache all req*/        
            ecx = PMC0;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
     450:	b9 c1 00 00 00       	mov    $0xc1,%ecx
     455:	0f 32                	rdmsr  
            l2_all = ( ((uint64_t) edx << 32) | eax );
     457:	48 89 d6             	mov    %rdx,%rsi
     45a:	89 c0                	mov    %eax,%eax
            /*read counter of L2 cache all miss*/
            ecx = PMC1;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
     45c:	b1 c2                	mov    $0xc2,%cl
            /*read counter of L2 cache all req*/        
            ecx = PMC0;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l2_all = ( ((uint64_t) edx << 32) | eax );
     45e:	48 c1 e6 20          	shl    $0x20,%rsi
     462:	48 09 c6             	or     %rax,%rsi
            /*read counter of L2 cache all miss*/
            ecx = PMC1;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
     465:	0f 32                	rdmsr  
            l2_miss = ( ((uint64_t) edx << 32) | eax );
     467:	49 89 d1             	mov    %rdx,%r9
     46a:	89 c0                	mov    %eax,%eax
            /*set perf_counter to return*/
            perf_counter->out[cpu_id].l2_miss = l2_miss;
            perf_counter->out[cpu_id].l2_all  = l2_all;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L2 cache miss:%llu\t cache all req:%llu\n", smp_processor_id(),0, (unsigned long long) l2_miss,(unsigned long long) l2_all);
     46c:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 473 <setread_perf_counter+0x433>
            /*read counter of L2 cache all miss*/
            ecx = PMC1;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l2_miss = ( ((uint64_t) edx << 32) | eax );
     473:	49 c1 e1 20          	shl    $0x20,%r9
            /*set perf_counter to return*/
            perf_counter->out[cpu_id].l2_miss = l2_miss;
            perf_counter->out[cpu_id].l2_all  = l2_all;
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L2 cache miss:%llu\t cache all req:%llu\n", smp_processor_id(),0, (unsigned long long) l2_miss,(unsigned long long) l2_all);
     477:	45 31 c0             	xor    %r8d,%r8d
     47a:	ba bb 04 00 00       	mov    $0x4bb,%edx
            /*read counter of L2 cache all miss*/
            ecx = PMC1;
            eax = 0;
            edx = 0;
            RTXEN_READ_MSR(ecx, eax, edx);
            l2_miss = ( ((uint64_t) edx << 32) | eax );
     47f:	49 09 c1             	or     %rax,%r9
            /*set perf_counter to return*/
            perf_counter->out[cpu_id].l2_miss = l2_miss;
     482:	48 63 c5             	movslq %ebp,%rax
     485:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
     489:	48 c1 e0 04          	shl    $0x4,%rax
     48d:	48 01 d8             	add    %rbx,%rax
     490:	4c 89 48 48          	mov    %r9,0x48(%rax)
            perf_counter->out[cpu_id].l2_all  = l2_all;
     494:	48 89 70 40          	mov    %rsi,0x40(%rax)
     498:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
     49f:	48 21 e0             	and    %rsp,%rax
            dprintk(XENLOG_INFO, "CPU#%u, In %ds, L2 cache miss:%llu\t cache all req:%llu\n", smp_processor_id(),0, (unsigned long long) l2_miss,(unsigned long long) l2_all);
     4a2:	8b 88 e0 7f 00 00    	mov    0x7fe0(%rax),%ecx
     4a8:	48 89 34 24          	mov    %rsi,(%rsp)
     4ac:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 4b3 <setread_perf_counter+0x473>
     4b3:	31 c0                	xor    %eax,%eax
     4b5:	e8 00 00 00 00       	callq  4ba <setread_perf_counter+0x47a>
     4ba:	e9 10 fd ff ff       	jmpq   1cf <setread_perf_counter+0x18f>
     4bf:	90                   	nop

00000000000004c0 <__mfn_valid>:

l2_pgentry_t *compat_idle_pg_table_l2;

int __mfn_valid(unsigned long mfn)
{
    return likely(mfn < max_page) &&
     4c0:	48 39 3d 00 00 00 00 	cmp    %rdi,0x0(%rip)        # 4c7 <__mfn_valid+0x7>
     4c7:	76 3c                	jbe    505 <__mfn_valid+0x45>
     4c9:	48 85 3d 00 00 00 00 	test   %rdi,0x0(%rip)        # 4d0 <__mfn_valid+0x10>
     4d0:	75 36                	jne    508 <__mfn_valid+0x48>
extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
     4d2:	48 89 f8             	mov    %rdi,%rax
     4d5:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 4dc <__mfn_valid+0x1c>
     4dc:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 4e2 <__mfn_valid+0x22>

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
     4e2:	48 23 3d 00 00 00 00 	and    0x0(%rip),%rdi        # 4e9 <__mfn_valid+0x29>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
     4e9:	48 d3 e8             	shr    %cl,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
     4ec:	48 09 f8             	or     %rdi,%rax
           likely(!(mfn & pfn_hole_mask)) &&
           likely(test_bit(pfn_to_pdx(mfn) / PDX_GROUP_COUNT,
     4ef:	48 c1 e8 10          	shr    $0x10,%rax

static inline int variable_test_bit(int nr, const volatile void *addr)
{
    int oldbit;

    asm volatile (
     4f3:	0f a3 05 00 00 00 00 	bt     %eax,0x0(%rip)        # 4fa <__mfn_valid+0x3a>
     4fa:	19 c0                	sbb    %eax,%eax
l2_pgentry_t __attribute__ ((__section__ (".bss.page_aligned")))
    l2_bootmap[L2_PAGETABLE_ENTRIES];

l2_pgentry_t *compat_idle_pg_table_l2;

int __mfn_valid(unsigned long mfn)
     4fc:	85 c0                	test   %eax,%eax
{
    return likely(mfn < max_page) &&
     4fe:	0f 95 c0             	setne  %al
     501:	0f b6 c0             	movzbl %al,%eax
     504:	c3                   	retq   
     505:	31 c0                	xor    %eax,%eax
     507:	c3                   	retq   
     508:	31 c0                	xor    %eax,%eax
           likely(!(mfn & pfn_hole_mask)) &&
           likely(test_bit(pfn_to_pdx(mfn) / PDX_GROUP_COUNT,
                           pdx_group_valid));
}
     50a:	c3                   	retq   
     50b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000000510 <virt_to_xen_l3e>:

l3_pgentry_t *virt_to_xen_l3e(unsigned long v)
{
     510:	48 83 ec 18          	sub    $0x18,%rsp
    l4_pgentry_t *pl4e;

    pl4e = &idle_pg_table[l4_table_offset(v)];
     514:	48 89 f8             	mov    %rdi,%rax
     517:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 51d <virt_to_xen_l3e+0xd>
           likely(test_bit(pfn_to_pdx(mfn) / PDX_GROUP_COUNT,
                           pdx_group_valid));
}

l3_pgentry_t *virt_to_xen_l3e(unsigned long v)
{
     51d:	48 89 6c 24 08       	mov    %rbp,0x8(%rsp)
    l4_pgentry_t *pl4e;

    pl4e = &idle_pg_table[l4_table_offset(v)];
     522:	48 c1 e8 24          	shr    $0x24,%rax
     526:	48 8d 2d 00 00 00 00 	lea    0x0(%rip),%rbp        # 52d <virt_to_xen_l3e+0x1d>
     52d:	25 f8 0f 00 00       	and    $0xff8,%eax
           likely(test_bit(pfn_to_pdx(mfn) / PDX_GROUP_COUNT,
                           pdx_group_valid));
}

l3_pgentry_t *virt_to_xen_l3e(unsigned long v)
{
     532:	48 89 1c 24          	mov    %rbx,(%rsp)
     536:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
    l4_pgentry_t *pl4e;

    pl4e = &idle_pg_table[l4_table_offset(v)];
     53b:	48 01 c5             	add    %rax,%rbp
           likely(test_bit(pfn_to_pdx(mfn) / PDX_GROUP_COUNT,
                           pdx_group_valid));
}

l3_pgentry_t *virt_to_xen_l3e(unsigned long v)
{
     53e:	48 89 fb             	mov    %rdi,%rbx
    l4_pgentry_t *pl4e;

    pl4e = &idle_pg_table[l4_table_offset(v)];
    if ( !(l4e_get_flags(*pl4e) & _PAGE_PRESENT) )
     541:	48 8b 45 00          	mov    0x0(%rbp),%rax
     545:	a8 01                	test   $0x1,%al
     547:	74 57                	je     5a0 <virt_to_xen_l3e+0x90>
            return NULL;
        clear_page(pl3e);
        l4e_write(pl4e, l4e_from_paddr(__pa(pl3e), __PAGE_HYPERVISOR));
    }
    
    return l4e_to_l3e(*pl4e) + l3_table_offset(v);
     549:	48 ba 00 f0 ff ff ff 	movabs $0xffffffffff000,%rdx
     550:	ff 0f 00 
     553:	48 c1 eb 1b          	shr    $0x1b,%rbx
     557:	48 21 c2             	and    %rax,%rdx
     55a:	81 e3 f8 0f 00 00    	and    $0xff8,%ebx
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     560:	48 89 d0             	mov    %rdx,%rax
     563:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 56a <virt_to_xen_l3e+0x5a>

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     56a:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 571 <virt_to_xen_l3e+0x61>
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     571:	48 d3 e8             	shr    %cl,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     574:	48 09 d0             	or     %rdx,%rax
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
     577:	48 ba 00 00 00 00 00 	movabs $0xffff830000000000,%rdx
     57e:	83 ff ff 
     581:	48 01 d0             	add    %rdx,%rax
     584:	48 01 d8             	add    %rbx,%rax
}
     587:	48 8b 1c 24          	mov    (%rsp),%rbx
     58b:	48 8b 6c 24 08       	mov    0x8(%rsp),%rbp
     590:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
     595:	48 83 c4 18          	add    $0x18,%rsp
     599:	c3                   	retq   
     59a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    l4_pgentry_t *pl4e;

    pl4e = &idle_pg_table[l4_table_offset(v)];
    if ( !(l4e_get_flags(*pl4e) & _PAGE_PRESENT) )
    {
        l3_pgentry_t *pl3e = alloc_xen_pagetable();
     5a0:	e8 00 00 00 00       	callq  5a5 <virt_to_xen_l3e+0x95>
     5a5:	49 89 c4             	mov    %rax,%r12

        if ( !pl3e )
            return NULL;
     5a8:	31 c0                	xor    %eax,%eax
    pl4e = &idle_pg_table[l4_table_offset(v)];
    if ( !(l4e_get_flags(*pl4e) & _PAGE_PRESENT) )
    {
        l3_pgentry_t *pl3e = alloc_xen_pagetable();

        if ( !pl3e )
     5aa:	4d 85 e4             	test   %r12,%r12
     5ad:	74 d8                	je     587 <virt_to_xen_l3e+0x77>
            return NULL;
        clear_page(pl3e);
     5af:	4c 89 e7             	mov    %r12,%rdi
     5b2:	e8 00 00 00 00       	callq  5b7 <virt_to_xen_l3e+0xa7>

static inline unsigned long __virt_to_maddr(unsigned long va)
{
    ASSERT(va >= XEN_VIRT_START);
    ASSERT(va < DIRECTMAP_VIRT_END);
    if ( va >= DIRECTMAP_VIRT_START )
     5b7:	48 b8 ff ff ff ff ff 	movabs $0xffff82ffffffffff,%rax
     5be:	82 ff ff 
     5c1:	49 39 c4             	cmp    %rax,%r12
     5c4:	77 4a                	ja     610 <virt_to_xen_l3e+0x100>
        va -= DIRECTMAP_VIRT_START;
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
     5c6:	48 b8 00 00 00 40 3b 	movabs $0x7d3b40000000,%rax
     5cd:	7d 00 00 
     5d0:	48 03 05 00 00 00 00 	add    0x0(%rip),%rax        # 5d7 <virt_to_xen_l3e+0xc7>
     5d7:	49 01 c4             	add    %rax,%r12
    }
    return (va & ma_va_bottom_mask) |
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
     5da:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 5e0 <virt_to_xen_l3e+0xd0>
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
     5e0:	4c 89 e2             	mov    %r12,%rdx
     5e3:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 5ea <virt_to_xen_l3e+0xda>
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
     5ea:	49 d3 e4             	shl    %cl,%r12
     5ed:	4c 23 25 00 00 00 00 	and    0x0(%rip),%r12        # 5f4 <virt_to_xen_l3e+0xe4>
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
     5f4:	48 83 ca 63          	or     $0x63,%rdx
    return (l3_pgentry_t) { pa | put_pte_flags(flags) };
}
static inline l4_pgentry_t l4e_from_paddr(paddr_t pa, unsigned int flags)
{
    ASSERT((pa & ~(PADDR_MASK & PAGE_MASK)) == 0);
    return (l4_pgentry_t) { pa | put_pte_flags(flags) };
     5f8:	4c 09 e2             	or     %r12,%rdx
build_write_atomic(write_u8_atomic, "b", uint8_t, "q", )
build_write_atomic(write_u16_atomic, "w", uint16_t, "r", )
build_write_atomic(write_u32_atomic, "l", uint32_t, "r", )

build_read_atomic(read_u64_atomic, "q", uint64_t, "=r", )
build_write_atomic(write_u64_atomic, "q", uint64_t, "r", )
     5fb:	48 89 55 00          	mov    %rdx,0x0(%rbp)
     5ff:	48 8b 45 00          	mov    0x0(%rbp),%rax
     603:	e9 41 ff ff ff       	jmpq   549 <virt_to_xen_l3e+0x39>
     608:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
     60f:	00 
static inline unsigned long __virt_to_maddr(unsigned long va)
{
    ASSERT(va >= XEN_VIRT_START);
    ASSERT(va < DIRECTMAP_VIRT_END);
    if ( va >= DIRECTMAP_VIRT_START )
        va -= DIRECTMAP_VIRT_START;
     610:	48 b8 00 00 00 00 00 	movabs $0x7d0000000000,%rax
     617:	7d 00 00 
     61a:	49 01 c4             	add    %rax,%r12
     61d:	eb bb                	jmp    5da <virt_to_xen_l3e+0xca>
     61f:	90                   	nop

0000000000000620 <virt_to_xen_l2e>:
    
    return l4e_to_l3e(*pl4e) + l3_table_offset(v);
}

l2_pgentry_t *virt_to_xen_l2e(unsigned long v)
{
     620:	48 83 ec 18          	sub    $0x18,%rsp
     624:	48 89 1c 24          	mov    %rbx,(%rsp)
     628:	48 89 6c 24 08       	mov    %rbp,0x8(%rsp)
     62d:	48 89 fd             	mov    %rdi,%rbp
     630:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
    l3_pgentry_t *pl3e;

    pl3e = virt_to_xen_l3e(v);
     635:	e8 00 00 00 00       	callq  63a <virt_to_xen_l2e+0x1a>
    if ( !pl3e )
     63a:	48 85 c0             	test   %rax,%rax

l2_pgentry_t *virt_to_xen_l2e(unsigned long v)
{
    l3_pgentry_t *pl3e;

    pl3e = virt_to_xen_l3e(v);
     63d:	48 89 c3             	mov    %rax,%rbx
    if ( !pl3e )
     640:	0f 84 1a 01 00 00    	je     760 <virt_to_xen_l2e+0x140>
        return NULL;

    if ( !(l3e_get_flags(*pl3e) & _PAGE_PRESENT) )
     646:	48 8b 10             	mov    (%rax),%rdx
     649:	48 89 d0             	mov    %rdx,%rax
     64c:	89 d1                	mov    %edx,%ecx
     64e:	48 c1 e8 28          	shr    $0x28,%rax
     652:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
     658:	25 00 f0 ff ff       	and    $0xfffff000,%eax
     65d:	09 c8                	or     %ecx,%eax
     65f:	a8 01                	test   $0x1,%al
     661:	74 65                	je     6c8 <virt_to_xen_l2e+0xa8>
            return NULL;
        clear_page(pl2e);
        l3e_write(pl3e, l3e_from_paddr(__pa(pl2e), __PAGE_HYPERVISOR));
    }

    BUG_ON(l3e_get_flags(*pl3e) & _PAGE_PSE);
     663:	a8 80                	test   $0x80,%al
     665:	0f 85 fc 00 00 00    	jne    767 <virt_to_xen_l2e+0x147>
    return l3e_to_l2e(*pl3e) + l2_table_offset(v);
     66b:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
     672:	ff 0f 00 
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     675:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 67b <virt_to_xen_l2e+0x5b>
     67b:	48 c1 ed 12          	shr    $0x12,%rbp
     67f:	48 21 c2             	and    %rax,%rdx
     682:	81 e5 f8 0f 00 00    	and    $0xff8,%ebp
     688:	48 89 d0             	mov    %rdx,%rax
     68b:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 692 <virt_to_xen_l2e+0x72>

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     692:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 699 <virt_to_xen_l2e+0x79>
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     699:	48 d3 e8             	shr    %cl,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     69c:	48 09 d0             	or     %rdx,%rax
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
     69f:	48 ba 00 00 00 00 00 	movabs $0xffff830000000000,%rdx
     6a6:	83 ff ff 
     6a9:	48 01 d0             	add    %rdx,%rax
     6ac:	48 01 e8             	add    %rbp,%rax
}
     6af:	48 8b 1c 24          	mov    (%rsp),%rbx
     6b3:	48 8b 6c 24 08       	mov    0x8(%rsp),%rbp
     6b8:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
     6bd:	48 83 c4 18          	add    $0x18,%rsp
     6c1:	c3                   	retq   
     6c2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    if ( !pl3e )
        return NULL;

    if ( !(l3e_get_flags(*pl3e) & _PAGE_PRESENT) )
    {
        l2_pgentry_t *pl2e = alloc_xen_pagetable();
     6c8:	e8 00 00 00 00       	callq  6cd <virt_to_xen_l2e+0xad>
     6cd:	49 89 c4             	mov    %rax,%r12

        if ( !pl2e )
            return NULL;
     6d0:	31 c0                	xor    %eax,%eax

    if ( !(l3e_get_flags(*pl3e) & _PAGE_PRESENT) )
    {
        l2_pgentry_t *pl2e = alloc_xen_pagetable();

        if ( !pl2e )
     6d2:	4d 85 e4             	test   %r12,%r12
     6d5:	74 d8                	je     6af <virt_to_xen_l2e+0x8f>
            return NULL;
        clear_page(pl2e);
     6d7:	4c 89 e7             	mov    %r12,%rdi
     6da:	e8 00 00 00 00       	callq  6df <virt_to_xen_l2e+0xbf>

static inline unsigned long __virt_to_maddr(unsigned long va)
{
    ASSERT(va >= XEN_VIRT_START);
    ASSERT(va < DIRECTMAP_VIRT_END);
    if ( va >= DIRECTMAP_VIRT_START )
     6df:	48 b8 ff ff ff ff ff 	movabs $0xffff82ffffffffff,%rax
     6e6:	82 ff ff 
     6e9:	49 39 c4             	cmp    %rax,%r12
     6ec:	77 5a                	ja     748 <virt_to_xen_l2e+0x128>
        va -= DIRECTMAP_VIRT_START;
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
     6ee:	48 b8 00 00 00 40 3b 	movabs $0x7d3b40000000,%rax
     6f5:	7d 00 00 
     6f8:	48 03 05 00 00 00 00 	add    0x0(%rip),%rax        # 6ff <virt_to_xen_l2e+0xdf>
     6ff:	49 01 c4             	add    %rax,%r12
    }
    return (va & ma_va_bottom_mask) |
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
     702:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 708 <virt_to_xen_l2e+0xe8>
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
     708:	4c 89 e2             	mov    %r12,%rdx
     70b:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 712 <virt_to_xen_l2e+0xf2>
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
     712:	49 d3 e4             	shl    %cl,%r12
     715:	4c 23 25 00 00 00 00 	and    0x0(%rip),%r12        # 71c <virt_to_xen_l2e+0xfc>
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
     71c:	48 83 ca 63          	or     $0x63,%rdx
    return (l2_pgentry_t) { pa | put_pte_flags(flags) };
}
static inline l3_pgentry_t l3e_from_paddr(paddr_t pa, unsigned int flags)
{
    ASSERT((pa & ~(PADDR_MASK & PAGE_MASK)) == 0);
    return (l3_pgentry_t) { pa | put_pte_flags(flags) };
     720:	4c 09 e2             	or     %r12,%rdx
     723:	48 89 13             	mov    %rdx,(%rbx)
     726:	48 8b 13             	mov    (%rbx),%rdx
     729:	48 89 d0             	mov    %rdx,%rax
     72c:	89 d1                	mov    %edx,%ecx
     72e:	48 c1 e8 28          	shr    $0x28,%rax
     732:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
     738:	25 00 f0 ff ff       	and    $0xfffff000,%eax
     73d:	09 c8                	or     %ecx,%eax
     73f:	e9 1f ff ff ff       	jmpq   663 <virt_to_xen_l2e+0x43>
     744:	0f 1f 40 00          	nopl   0x0(%rax)
static inline unsigned long __virt_to_maddr(unsigned long va)
{
    ASSERT(va >= XEN_VIRT_START);
    ASSERT(va < DIRECTMAP_VIRT_END);
    if ( va >= DIRECTMAP_VIRT_START )
        va -= DIRECTMAP_VIRT_START;
     748:	48 b8 00 00 00 00 00 	movabs $0x7d0000000000,%rax
     74f:	7d 00 00 
     752:	49 01 c4             	add    %rax,%r12
     755:	eb ab                	jmp    702 <virt_to_xen_l2e+0xe2>
     757:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     75e:	00 00 
{
    l3_pgentry_t *pl3e;

    pl3e = virt_to_xen_l3e(v);
    if ( !pl3e )
        return NULL;
     760:	31 c0                	xor    %eax,%eax
     762:	e9 48 ff ff ff       	jmpq   6af <virt_to_xen_l2e+0x8f>
            return NULL;
        clear_page(pl2e);
        l3e_write(pl3e, l3e_from_paddr(__pa(pl2e), __PAGE_HYPERVISOR));
    }

    BUG_ON(l3e_get_flags(*pl3e) & _PAGE_PSE);
     767:	0f 0b                	ud2    
     769:	c2 b2 01             	retq   $0x1b2
     76c:	bc 00 00 00 00       	mov    $0x0,%esp
     771:	e9 f5 fe ff ff       	jmpq   66b <virt_to_xen_l2e+0x4b>
     776:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
     77d:	00 00 00 

0000000000000780 <virt_to_xen_l1e>:
    return l3e_to_l2e(*pl3e) + l2_table_offset(v);
}

l1_pgentry_t *virt_to_xen_l1e(unsigned long v)
{
     780:	48 83 ec 18          	sub    $0x18,%rsp
     784:	48 89 1c 24          	mov    %rbx,(%rsp)
     788:	48 89 6c 24 08       	mov    %rbp,0x8(%rsp)
     78d:	48 89 fd             	mov    %rdi,%rbp
     790:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
    l2_pgentry_t *pl2e;

    pl2e = virt_to_xen_l2e(v);
     795:	e8 00 00 00 00       	callq  79a <virt_to_xen_l1e+0x1a>
    if ( !pl2e )
     79a:	48 85 c0             	test   %rax,%rax

l1_pgentry_t *virt_to_xen_l1e(unsigned long v)
{
    l2_pgentry_t *pl2e;

    pl2e = virt_to_xen_l2e(v);
     79d:	48 89 c3             	mov    %rax,%rbx
    if ( !pl2e )
     7a0:	0f 84 1a 01 00 00    	je     8c0 <virt_to_xen_l1e+0x140>
        return NULL;

    if ( !(l2e_get_flags(*pl2e) & _PAGE_PRESENT) )
     7a6:	48 8b 10             	mov    (%rax),%rdx
     7a9:	48 89 d0             	mov    %rdx,%rax
     7ac:	89 d1                	mov    %edx,%ecx
     7ae:	48 c1 e8 28          	shr    $0x28,%rax
     7b2:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
     7b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
     7bd:	09 c8                	or     %ecx,%eax
     7bf:	a8 01                	test   $0x1,%al
     7c1:	74 65                	je     828 <virt_to_xen_l1e+0xa8>
            return NULL;
        clear_page(pl1e);
        l2e_write(pl2e, l2e_from_paddr(__pa(pl1e), __PAGE_HYPERVISOR));
    }

    BUG_ON(l2e_get_flags(*pl2e) & _PAGE_PSE);
     7c3:	a8 80                	test   $0x80,%al
     7c5:	0f 85 fc 00 00 00    	jne    8c7 <virt_to_xen_l1e+0x147>
    return l2e_to_l1e(*pl2e) + l1_table_offset(v);
     7cb:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
     7d2:	ff 0f 00 
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     7d5:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 7db <virt_to_xen_l1e+0x5b>
     7db:	48 c1 ed 09          	shr    $0x9,%rbp
     7df:	48 21 c2             	and    %rax,%rdx
     7e2:	81 e5 f8 0f 00 00    	and    $0xff8,%ebp
     7e8:	48 89 d0             	mov    %rdx,%rax
     7eb:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 7f2 <virt_to_xen_l1e+0x72>

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     7f2:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 7f9 <virt_to_xen_l1e+0x79>
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     7f9:	48 d3 e8             	shr    %cl,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     7fc:	48 09 d0             	or     %rdx,%rax
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
     7ff:	48 ba 00 00 00 00 00 	movabs $0xffff830000000000,%rdx
     806:	83 ff ff 
     809:	48 01 d0             	add    %rdx,%rax
     80c:	48 01 e8             	add    %rbp,%rax
}
     80f:	48 8b 1c 24          	mov    (%rsp),%rbx
     813:	48 8b 6c 24 08       	mov    0x8(%rsp),%rbp
     818:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
     81d:	48 83 c4 18          	add    $0x18,%rsp
     821:	c3                   	retq   
     822:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    if ( !pl2e )
        return NULL;

    if ( !(l2e_get_flags(*pl2e) & _PAGE_PRESENT) )
    {
        l1_pgentry_t *pl1e = alloc_xen_pagetable();
     828:	e8 00 00 00 00       	callq  82d <virt_to_xen_l1e+0xad>
     82d:	49 89 c4             	mov    %rax,%r12

        if ( !pl1e )
            return NULL;
     830:	31 c0                	xor    %eax,%eax

    if ( !(l2e_get_flags(*pl2e) & _PAGE_PRESENT) )
    {
        l1_pgentry_t *pl1e = alloc_xen_pagetable();

        if ( !pl1e )
     832:	4d 85 e4             	test   %r12,%r12
     835:	74 d8                	je     80f <virt_to_xen_l1e+0x8f>
            return NULL;
        clear_page(pl1e);
     837:	4c 89 e7             	mov    %r12,%rdi
     83a:	e8 00 00 00 00       	callq  83f <virt_to_xen_l1e+0xbf>

static inline unsigned long __virt_to_maddr(unsigned long va)
{
    ASSERT(va >= XEN_VIRT_START);
    ASSERT(va < DIRECTMAP_VIRT_END);
    if ( va >= DIRECTMAP_VIRT_START )
     83f:	48 b8 ff ff ff ff ff 	movabs $0xffff82ffffffffff,%rax
     846:	82 ff ff 
     849:	49 39 c4             	cmp    %rax,%r12
     84c:	77 5a                	ja     8a8 <virt_to_xen_l1e+0x128>
        va -= DIRECTMAP_VIRT_START;
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
     84e:	48 b8 00 00 00 40 3b 	movabs $0x7d3b40000000,%rax
     855:	7d 00 00 
     858:	48 03 05 00 00 00 00 	add    0x0(%rip),%rax        # 85f <virt_to_xen_l1e+0xdf>
     85f:	49 01 c4             	add    %rax,%r12
    }
    return (va & ma_va_bottom_mask) |
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
     862:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 868 <virt_to_xen_l1e+0xe8>
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
     868:	4c 89 e2             	mov    %r12,%rdx
     86b:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 872 <virt_to_xen_l1e+0xf2>
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
     872:	49 d3 e4             	shl    %cl,%r12
     875:	4c 23 25 00 00 00 00 	and    0x0(%rip),%r12        # 87c <virt_to_xen_l1e+0xfc>
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
     87c:	48 83 ca 63          	or     $0x63,%rdx
    return (l1_pgentry_t) { pa | put_pte_flags(flags) };
}
static inline l2_pgentry_t l2e_from_paddr(paddr_t pa, unsigned int flags)
{
    ASSERT((pa & ~(PADDR_MASK & PAGE_MASK)) == 0);
    return (l2_pgentry_t) { pa | put_pte_flags(flags) };
     880:	4c 09 e2             	or     %r12,%rdx
     883:	48 89 13             	mov    %rdx,(%rbx)
     886:	48 8b 13             	mov    (%rbx),%rdx
     889:	48 89 d0             	mov    %rdx,%rax
     88c:	89 d1                	mov    %edx,%ecx
     88e:	48 c1 e8 28          	shr    $0x28,%rax
     892:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
     898:	25 00 f0 ff ff       	and    $0xfffff000,%eax
     89d:	09 c8                	or     %ecx,%eax
     89f:	e9 1f ff ff ff       	jmpq   7c3 <virt_to_xen_l1e+0x43>
     8a4:	0f 1f 40 00          	nopl   0x0(%rax)
static inline unsigned long __virt_to_maddr(unsigned long va)
{
    ASSERT(va >= XEN_VIRT_START);
    ASSERT(va < DIRECTMAP_VIRT_END);
    if ( va >= DIRECTMAP_VIRT_START )
        va -= DIRECTMAP_VIRT_START;
     8a8:	48 b8 00 00 00 00 00 	movabs $0x7d0000000000,%rax
     8af:	7d 00 00 
     8b2:	49 01 c4             	add    %rax,%r12
     8b5:	eb ab                	jmp    862 <virt_to_xen_l1e+0xe2>
     8b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     8be:	00 00 
{
    l2_pgentry_t *pl2e;

    pl2e = virt_to_xen_l2e(v);
    if ( !pl2e )
        return NULL;
     8c0:	31 c0                	xor    %eax,%eax
     8c2:	e9 48 ff ff ff       	jmpq   80f <virt_to_xen_l1e+0x8f>
            return NULL;
        clear_page(pl1e);
        l2e_write(pl2e, l2e_from_paddr(__pa(pl1e), __PAGE_HYPERVISOR));
    }

    BUG_ON(l2e_get_flags(*pl2e) & _PAGE_PSE);
     8c7:	0f 0b                	ud2    
     8c9:	c2 0a 02             	retq   $0x20a
     8cc:	bc 00 00 00 00       	mov    $0x0,%esp
     8d1:	e9 f5 fe ff ff       	jmpq   7cb <virt_to_xen_l1e+0x4b>
     8d6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
     8dd:	00 00 00 

00000000000008e0 <do_page_walk>:
    return l2e_to_l1e(*pl2e) + l1_table_offset(v);
}

void *do_page_walk(struct vcpu *v, unsigned long addr)
{
     8e0:	48 83 ec 28          	sub    $0x28,%rsp
     8e4:	48 89 f8             	mov    %rdi,%rax
     8e7:	48 89 1c 24          	mov    %rbx,(%rsp)
     8eb:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
    l3_pgentry_t l3e, *l3t;
    l2_pgentry_t l2e, *l2t;
    l1_pgentry_t l1e, *l1t;

    if ( is_hvm_vcpu(v) )
        return NULL;
     8f0:	45 31 e4             	xor    %r12d,%r12d
    BUG_ON(l2e_get_flags(*pl2e) & _PAGE_PSE);
    return l2e_to_l1e(*pl2e) + l1_table_offset(v);
}

void *do_page_walk(struct vcpu *v, unsigned long addr)
{
     8f3:	48 89 6c 24 08       	mov    %rbp,0x8(%rsp)
     8f8:	4c 89 6c 24 18       	mov    %r13,0x18(%rsp)
     8fd:	48 89 f3             	mov    %rsi,%rbx
     900:	4c 89 74 24 20       	mov    %r14,0x20(%rsp)
    l4_pgentry_t l4e, *l4t;
    l3_pgentry_t l3e, *l3t;
    l2_pgentry_t l2e, *l2t;
    l1_pgentry_t l1e, *l1t;

    if ( is_hvm_vcpu(v) )
     905:	48 8b 40 10          	mov    0x10(%rax),%rax
    return l2e_to_l1e(*pl2e) + l1_table_offset(v);
}

void *do_page_walk(struct vcpu *v, unsigned long addr)
{
    unsigned long mfn = pagetable_get_pfn(v->arch.guest_table);
     909:	48 8b bf 48 09 00 00 	mov    0x948(%rdi),%rdi
    l4_pgentry_t l4e, *l4t;
    l3_pgentry_t l3e, *l3t;
    l2_pgentry_t l2e, *l2t;
    l1_pgentry_t l1e, *l1t;

    if ( is_hvm_vcpu(v) )
     910:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
     917:	0f 85 b5 00 00 00    	jne    9d2 <do_page_walk+0xf2>
        return NULL;

    l4t = map_domain_page(mfn);
     91d:	e8 00 00 00 00       	callq  922 <do_page_walk+0x42>
    l4e = l4t[l4_table_offset(addr)];
     922:	48 89 da             	mov    %rbx,%rdx
    unmap_domain_page(l4t);
     925:	48 89 c7             	mov    %rax,%rdi

    if ( is_hvm_vcpu(v) )
        return NULL;

    l4t = map_domain_page(mfn);
    l4e = l4t[l4_table_offset(addr)];
     928:	48 c1 ea 27          	shr    $0x27,%rdx
     92c:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
     932:	48 8b 2c d0          	mov    (%rax,%rdx,8),%rbp
    unmap_domain_page(l4t);
     936:	e8 00 00 00 00       	callq  93b <do_page_walk+0x5b>
    if ( !(l4e_get_flags(l4e) & _PAGE_PRESENT) )
     93b:	40 f6 c5 01          	test   $0x1,%bpl
     93f:	0f 84 8d 00 00 00    	je     9d2 <do_page_walk+0xf2>
        return NULL;

    l3t = map_l3t_from_l4e(l4e);
     945:	48 89 ef             	mov    %rbp,%rdi
     948:	49 be 00 f0 ff ff ff 	movabs $0xffffffffff000,%r14
     94f:	ff 0f 00 
     952:	4c 21 f7             	and    %r14,%rdi
     955:	48 c1 ef 0c          	shr    $0xc,%rdi
     959:	e8 00 00 00 00       	callq  95e <do_page_walk+0x7e>
    l3e = l3t[l3_table_offset(addr)];
     95e:	48 89 da             	mov    %rbx,%rdx
    unmap_domain_page(l3t);
     961:	48 89 c7             	mov    %rax,%rdi
    unmap_domain_page(l4t);
    if ( !(l4e_get_flags(l4e) & _PAGE_PRESENT) )
        return NULL;

    l3t = map_l3t_from_l4e(l4e);
    l3e = l3t[l3_table_offset(addr)];
     964:	48 c1 ea 1e          	shr    $0x1e,%rdx
     968:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
     96e:	4c 8b 2c d0          	mov    (%rax,%rdx,8),%r13
    unmap_domain_page(l3t);
     972:	e8 00 00 00 00       	callq  977 <do_page_walk+0x97>
    mfn = l3e_get_pfn(l3e);
    if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) || !mfn_valid(mfn) )
     977:	4c 89 ed             	mov    %r13,%rbp
     97a:	44 89 e8             	mov    %r13d,%eax
     97d:	48 c1 ed 28          	shr    $0x28,%rbp
     981:	25 ff 0f 00 00       	and    $0xfff,%eax
     986:	81 e5 00 f0 ff ff    	and    $0xfffff000,%ebp
     98c:	09 c5                	or     %eax,%ebp
     98e:	40 f6 c5 01          	test   $0x1,%bpl
     992:	74 3e                	je     9d2 <do_page_walk+0xf2>
        return NULL;

    l3t = map_l3t_from_l4e(l4e);
    l3e = l3t[l3_table_offset(addr)];
    unmap_domain_page(l3t);
    mfn = l3e_get_pfn(l3e);
     994:	4d 21 f5             	and    %r14,%r13
     997:	49 c1 ed 0c          	shr    $0xc,%r13
    if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) || !mfn_valid(mfn) )
     99b:	4c 89 ef             	mov    %r13,%rdi
     99e:	e8 00 00 00 00       	callq  9a3 <do_page_walk+0xc3>
     9a3:	85 c0                	test   %eax,%eax
     9a5:	74 2b                	je     9d2 <do_page_walk+0xf2>
        return NULL;
    if ( (l3e_get_flags(l3e) & _PAGE_PSE) )
     9a7:	81 e5 80 00 00 00    	and    $0x80,%ebp
     9ad:	74 49                	je     9f8 <do_page_walk+0x118>
    {
        mfn += PFN_DOWN(addr & ((1UL << L3_PAGETABLE_SHIFT) - 1));
     9af:	49 89 de             	mov    %rbx,%r14
     9b2:	41 81 e6 ff ff ff 3f 	and    $0x3fffffff,%r14d
     9b9:	49 c1 ee 0c          	shr    $0xc,%r14
     9bd:	4d 01 f5             	add    %r14,%r13
    mfn = l1e_get_pfn(l1e);
    if ( !(l1e_get_flags(l1e) & _PAGE_PRESENT) || !mfn_valid(mfn) )
        return NULL;

 ret:
    return map_domain_page(mfn) + (addr & ~PAGE_MASK);
     9c0:	4c 89 ef             	mov    %r13,%rdi
     9c3:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
     9c9:	e8 00 00 00 00       	callq  9ce <do_page_walk+0xee>
     9ce:	4c 8d 24 18          	lea    (%rax,%rbx,1),%r12
}
     9d2:	4c 89 e0             	mov    %r12,%rax
     9d5:	48 8b 1c 24          	mov    (%rsp),%rbx
     9d9:	48 8b 6c 24 08       	mov    0x8(%rsp),%rbp
     9de:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
     9e3:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
     9e8:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
     9ed:	48 83 c4 28          	add    $0x28,%rsp
     9f1:	c3                   	retq   
     9f2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    {
        mfn += PFN_DOWN(addr & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        goto ret;
    }

    l2t = map_domain_page(mfn);
     9f8:	4c 89 ef             	mov    %r13,%rdi
     9fb:	e8 00 00 00 00       	callq  a00 <do_page_walk+0x120>
    l2e = l2t[l2_table_offset(addr)];
     a00:	48 89 da             	mov    %rbx,%rdx
    unmap_domain_page(l2t);
     a03:	48 89 c7             	mov    %rax,%rdi
        mfn += PFN_DOWN(addr & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        goto ret;
    }

    l2t = map_domain_page(mfn);
    l2e = l2t[l2_table_offset(addr)];
     a06:	48 c1 ea 15          	shr    $0x15,%rdx
     a0a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
     a10:	4c 8b 2c d0          	mov    (%rax,%rdx,8),%r13
    unmap_domain_page(l2t);
     a14:	e8 00 00 00 00       	callq  a19 <do_page_walk+0x139>
    mfn = l2e_get_pfn(l2e);
    if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) || !mfn_valid(mfn) )
     a19:	4c 89 ed             	mov    %r13,%rbp
     a1c:	44 89 e8             	mov    %r13d,%eax
     a1f:	48 c1 ed 28          	shr    $0x28,%rbp
     a23:	25 ff 0f 00 00       	and    $0xfff,%eax
     a28:	81 e5 00 f0 ff ff    	and    $0xfffff000,%ebp
     a2e:	09 c5                	or     %eax,%ebp
     a30:	40 f6 c5 01          	test   $0x1,%bpl
     a34:	74 9c                	je     9d2 <do_page_walk+0xf2>
    }

    l2t = map_domain_page(mfn);
    l2e = l2t[l2_table_offset(addr)];
    unmap_domain_page(l2t);
    mfn = l2e_get_pfn(l2e);
     a36:	4d 21 f5             	and    %r14,%r13
     a39:	49 c1 ed 0c          	shr    $0xc,%r13
    if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) || !mfn_valid(mfn) )
     a3d:	4c 89 ef             	mov    %r13,%rdi
     a40:	e8 00 00 00 00       	callq  a45 <do_page_walk+0x165>
     a45:	85 c0                	test   %eax,%eax
     a47:	74 89                	je     9d2 <do_page_walk+0xf2>
        return NULL;
    if ( (l2e_get_flags(l2e) & _PAGE_PSE) )
     a49:	81 e5 80 00 00 00    	and    $0x80,%ebp
     a4f:	74 1f                	je     a70 <do_page_walk+0x190>
    {
        mfn += PFN_DOWN(addr & ((1UL << L2_PAGETABLE_SHIFT) - 1));
     a51:	49 89 de             	mov    %rbx,%r14
     a54:	41 81 e6 ff ff 1f 00 	and    $0x1fffff,%r14d
     a5b:	49 c1 ee 0c          	shr    $0xc,%r14
     a5f:	4d 01 f5             	add    %r14,%r13
        goto ret;
     a62:	e9 59 ff ff ff       	jmpq   9c0 <do_page_walk+0xe0>
     a67:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     a6e:	00 00 
    }

    l1t = map_domain_page(mfn);
     a70:	4c 89 ef             	mov    %r13,%rdi
     a73:	e8 00 00 00 00       	callq  a78 <do_page_walk+0x198>
    l1e = l1t[l1_table_offset(addr)];
     a78:	48 89 da             	mov    %rbx,%rdx
    unmap_domain_page(l1t);
     a7b:	48 89 c7             	mov    %rax,%rdi
        mfn += PFN_DOWN(addr & ((1UL << L2_PAGETABLE_SHIFT) - 1));
        goto ret;
    }

    l1t = map_domain_page(mfn);
    l1e = l1t[l1_table_offset(addr)];
     a7e:	48 c1 ea 0c          	shr    $0xc,%rdx
     a82:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
     a88:	4c 8b 2c d0          	mov    (%rax,%rdx,8),%r13
    unmap_domain_page(l1t);
     a8c:	e8 00 00 00 00       	callq  a91 <do_page_walk+0x1b1>
    mfn = l1e_get_pfn(l1e);
    if ( !(l1e_get_flags(l1e) & _PAGE_PRESENT) || !mfn_valid(mfn) )
     a91:	41 f6 c5 01          	test   $0x1,%r13b
     a95:	0f 84 37 ff ff ff    	je     9d2 <do_page_walk+0xf2>
    }

    l1t = map_domain_page(mfn);
    l1e = l1t[l1_table_offset(addr)];
    unmap_domain_page(l1t);
    mfn = l1e_get_pfn(l1e);
     a9b:	4d 21 f5             	and    %r14,%r13
     a9e:	49 c1 ed 0c          	shr    $0xc,%r13
    if ( !(l1e_get_flags(l1e) & _PAGE_PRESENT) || !mfn_valid(mfn) )
     aa2:	4c 89 ef             	mov    %r13,%rdi
     aa5:	e8 00 00 00 00       	callq  aaa <do_page_walk+0x1ca>
     aaa:	85 c0                	test   %eax,%eax
     aac:	0f 85 0e ff ff ff    	jne    9c0 <do_page_walk+0xe0>
     ab2:	e9 1b ff ff ff       	jmpq   9d2 <do_page_walk+0xf2>
     ab7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
     abe:	00 00 

0000000000000ac0 <hotadd_mem_valid>:
    unsigned long cur;
};

int hotadd_mem_valid(unsigned long pfn, struct mem_hotadd_info *info)
{
    return (pfn < info->epfn && pfn >= info->spfn);
     ac0:	31 c0                	xor    %eax,%eax
     ac2:	48 39 7e 08          	cmp    %rdi,0x8(%rsi)
     ac6:	76 08                	jbe    ad0 <hotadd_mem_valid+0x10>
     ac8:	31 c0                	xor    %eax,%eax
     aca:	48 3b 3e             	cmp    (%rsi),%rdi
     acd:	0f 93 c0             	setae  %al
}
     ad0:	f3 c3                	repz retq 
     ad2:	66 66 66 66 66 2e 0f 	data32 data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)
     ad9:	1f 84 00 00 00 00 00 

0000000000000ae0 <share_hotadd_m2p_table>:

    return M2P_NO_MAPPED;
}

int share_hotadd_m2p_table(struct mem_hotadd_info *info)
{
     ae0:	41 57                	push   %r15
    for ( v  = RDWR_MPT_VIRT_START;
          v != RDWR_MPT_VIRT_END;
          v += n << PAGE_SHIFT )
    {
        n = L2_PAGETABLE_ENTRIES * L1_PAGETABLE_ENTRIES;
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
     ae2:	49 bf 00 f0 ff ff ff 	movabs $0xffffffffff000,%r15
     ae9:	ff 0f 00 

    return M2P_NO_MAPPED;
}

int share_hotadd_m2p_table(struct mem_hotadd_info *info)
{
     aec:	41 56                	push   %r14
        else
            continue;

        for ( i = 0; i < n; i++ )
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
     aee:	49 be 00 00 00 00 e0 	movabs $0xffff82e000000000,%r14
     af5:	82 ff ff 

    return M2P_NO_MAPPED;
}

int share_hotadd_m2p_table(struct mem_hotadd_info *info)
{
     af8:	41 55                	push   %r13
    unsigned long i, n, v, m2p_start_mfn = 0;
    l3_pgentry_t l3e;
    l2_pgentry_t l2e;

    /* M2P table is mappable read-only by privileged domains. */
    for ( v  = RDWR_MPT_VIRT_START;
     afa:	49 bd 00 00 00 00 80 	movabs $0xffff828000000000,%r13
     b01:	82 ff ff 

    return M2P_NO_MAPPED;
}

int share_hotadd_m2p_table(struct mem_hotadd_info *info)
{
     b04:	41 54                	push   %r12
     b06:	55                   	push   %rbp
     b07:	53                   	push   %rbx
     b08:	48 89 fb             	mov    %rdi,%rbx
     b0b:	48 83 ec 18          	sub    $0x18,%rsp
        l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
        if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
     b0f:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # b16 <share_hotadd_m2p_table+0x36>
     b16:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # b1d <share_hotadd_m2p_table+0x3d>
     b1d:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # b23 <share_hotadd_m2p_table+0x43>
    for ( v  = RDWR_MPT_VIRT_START;
          v != RDWR_MPT_VIRT_END;
          v += n << PAGE_SHIFT )
    {
        n = L2_PAGETABLE_ENTRIES * L1_PAGETABLE_ENTRIES;
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
     b23:	4c 89 ee             	mov    %r13,%rsi
     b26:	4c 8d 05 00 00 00 00 	lea    0x0(%rip),%r8        # b2d <share_hotadd_m2p_table+0x4d>
     b2d:	4c 89 ff             	mov    %r15,%rdi
     b30:	48 c1 ee 27          	shr    $0x27,%rsi
     b34:	81 e6 ff 01 00 00    	and    $0x1ff,%esi
     b3a:	49 23 3c f0          	and    (%r8,%rsi,8),%rdi
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     b3e:	48 89 d6             	mov    %rdx,%rsi
     b41:	49 b8 00 00 00 00 00 	movabs $0xffff830000000000,%r8
     b48:	83 ff ff 
     b4b:	48 21 fe             	and    %rdi,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     b4e:	48 21 c7             	and    %rax,%rdi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     b51:	48 d3 ee             	shr    %cl,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     b54:	48 09 fe             	or     %rdi,%rsi
            l3_table_offset(v)];
     b57:	4c 89 ef             	mov    %r13,%rdi
     b5a:	48 c1 ef 1b          	shr    $0x1b,%rdi
    for ( v  = RDWR_MPT_VIRT_START;
          v != RDWR_MPT_VIRT_END;
          v += n << PAGE_SHIFT )
    {
        n = L2_PAGETABLE_ENTRIES * L1_PAGETABLE_ENTRIES;
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
     b5e:	81 e7 f8 0f 00 00    	and    $0xff8,%edi
     b64:	48 01 fe             	add    %rdi,%rsi
     b67:	4a 8b 3c 06          	mov    (%rsi,%r8,1),%rdi
            l3_table_offset(v)];
        if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
     b6b:	48 89 fe             	mov    %rdi,%rsi
     b6e:	41 89 f8             	mov    %edi,%r8d
     b71:	48 c1 ee 28          	shr    $0x28,%rsi
     b75:	41 81 e0 ff 0f 00 00 	and    $0xfff,%r8d
     b7c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
     b82:	44 09 c6             	or     %r8d,%esi
     b85:	41 b8 00 00 00 40    	mov    $0x40000000,%r8d
     b8b:	40 f6 c6 01          	test   $0x1,%sil
     b8f:	0f 84 be 00 00 00    	je     c53 <share_hotadd_m2p_table+0x173>
            continue;
        if ( !(l3e_get_flags(l3e) & _PAGE_PSE) )
     b95:	81 e6 80 00 00 00    	and    $0x80,%esi
     b9b:	0f 85 b2 00 00 00    	jne    c53 <share_hotadd_m2p_table+0x173>
        {
            n = L1_PAGETABLE_ENTRIES;
            l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
     ba1:	4c 21 ff             	and    %r15,%rdi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     ba4:	48 89 d6             	mov    %rdx,%rsi
            if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
     ba7:	41 b8 00 00 20 00    	mov    $0x200000,%r8d
     bad:	48 21 fe             	and    %rdi,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     bb0:	48 21 c7             	and    %rax,%rdi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     bb3:	48 d3 ee             	shr    %cl,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     bb6:	48 09 fe             	or     %rdi,%rsi
        if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
            continue;
        if ( !(l3e_get_flags(l3e) & _PAGE_PSE) )
        {
            n = L1_PAGETABLE_ENTRIES;
            l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
     bb9:	4c 89 ef             	mov    %r13,%rdi
     bbc:	48 c1 ef 12          	shr    $0x12,%rdi
     bc0:	81 e7 f8 0f 00 00    	and    $0xff8,%edi
     bc6:	48 01 fe             	add    %rdi,%rsi
     bc9:	48 bf 00 00 00 00 00 	movabs $0xffff830000000000,%rdi
     bd0:	83 ff ff 
     bd3:	4c 8b 24 3e          	mov    (%rsi,%rdi,1),%r12
            if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
     bd7:	41 f6 c4 01          	test   $0x1,%r12b
     bdb:	74 76                	je     c53 <share_hotadd_m2p_table+0x173>
                continue;
            m2p_start_mfn = l2e_get_pfn(l2e);
     bdd:	4d 21 fc             	and    %r15,%r12
        }
        else
            continue;

        for ( i = 0; i < n; i++ )
     be0:	31 ed                	xor    %ebp,%ebp
        {
            n = L1_PAGETABLE_ENTRIES;
            l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
            if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
                continue;
            m2p_start_mfn = l2e_get_pfn(l2e);
     be2:	49 c1 ec 0c          	shr    $0xc,%r12
     be6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
     bed:	00 00 00 
        else
            continue;

        for ( i = 0; i < n; i++ )
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
     bf0:	4a 8d 44 25 00       	lea    0x0(%rbp,%r12,1),%rax
    unsigned long cur;
};

int hotadd_mem_valid(unsigned long pfn, struct mem_hotadd_info *info)
{
    return (pfn < info->epfn && pfn >= info->spfn);
     bf5:	48 3b 43 08          	cmp    0x8(%rbx),%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
     bf9:	48 8b 35 00 00 00 00 	mov    0x0(%rip),%rsi        # c00 <share_hotadd_m2p_table+0x120>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
     c00:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # c07 <share_hotadd_m2p_table+0x127>
     c07:	73 29                	jae    c32 <share_hotadd_m2p_table+0x152>
     c09:	48 3b 03             	cmp    (%rbx),%rax
     c0c:	72 24                	jb     c32 <share_hotadd_m2p_table+0x152>
     c0e:	48 21 c2             	and    %rax,%rdx

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
     c11:	48 21 f0             	and    %rsi,%rax

        for ( i = 0; i < n; i++ )
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
            if (hotadd_mem_valid(m2p_start_mfn + i, info))
                share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
     c14:	be 01 00 00 00       	mov    $0x1,%esi
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
     c19:	48 d3 ea             	shr    %cl,%rdx

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
     c1c:	48 09 c2             	or     %rax,%rdx
        else
            continue;

        for ( i = 0; i < n; i++ )
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
     c1f:	48 c1 e2 05          	shl    $0x5,%rdx
     c23:	4a 8d 3c 32          	lea    (%rdx,%r14,1),%rdi
            if (hotadd_mem_valid(m2p_start_mfn + i, info))
                share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
     c27:	e8 00 00 00 00       	callq  c2c <share_hotadd_m2p_table+0x14c>
     c2c:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # c32 <share_hotadd_m2p_table+0x152>
            m2p_start_mfn = l2e_get_pfn(l2e);
        }
        else
            continue;

        for ( i = 0; i < n; i++ )
     c32:	48 83 c5 01          	add    $0x1,%rbp
     c36:	48 81 fd 00 02 00 00 	cmp    $0x200,%rbp
     c3d:	75 b1                	jne    bf0 <share_hotadd_m2p_table+0x110>
     c3f:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # c46 <share_hotadd_m2p_table+0x166>
     c46:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # c4d <share_hotadd_m2p_table+0x16d>
     c4d:	41 b8 00 00 20 00    	mov    $0x200000,%r8d
    l2_pgentry_t l2e;

    /* M2P table is mappable read-only by privileged domains. */
    for ( v  = RDWR_MPT_VIRT_START;
          v != RDWR_MPT_VIRT_END;
          v += n << PAGE_SHIFT )
     c53:	4d 01 c5             	add    %r8,%r13
    unsigned long i, n, v, m2p_start_mfn = 0;
    l3_pgentry_t l3e;
    l2_pgentry_t l2e;

    /* M2P table is mappable read-only by privileged domains. */
    for ( v  = RDWR_MPT_VIRT_START;
     c56:	49 b8 00 00 00 00 c0 	movabs $0xffff82c000000000,%r8
     c5d:	82 ff ff 
     c60:	4d 39 c5             	cmp    %r8,%r13
     c63:	0f 85 ba fe ff ff    	jne    b23 <share_hotadd_m2p_table+0x43>
     c69:	49 bc 00 00 00 40 c4 	movabs $0xffff82c440000000,%r12
     c70:	82 ff ff 

    for ( v  = RDWR_COMPAT_MPT_VIRT_START;
          v != RDWR_COMPAT_MPT_VIRT_END;
          v += 1 << L2_PAGETABLE_SHIFT )
    {
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
     c73:	49 bd 00 f0 ff ff ff 	movabs $0xffffffffff000,%r13
     c7a:	ff 0f 00 
     c7d:	49 be 00 00 00 00 00 	movabs $0xffff830000000000,%r14
     c84:	83 ff ff 
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
     c87:	48 bd 00 00 00 00 e0 	movabs $0xffff82e000000000,%rbp
     c8e:	82 ff ff 
            if (hotadd_mem_valid(m2p_start_mfn + i, info))
                share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
        }
    }

    for ( v  = RDWR_COMPAT_MPT_VIRT_START;
     c91:	49 bf 00 00 00 80 c4 	movabs $0xffff82c480000000,%r15
     c98:	82 ff ff 
     c9b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
          v != RDWR_COMPAT_MPT_VIRT_END;
          v += 1 << L2_PAGETABLE_SHIFT )
    {
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
     ca0:	4c 89 ef             	mov    %r13,%rdi
     ca3:	48 23 3d 00 00 00 00 	and    0x0(%rip),%rdi        # caa <share_hotadd_m2p_table+0x1ca>
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     caa:	48 89 d6             	mov    %rdx,%rsi
     cad:	48 21 fe             	and    %rdi,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     cb0:	48 21 c7             	and    %rax,%rdi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     cb3:	48 d3 ee             	shr    %cl,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     cb6:	48 09 fe             	or     %rdi,%rsi
     cb9:	4a 8b b4 36 88 08 00 	mov    0x888(%rsi,%r14,1),%rsi
     cc0:	00 
            l3_table_offset(v)];
        if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
     cc1:	40 f6 c6 01          	test   $0x1,%sil
     cc5:	0f 84 93 00 00 00    	je     d5e <share_hotadd_m2p_table+0x27e>
            continue;
        l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
     ccb:	4c 21 ee             	and    %r13,%rsi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     cce:	48 21 f2             	and    %rsi,%rdx

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     cd1:	48 21 f0             	and    %rsi,%rax
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     cd4:	48 d3 ea             	shr    %cl,%rdx

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     cd7:	48 09 c2             	or     %rax,%rdx
     cda:	4c 89 e0             	mov    %r12,%rax
     cdd:	48 c1 e8 12          	shr    $0x12,%rax
     ce1:	25 f8 0f 00 00       	and    $0xff8,%eax
     ce6:	48 01 c2             	add    %rax,%rdx
     ce9:	4a 8b 14 32          	mov    (%rdx,%r14,1),%rdx
        if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
     ced:	f6 c2 01             	test   $0x1,%dl
     cf0:	74 6c                	je     d5e <share_hotadd_m2p_table+0x27e>
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);
     cf2:	4c 21 ea             	and    %r13,%rdx

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
     cf5:	31 c0                	xor    %eax,%eax
        if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
            continue;
        l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
        if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);
     cf7:	48 c1 ea 0c          	shr    $0xc,%rdx
     cfb:	eb 09                	jmp    d06 <share_hotadd_m2p_table+0x226>
     cfd:	0f 1f 00             	nopl   (%rax)

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
     d00:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # d06 <share_hotadd_m2p_table+0x226>
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
     d06:	48 8d 34 10          	lea    (%rax,%rdx,1),%rsi
    unsigned long cur;
};

int hotadd_mem_valid(unsigned long pfn, struct mem_hotadd_info *info)
{
    return (pfn < info->epfn && pfn >= info->spfn);
     d0a:	48 3b 73 08          	cmp    0x8(%rbx),%rsi

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
     d0e:	4c 8b 05 00 00 00 00 	mov    0x0(%rip),%r8        # d15 <share_hotadd_m2p_table+0x235>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
     d15:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # d1c <share_hotadd_m2p_table+0x23c>
     d1c:	73 34                	jae    d52 <share_hotadd_m2p_table+0x272>
     d1e:	48 3b 33             	cmp    (%rbx),%rsi
     d21:	72 2f                	jb     d52 <share_hotadd_m2p_table+0x272>
     d23:	48 21 f7             	and    %rsi,%rdi

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
     d26:	4c 21 c6             	and    %r8,%rsi

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
            if (hotadd_mem_valid(m2p_start_mfn + i, info))
                share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
     d29:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
     d2e:	48 d3 ef             	shr    %cl,%rdi
     d31:	48 89 14 24          	mov    %rdx,(%rsp)

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
     d35:	48 09 f7             	or     %rsi,%rdi
     d38:	be 01 00 00 00       	mov    $0x1,%esi
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
     d3d:	48 c1 e7 05          	shl    $0x5,%rdi
     d41:	48 01 ef             	add    %rbp,%rdi
            if (hotadd_mem_valid(m2p_start_mfn + i, info))
                share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
     d44:	e8 00 00 00 00       	callq  d49 <share_hotadd_m2p_table+0x269>
     d49:	48 8b 14 24          	mov    (%rsp),%rdx
     d4d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
        l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
        if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
     d52:	48 83 c0 01          	add    $0x1,%rax
     d56:	48 3d 00 02 00 00    	cmp    $0x200,%rax
     d5c:	75 a2                	jne    d00 <share_hotadd_m2p_table+0x220>
        }
    }

    for ( v  = RDWR_COMPAT_MPT_VIRT_START;
          v != RDWR_COMPAT_MPT_VIRT_END;
          v += 1 << L2_PAGETABLE_SHIFT )
     d5e:	49 81 c4 00 00 20 00 	add    $0x200000,%r12
            if (hotadd_mem_valid(m2p_start_mfn + i, info))
                share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
        }
    }

    for ( v  = RDWR_COMPAT_MPT_VIRT_START;
     d65:	4d 39 fc             	cmp    %r15,%r12
     d68:	74 19                	je     d83 <share_hotadd_m2p_table+0x2a3>
     d6a:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # d71 <share_hotadd_m2p_table+0x291>
     d71:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # d78 <share_hotadd_m2p_table+0x298>
     d78:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # d7e <share_hotadd_m2p_table+0x29e>
     d7e:	e9 1d ff ff ff       	jmpq   ca0 <share_hotadd_m2p_table+0x1c0>
            if (hotadd_mem_valid(m2p_start_mfn + i, info))
                share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
        }
    }
    return 0;
}
     d83:	48 83 c4 18          	add    $0x18,%rsp
     d87:	31 c0                	xor    %eax,%eax
     d89:	5b                   	pop    %rbx
     d8a:	5d                   	pop    %rbp
     d8b:	41 5c                	pop    %r12
     d8d:	41 5d                	pop    %r13
     d8f:	41 5e                	pop    %r14
     d91:	41 5f                	pop    %r15
     d93:	c3                   	retq   
     d94:	66 66 66 2e 0f 1f 84 	data32 data32 nopw %cs:0x0(%rax,%rax,1)
     d9b:	00 00 00 00 00 

0000000000000da0 <destroy_m2p_mapping>:

    return;
}

void destroy_m2p_mapping(struct mem_hotadd_info *info)
{
     da0:	41 57                	push   %r15
    l3_pgentry_t *l3_ro_mpt;
    unsigned long i, va, rwva;
    unsigned long smap = info->spfn, emap = info->epfn;

    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(RO_MPT_VIRT_START)]);
     da2:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
     da9:	ff 0f 00 
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
     dac:	49 b8 00 00 00 00 00 	movabs $0xffff830000000000,%r8
     db3:	83 ff ff 
     db6:	48 89 c6             	mov    %rax,%rsi

    return;
}

void destroy_m2p_mapping(struct mem_hotadd_info *info)
{
     db9:	48 89 fa             	mov    %rdi,%rdx
     dbc:	41 56                	push   %r14
     dbe:	41 55                	push   %r13
     dc0:	41 54                	push   %r12
     dc2:	55                   	push   %rbp
     dc3:	53                   	push   %rbx
     dc4:	48 83 ec 28          	sub    $0x28,%rsp
    l3_pgentry_t *l3_ro_mpt;
    unsigned long i, va, rwva;
    unsigned long smap = info->spfn, emap = info->epfn;

    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(RO_MPT_VIRT_START)]);
     dc8:	48 23 35 00 00 00 00 	and    0x0(%rip),%rsi        # dcf <destroy_m2p_mapping+0x2f>
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     dcf:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # dd5 <destroy_m2p_mapping+0x35>

void destroy_m2p_mapping(struct mem_hotadd_info *info)
{
    l3_pgentry_t *l3_ro_mpt;
    unsigned long i, va, rwva;
    unsigned long smap = info->spfn, emap = info->epfn;
     dd5:	48 8b 1f             	mov    (%rdi),%rbx
     dd8:	4c 8b 6f 08          	mov    0x8(%rdi),%r13
     ddc:	49 89 f6             	mov    %rsi,%r14
     ddf:	4c 23 35 00 00 00 00 	and    0x0(%rip),%r14        # de6 <destroy_m2p_mapping+0x46>

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     de6:	48 23 35 00 00 00 00 	and    0x0(%rip),%rsi        # ded <destroy_m2p_mapping+0x4d>
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     ded:	49 d3 ee             	shr    %cl,%r14

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     df0:	49 09 f6             	or     %rsi,%r14
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
     df3:	4d 01 c6             	add    %r8,%r14
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(RO_MPT_VIRT_START)]);

    /*
     * No need to clean m2p structure existing before the hotplug
     */
    for (i = smap; i < emap;)
     df6:	4c 39 eb             	cmp    %r13,%rbx
     df9:	0f 83 38 01 00 00    	jae    f37 <destroy_m2p_mapping+0x197>
    {
        unsigned long pt_pfn;
        l2_pgentry_t *l2_ro_mpt;

        va = RO_MPT_VIRT_START + i * sizeof(*machine_to_phys_mapping);
     dff:	49 bf 00 00 00 00 00 	movabs $0xffff800000000000,%r15
     e06:	80 ff ff 
        }

        pt_pfn = l2e_get_pfn(l2_ro_mpt[l2_table_offset(va)]);
        if ( hotadd_mem_valid(pt_pfn, info) )
        {
            destroy_xen_mappings(rwva, rwva + (1UL << L2_PAGETABLE_SHIFT));
     e09:	49 b9 00 00 20 00 80 	movabs $0xffff828000200000,%r9
     e10:	82 ff ff 
     e13:	eb 1a                	jmp    e2f <destroy_m2p_mapping+0x8f>
     e15:	0f 1f 00             	nopl   (%rax)

        /* 1G mapping should not be created by mem hotadd */
        if (!(l3e_get_flags(l3_ro_mpt[l3_table_offset(va)]) & _PAGE_PRESENT) ||
            (l3e_get_flags(l3_ro_mpt[l3_table_offset(va)]) & _PAGE_PSE))
        {
            i = ( i & ~((1UL << (L3_PAGETABLE_SHIFT - 3)) - 1)) +
     e18:	48 81 e3 00 00 00 f8 	and    $0xfffffffff8000000,%rbx
     e1f:	48 81 c3 00 00 00 08 	add    $0x8000000,%rbx
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(RO_MPT_VIRT_START)]);

    /*
     * No need to clean m2p structure existing before the hotplug
     */
    for (i = smap; i < emap;)
     e26:	49 39 dd             	cmp    %rbx,%r13
     e29:	0f 86 08 01 00 00    	jbe    f37 <destroy_m2p_mapping+0x197>
    {
        unsigned long pt_pfn;
        l2_pgentry_t *l2_ro_mpt;

        va = RO_MPT_VIRT_START + i * sizeof(*machine_to_phys_mapping);
     e2f:	48 8d 3c dd 00 00 00 	lea    0x0(,%rbx,8),%rdi
     e36:	00 
     e37:	4e 8d 24 3f          	lea    (%rdi,%r15,1),%r12
        rwva = RDWR_MPT_VIRT_START + i * sizeof(*machine_to_phys_mapping);

        /* 1G mapping should not be created by mem hotadd */
        if (!(l3e_get_flags(l3_ro_mpt[l3_table_offset(va)]) & _PAGE_PRESENT) ||
     e3b:	4c 89 e5             	mov    %r12,%rbp
     e3e:	48 c1 ed 1b          	shr    $0x1b,%rbp
     e42:	81 e5 f8 0f 00 00    	and    $0xff8,%ebp
     e48:	4c 01 f5             	add    %r14,%rbp
     e4b:	4c 8b 55 00          	mov    0x0(%rbp),%r10
     e4f:	44 89 d1             	mov    %r10d,%ecx
     e52:	81 e1 81 00 00 00    	and    $0x81,%ecx
     e58:	83 f9 01             	cmp    $0x1,%ecx
     e5b:	75 bb                	jne    e18 <destroy_m2p_mapping+0x78>
            i = ( i & ~((1UL << (L3_PAGETABLE_SHIFT - 3)) - 1)) +
                (1UL << (L3_PAGETABLE_SHIFT - 3) );
            continue;
        }

        l2_ro_mpt = l3e_to_l2e(l3_ro_mpt[l3_table_offset(va)]);
     e5d:	49 21 c2             	and    %rax,%r10
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     e60:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # e66 <destroy_m2p_mapping+0xc6>
        if (!(l2e_get_flags(l2_ro_mpt[l2_table_offset(va)]) & _PAGE_PRESENT))
     e66:	49 c1 ec 12          	shr    $0x12,%r12
     e6a:	4c 89 d6             	mov    %r10,%rsi
     e6d:	48 23 35 00 00 00 00 	and    0x0(%rip),%rsi        # e74 <destroy_m2p_mapping+0xd4>

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     e74:	4c 23 15 00 00 00 00 	and    0x0(%rip),%r10        # e7b <destroy_m2p_mapping+0xdb>
     e7b:	41 81 e4 f8 0f 00 00 	and    $0xff8,%r12d
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     e82:	48 d3 ee             	shr    %cl,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     e85:	4c 09 d6             	or     %r10,%rsi
     e88:	4c 01 e6             	add    %r12,%rsi
     e8b:	4a 8b 0c 06          	mov    (%rsi,%r8,1),%rcx
     e8f:	f6 c1 01             	test   $0x1,%cl
     e92:	0f 84 88 00 00 00    	je     f20 <destroy_m2p_mapping+0x180>
            i = ( i & ~((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1)) +
                    (1UL << (L2_PAGETABLE_SHIFT - 3)) ;
            continue;
        }

        pt_pfn = l2e_get_pfn(l2_ro_mpt[l2_table_offset(va)]);
     e98:	48 21 c1             	and    %rax,%rcx
     e9b:	48 c1 e9 0c          	shr    $0xc,%rcx
    unsigned long cur;
};

int hotadd_mem_valid(unsigned long pfn, struct mem_hotadd_info *info)
{
    return (pfn < info->epfn && pfn >= info->spfn);
     e9f:	48 3b 4a 08          	cmp    0x8(%rdx),%rcx
     ea3:	73 7b                	jae    f20 <destroy_m2p_mapping+0x180>
     ea5:	48 3b 0a             	cmp    (%rdx),%rcx
     ea8:	72 76                	jb     f20 <destroy_m2p_mapping+0x180>
        }

        pt_pfn = l2e_get_pfn(l2_ro_mpt[l2_table_offset(va)]);
        if ( hotadd_mem_valid(pt_pfn, info) )
        {
            destroy_xen_mappings(rwva, rwva + (1UL << L2_PAGETABLE_SHIFT));
     eaa:	4a 8d 34 0f          	lea    (%rdi,%r9,1),%rsi
    {
        unsigned long pt_pfn;
        l2_pgentry_t *l2_ro_mpt;

        va = RO_MPT_VIRT_START + i * sizeof(*machine_to_phys_mapping);
        rwva = RDWR_MPT_VIRT_START + i * sizeof(*machine_to_phys_mapping);
     eae:	48 b9 00 00 00 00 80 	movabs $0xffff828000000000,%rcx
     eb5:	82 ff ff 
        }

        pt_pfn = l2e_get_pfn(l2_ro_mpt[l2_table_offset(va)]);
        if ( hotadd_mem_valid(pt_pfn, info) )
        {
            destroy_xen_mappings(rwva, rwva + (1UL << L2_PAGETABLE_SHIFT));
     eb8:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
    {
        unsigned long pt_pfn;
        l2_pgentry_t *l2_ro_mpt;

        va = RO_MPT_VIRT_START + i * sizeof(*machine_to_phys_mapping);
        rwva = RDWR_MPT_VIRT_START + i * sizeof(*machine_to_phys_mapping);
     ebd:	48 01 cf             	add    %rcx,%rdi
        }

        pt_pfn = l2e_get_pfn(l2_ro_mpt[l2_table_offset(va)]);
        if ( hotadd_mem_valid(pt_pfn, info) )
        {
            destroy_xen_mappings(rwva, rwva + (1UL << L2_PAGETABLE_SHIFT));
     ec0:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
     ec5:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
     eca:	4c 89 0c 24          	mov    %r9,(%rsp)
     ece:	e8 00 00 00 00       	callq  ed3 <destroy_m2p_mapping+0x133>

            l2_ro_mpt = l3e_to_l2e(l3_ro_mpt[l3_table_offset(va)]);
     ed3:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     ed8:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # ede <destroy_m2p_mapping+0x13e>
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
     ede:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
     ee3:	48 89 c7             	mov    %rax,%rdi
     ee6:	48 23 7d 00          	and    0x0(%rbp),%rdi
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     eea:	48 89 fe             	mov    %rdi,%rsi
     eed:	48 23 35 00 00 00 00 	and    0x0(%rip),%rsi        # ef4 <destroy_m2p_mapping+0x154>

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     ef4:	48 23 3d 00 00 00 00 	and    0x0(%rip),%rdi        # efb <destroy_m2p_mapping+0x15b>
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
     efb:	48 d3 ee             	shr    %cl,%rsi
     efe:	31 c9                	xor    %ecx,%ecx

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
     f00:	48 09 fe             	or     %rdi,%rsi
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
     f03:	4c 01 c6             	add    %r8,%rsi
            l2e_write(&l2_ro_mpt[l2_table_offset(va)], l2e_empty());
     f06:	49 01 f4             	add    %rsi,%r12
     f09:	49 89 0c 24          	mov    %rcx,(%r12)
     f0d:	4c 8b 0c 24          	mov    (%rsp),%r9
     f11:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
     f16:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
     f1d:	00 00 00 
        }
        i = ( i & ~((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1)) +
     f20:	48 81 e3 00 00 fc ff 	and    $0xfffffffffffc0000,%rbx
     f27:	48 81 c3 00 00 04 00 	add    $0x40000,%rbx
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(RO_MPT_VIRT_START)]);

    /*
     * No need to clean m2p structure existing before the hotplug
     */
    for (i = smap; i < emap;)
     f2e:	49 39 dd             	cmp    %rbx,%r13
     f31:	0f 87 f8 fe ff ff    	ja     e2f <destroy_m2p_mapping+0x8f>
    destroy_compat_m2p_mapping(info);

    /* Brute-Force flush all TLB */
    flush_tlb_all();
    return;
}
     f37:	48 83 c4 28          	add    $0x28,%rsp
    }

    destroy_compat_m2p_mapping(info);

    /* Brute-Force flush all TLB */
    flush_tlb_all();
     f3b:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # f42 <destroy_m2p_mapping+0x1a2>
     f42:	ba 00 01 00 00       	mov    $0x100,%edx
    return;
}
     f47:	5b                   	pop    %rbx
     f48:	5d                   	pop    %rbp
     f49:	41 5c                	pop    %r12
     f4b:	41 5d                	pop    %r13
     f4d:	41 5e                	pop    %r14
     f4f:	41 5f                	pop    %r15
    }

    destroy_compat_m2p_mapping(info);

    /* Brute-Force flush all TLB */
    flush_tlb_all();
     f51:	31 f6                	xor    %esi,%esi
     f53:	e9 00 00 00 00       	jmpq   f58 <destroy_m2p_mapping+0x1b8>
     f58:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
     f5f:	00 

0000000000000f60 <setup_compat_arg_xlat>:
                     __PAGE_HYPERVISOR);
}

int setup_compat_arg_xlat(struct vcpu *v)
{
    return create_perdomain_mapping(v->domain, ARG_XLAT_START(v),
     f60:	8b 37                	mov    (%rdi),%esi
     f62:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
     f66:	48 b8 00 00 00 80 00 	movabs $0xffff820080000000,%rax
     f6d:	82 ff ff 
     f70:	49 c7 c0 f8 ff ff ff 	mov    $0xfffffffffffffff8,%r8
     f77:	31 c9                	xor    %ecx,%ecx
     f79:	ba 02 00 00 00       	mov    $0x2,%edx
     f7e:	c1 e6 0e             	shl    $0xe,%esi
     f81:	48 63 f6             	movslq %esi,%rsi
     f84:	48 01 c6             	add    %rax,%rsi
     f87:	e9 00 00 00 00       	jmpq   f8c <setup_compat_arg_xlat+0x2c>
     f8c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000000f90 <free_compat_arg_xlat>:
                                    NULL, NIL(struct page_info *));
}

void free_compat_arg_xlat(struct vcpu *v)
{
    destroy_perdomain_mapping(v->domain, ARG_XLAT_START(v),
     f90:	8b 37                	mov    (%rdi),%esi
     f92:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
     f96:	48 b8 00 00 00 80 00 	movabs $0xffff820080000000,%rax
     f9d:	82 ff ff 
     fa0:	ba 02 00 00 00       	mov    $0x2,%edx
     fa5:	c1 e6 0e             	shl    $0xe,%esi
     fa8:	48 63 f6             	movslq %esi,%rsi
     fab:	48 01 c6             	add    %rax,%rsi
     fae:	e9 00 00 00 00       	jmpq   fb3 <free_compat_arg_xlat+0x23>
     fb3:	66 66 66 66 2e 0f 1f 	data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)
     fba:	84 00 00 00 00 00 

0000000000000fc0 <cleanup_frame_table>:
                              PFN_UP(COMPAT_ARG_XLAT_SIZE));
}

void cleanup_frame_table(struct mem_hotadd_info *info)
{
     fc0:	41 57                	push   %r15
     fc2:	41 56                	push   %r14
     fc4:	41 55                	push   %r13
     fc6:	41 54                	push   %r12
     fc8:	49 89 fc             	mov    %rdi,%r12
     fcb:	55                   	push   %rbp
     fcc:	53                   	push   %rbx
     fcd:	48 83 ec 08          	sub    $0x8,%rsp
extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
     fd1:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # fd8 <cleanup_frame_table+0x18>
    unsigned long sva, eva;
    l3_pgentry_t l3e;
    l2_pgentry_t l2e;
    unsigned long spfn, epfn;

    spfn = info->spfn;
     fd8:	48 8b 37             	mov    (%rdi),%rsi

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
     fdb:	4c 8b 05 00 00 00 00 	mov    0x0(%rip),%r8        # fe2 <cleanup_frame_table+0x22>
    epfn = info->epfn;
     fe2:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
     fe6:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # fec <cleanup_frame_table+0x2c>
     fec:	48 89 d0             	mov    %rdx,%rax
     fef:	48 21 f0             	and    %rsi,%rax
     ff2:	48 21 fa             	and    %rdi,%rdx

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
     ff5:	4c 21 c6             	and    %r8,%rsi
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
     ff8:	48 d3 e8             	shr    %cl,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
     ffb:	4c 21 c7             	and    %r8,%rdi
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
     ffe:	48 d3 ea             	shr    %cl,%rdx

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1001:	48 09 f0             	or     %rsi,%rax
    1004:	48 09 fa             	or     %rdi,%rdx

    sva = (unsigned long)pdx_to_page(pfn_to_pdx(spfn));
    1007:	48 be 00 00 00 00 e0 	movabs $0xffff82e000000000,%rsi
    100e:	82 ff ff 
    1011:	48 89 c3             	mov    %rax,%rbx
    eva = (unsigned long)pdx_to_page(pfn_to_pdx(epfn));
    1014:	48 89 d5             	mov    %rdx,%rbp

    /* Intialize all page */
    memset(mfn_to_page(spfn), -1,
    1017:	48 29 c2             	sub    %rax,%rdx
    unsigned long spfn, epfn;

    spfn = info->spfn;
    epfn = info->epfn;

    sva = (unsigned long)pdx_to_page(pfn_to_pdx(spfn));
    101a:	48 c1 e3 05          	shl    $0x5,%rbx
    eva = (unsigned long)pdx_to_page(pfn_to_pdx(epfn));
    101e:	48 c1 e5 05          	shl    $0x5,%rbp

    /* Intialize all page */
    memset(mfn_to_page(spfn), -1,
    1022:	48 c1 e2 05          	shl    $0x5,%rdx
    unsigned long spfn, epfn;

    spfn = info->spfn;
    epfn = info->epfn;

    sva = (unsigned long)pdx_to_page(pfn_to_pdx(spfn));
    1026:	48 01 f3             	add    %rsi,%rbx
    eva = (unsigned long)pdx_to_page(pfn_to_pdx(epfn));
    1029:	48 01 f5             	add    %rsi,%rbp

    /* Intialize all page */
    memset(mfn_to_page(spfn), -1,
    102c:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1031:	48 89 df             	mov    %rbx,%rdi
    1034:	e8 00 00 00 00       	callq  1039 <cleanup_frame_table+0x79>
           (unsigned long)mfn_to_page(epfn) - (unsigned long)mfn_to_page(spfn));

    while (sva < eva)
    1039:	48 39 eb             	cmp    %rbp,%rbx
    103c:	0f 83 de 00 00 00    	jae    1120 <cleanup_frame_table+0x160>
    1042:	4c 8d 3d 00 00 00 00 	lea    0x0(%rip),%r15        # 1049 <cleanup_frame_table+0x89>
    {
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(sva)])[
    1049:	49 bd 00 f0 ff ff ff 	movabs $0xffffffffff000,%r13
    1050:	ff 0f 00 
    1053:	49 be 00 00 00 00 00 	movabs $0xffff830000000000,%r14
    105a:	83 ff ff 
    105d:	eb 18                	jmp    1077 <cleanup_frame_table+0xb7>
    105f:	90                   	nop
          l3_table_offset(sva)];
        if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) ||
             (l3e_get_flags(l3e) & _PAGE_PSE) )
        {
            sva = (sva & ~((1UL << L3_PAGETABLE_SHIFT) - 1)) +
    1060:	48 81 e3 00 00 00 c0 	and    $0xffffffffc0000000,%rbx
    1067:	48 81 c3 00 00 00 40 	add    $0x40000000,%rbx

    /* Intialize all page */
    memset(mfn_to_page(spfn), -1,
           (unsigned long)mfn_to_page(epfn) - (unsigned long)mfn_to_page(spfn));

    while (sva < eva)
    106e:	48 39 dd             	cmp    %rbx,%rbp
    1071:	0f 86 a9 00 00 00    	jbe    1120 <cleanup_frame_table+0x160>
    {
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(sva)])[
    1077:	48 89 d8             	mov    %rbx,%rax
    107a:	4c 89 ea             	mov    %r13,%rdx
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    107d:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 1084 <cleanup_frame_table+0xc4>
    1084:	48 c1 e8 27          	shr    $0x27,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    1088:	48 8b 35 00 00 00 00 	mov    0x0(%rip),%rsi        # 108f <cleanup_frame_table+0xcf>
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    108f:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 1095 <cleanup_frame_table+0xd5>
    1095:	25 ff 01 00 00       	and    $0x1ff,%eax
    109a:	49 23 14 c7          	and    (%r15,%rax,8),%rdx
    109e:	48 89 d0             	mov    %rdx,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    10a1:	48 21 f2             	and    %rsi,%rdx
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    10a4:	48 21 f8             	and    %rdi,%rax
    10a7:	48 d3 e8             	shr    %cl,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    10aa:	48 09 d0             	or     %rdx,%rax
          l3_table_offset(sva)];
    10ad:	48 89 da             	mov    %rbx,%rdx
    10b0:	48 c1 ea 1b          	shr    $0x1b,%rdx
    memset(mfn_to_page(spfn), -1,
           (unsigned long)mfn_to_page(epfn) - (unsigned long)mfn_to_page(spfn));

    while (sva < eva)
    {
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(sva)])[
    10b4:	81 e2 f8 0f 00 00    	and    $0xff8,%edx
    10ba:	48 01 d0             	add    %rdx,%rax
    10bd:	4a 8b 04 30          	mov    (%rax,%r14,1),%rax
          l3_table_offset(sva)];
        if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) ||
    10c1:	89 c2                	mov    %eax,%edx
    10c3:	81 e2 81 00 00 00    	and    $0x81,%edx
    10c9:	83 fa 01             	cmp    $0x1,%edx
    10cc:	75 92                	jne    1060 <cleanup_frame_table+0xa0>
            sva = (sva & ~((1UL << L3_PAGETABLE_SHIFT) - 1)) +
                    (1UL << L3_PAGETABLE_SHIFT);
            continue;
        }

        l2e = l3e_to_l2e(l3e)[l2_table_offset(sva)];
    10ce:	4c 21 e8             	and    %r13,%rax
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    10d1:	48 21 c7             	and    %rax,%rdi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    10d4:	48 21 c6             	and    %rax,%rsi
    10d7:	48 89 d8             	mov    %rbx,%rax
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    10da:	48 d3 ef             	shr    %cl,%rdi
    10dd:	48 c1 e8 12          	shr    $0x12,%rax
    10e1:	25 f8 0f 00 00       	and    $0xff8,%eax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    10e6:	48 09 f7             	or     %rsi,%rdi
    10e9:	48 01 c7             	add    %rax,%rdi
    10ec:	4a 8b 04 37          	mov    (%rdi,%r14,1),%rax
        ASSERT(l2e_get_flags(l2e) & _PAGE_PRESENT);

        if ( (l2e_get_flags(l2e) & (_PAGE_PRESENT | _PAGE_PSE)) ==
    10f0:	89 c2                	mov    %eax,%edx
    10f2:	81 e2 81 00 00 00    	and    $0x81,%edx
    10f8:	81 fa 81 00 00 00    	cmp    $0x81,%edx
    10fe:	74 48                	je     1148 <cleanup_frame_table+0x188>
            continue;
        }

        ASSERT(l1e_get_flags(l2e_to_l1e(l2e)[l1_table_offset(sva)]) &
                _PAGE_PRESENT);
         sva = (sva & ~((1UL << PAGE_SHIFT) - 1)) +
    1100:	48 81 e3 00 f0 ff ff 	and    $0xfffffffffffff000,%rbx
    1107:	48 81 c3 00 10 00 00 	add    $0x1000,%rbx

    /* Intialize all page */
    memset(mfn_to_page(spfn), -1,
           (unsigned long)mfn_to_page(epfn) - (unsigned long)mfn_to_page(spfn));

    while (sva < eva)
    110e:	48 39 dd             	cmp    %rbx,%rbp
    1111:	0f 87 60 ff ff ff    	ja     1077 <cleanup_frame_table+0xb7>
    1117:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    111e:	00 00 
                    (1UL << PAGE_SHIFT);
    }

    /* Brute-Force flush all TLB */
    flush_tlb_all();
}
    1120:	48 83 c4 08          	add    $0x8,%rsp
         sva = (sva & ~((1UL << PAGE_SHIFT) - 1)) +
                    (1UL << PAGE_SHIFT);
    }

    /* Brute-Force flush all TLB */
    flush_tlb_all();
    1124:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 112b <cleanup_frame_table+0x16b>
    112b:	ba 00 01 00 00       	mov    $0x100,%edx
}
    1130:	5b                   	pop    %rbx
    1131:	5d                   	pop    %rbp
    1132:	41 5c                	pop    %r12
    1134:	41 5d                	pop    %r13
    1136:	41 5e                	pop    %r14
    1138:	41 5f                	pop    %r15
         sva = (sva & ~((1UL << PAGE_SHIFT) - 1)) +
                    (1UL << PAGE_SHIFT);
    }

    /* Brute-Force flush all TLB */
    flush_tlb_all();
    113a:	31 f6                	xor    %esi,%esi
    113c:	e9 00 00 00 00       	jmpq   1141 <cleanup_frame_table+0x181>
    1141:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
        ASSERT(l2e_get_flags(l2e) & _PAGE_PRESENT);

        if ( (l2e_get_flags(l2e) & (_PAGE_PRESENT | _PAGE_PSE)) ==
              (_PAGE_PSE | _PAGE_PRESENT) )
        {
            if (hotadd_mem_valid(l2e_get_pfn(l2e), info))
    1148:	4c 21 e8             	and    %r13,%rax
                destroy_xen_mappings(sva & ~((1UL << L2_PAGETABLE_SHIFT) - 1),
                         ((sva & ~((1UL << L2_PAGETABLE_SHIFT) -1 )) +
    114b:	48 81 e3 00 00 e0 ff 	and    $0xffffffffffe00000,%rbx
        ASSERT(l2e_get_flags(l2e) & _PAGE_PRESENT);

        if ( (l2e_get_flags(l2e) & (_PAGE_PRESENT | _PAGE_PSE)) ==
              (_PAGE_PSE | _PAGE_PRESENT) )
        {
            if (hotadd_mem_valid(l2e_get_pfn(l2e), info))
    1152:	48 c1 e8 0c          	shr    $0xc,%rax
    unsigned long cur;
};

int hotadd_mem_valid(unsigned long pfn, struct mem_hotadd_info *info)
{
    return (pfn < info->epfn && pfn >= info->spfn);
    1156:	49 3b 44 24 08       	cmp    0x8(%r12),%rax
    115b:	73 15                	jae    1172 <cleanup_frame_table+0x1b2>
    115d:	49 3b 04 24          	cmp    (%r12),%rax
    1161:	72 0f                	jb     1172 <cleanup_frame_table+0x1b2>

        if ( (l2e_get_flags(l2e) & (_PAGE_PRESENT | _PAGE_PSE)) ==
              (_PAGE_PSE | _PAGE_PRESENT) )
        {
            if (hotadd_mem_valid(l2e_get_pfn(l2e), info))
                destroy_xen_mappings(sva & ~((1UL << L2_PAGETABLE_SHIFT) - 1),
    1163:	48 8d b3 ff ff 1f 00 	lea    0x1fffff(%rbx),%rsi
    116a:	48 89 df             	mov    %rbx,%rdi
    116d:	e8 00 00 00 00       	callq  1172 <cleanup_frame_table+0x1b2>
                         ((sva & ~((1UL << L2_PAGETABLE_SHIFT) -1 )) +
                            (1UL << L2_PAGETABLE_SHIFT) - 1));

            sva = (sva & ~((1UL << L2_PAGETABLE_SHIFT) -1 )) +
    1172:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx
                  (1UL << L2_PAGETABLE_SHIFT);
            continue;
    1179:	e9 f0 fe ff ff       	jmpq   106e <cleanup_frame_table+0xae>
    117e:	66 90                	xchg   %ax,%ax

0000000000001180 <subarch_memory_op>:
        }
    }
}

long subarch_memory_op(int op, XEN_GUEST_HANDLE_PARAM(void) arg)
{
    1180:	48 81 ec f8 05 00 00 	sub    $0x5f8,%rsp
    1187:	48 89 9c 24 c8 05 00 	mov    %rbx,0x5c8(%rsp)
    118e:	00 
    118f:	89 fb                	mov    %edi,%ebx
    1191:	4c 89 bc 24 f0 05 00 	mov    %r15,0x5f0(%rsp)
    1198:	00 
    int target_cpu_num;
    
    unsigned int reg_a, reg_b, reg_c, reg_d;
    unsigned int cpu_family, cpu_model;
    
    switch ( op )
    1199:	8d 43 fb             	lea    -0x5(%rbx),%eax
        }
    }
}

long subarch_memory_op(int op, XEN_GUEST_HANDLE_PARAM(void) arg)
{
    119c:	48 89 ac 24 d0 05 00 	mov    %rbp,0x5d0(%rsp)
    11a3:	00 
    11a4:	4c 89 a4 24 d8 05 00 	mov    %r12,0x5d8(%rsp)
    11ab:	00 
    11ac:	4c 89 ac 24 e0 05 00 	mov    %r13,0x5e0(%rsp)
    11b3:	00 
    11b4:	4c 89 b4 24 e8 05 00 	mov    %r14,0x5e8(%rsp)
    11bb:	00 
    11bc:	49 89 f7             	mov    %rsi,%r15
    int target_cpu_num;
    
    unsigned int reg_a, reg_b, reg_c, reg_d;
    unsigned int cpu_family, cpu_model;
    
    switch ( op )
    11bf:	83 f8 17             	cmp    $0x17,%eax
    l2_pgentry_t l2e;
    unsigned long v;
    xen_pfn_t mfn, last_mfn;
    unsigned int i;
    long rc = 0;
    unsigned long cr0 = 0;    
    11c2:	48 c7 84 24 b8 05 00 	movq   $0x0,0x5b8(%rsp)
    11c9:	00 00 00 00 00 
    int target_cpu_num;
    
    unsigned int reg_a, reg_b, reg_c, reg_d;
    unsigned int cpu_family, cpu_model;
    
    switch ( op )
    11ce:	76 50                	jbe    1220 <subarch_memory_op+0xa0>
            return -EFAULT;
        break;
    }

    default:
        rc = -ENOSYS;
    11d0:	48 c7 c5 da ff ff ff 	mov    $0xffffffffffffffda,%rbp
    11d7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    11de:	00 00 
        break;
    }

    return rc;
}
    11e0:	48 89 e8             	mov    %rbp,%rax
    11e3:	48 8b 9c 24 c8 05 00 	mov    0x5c8(%rsp),%rbx
    11ea:	00 
    11eb:	48 8b ac 24 d0 05 00 	mov    0x5d0(%rsp),%rbp
    11f2:	00 
    11f3:	4c 8b a4 24 d8 05 00 	mov    0x5d8(%rsp),%r12
    11fa:	00 
    11fb:	4c 8b ac 24 e0 05 00 	mov    0x5e0(%rsp),%r13
    1202:	00 
    1203:	4c 8b b4 24 e8 05 00 	mov    0x5e8(%rsp),%r14
    120a:	00 
    120b:	4c 8b bc 24 f0 05 00 	mov    0x5f0(%rsp),%r15
    1212:	00 
    1213:	48 81 c4 f8 05 00 00 	add    $0x5f8,%rsp
    121a:	c3                   	retq   
    121b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    int target_cpu_num;
    
    unsigned int reg_a, reg_b, reg_c, reg_d;
    unsigned int cpu_family, cpu_model;
    
    switch ( op )
    1220:	48 8d 15 00 00 00 00 	lea    0x0(%rip),%rdx        # 1227 <subarch_memory_op+0xa7>
    1227:	48 63 04 82          	movslq (%rdx,%rax,4),%rax
    122b:	48 01 c2             	add    %rax,%rdx
    122e:	ff e2                	jmpq   *%rdx
        return (long) cr0;
    
    case XENMEM_count_perf:
        /*display cpu's family and model*/
        reg_a = 1;/*get cpu family and model*/
        __asm__ __volatile__(
    1230:	bb 01 00 00 00       	mov    $0x1,%ebx
    1235:	89 d8                	mov    %ebx,%eax
    1237:	0f a2                	cpuid  
            "cpuid"
            :"=a" (reg_a), "=b" (reg_b), "=c" (reg_c), "=d" (reg_d)
            :"a" (reg_a)
            :
        );
        cpu_family = ( (reg_a >> 8) & 0xfU ) + ( (reg_a >> 20) & 0xffU );
    1239:	41 89 c6             	mov    %eax,%r14d
        return (long) cr0;
    
    case XENMEM_count_perf:
        /*display cpu's family and model*/
        reg_a = 1;/*get cpu family and model*/
        __asm__ __volatile__(
    123c:	89 c5                	mov    %eax,%ebp
            "cpuid"
            :"=a" (reg_a), "=b" (reg_b), "=c" (reg_c), "=d" (reg_d)
            :"a" (reg_a)
            :
        );
        cpu_family = ( (reg_a >> 8) & 0xfU ) + ( (reg_a >> 20) & 0xffU );
    123e:	c1 e8 08             	shr    $0x8,%eax
    1241:	41 c1 ee 14          	shr    $0x14,%r14d
    1245:	83 e0 0f             	and    $0xf,%eax
        cpu_model = ( ( (reg_a >> 16) & 0xfU ) << 4 ) + ( (reg_a >> 4) & 0xf );
    1248:	41 89 e9             	mov    %ebp,%r9d
            "cpuid"
            :"=a" (reg_a), "=b" (reg_b), "=c" (reg_c), "=d" (reg_d)
            :"a" (reg_a)
            :
        );
        cpu_family = ( (reg_a >> 8) & 0xfU ) + ( (reg_a >> 20) & 0xffU );
    124b:	41 81 e6 ff 00 00 00 	and    $0xff,%r14d
        cpu_model = ( ( (reg_a >> 16) & 0xfU ) << 4 ) + ( (reg_a >> 4) & 0xf );
    1252:	41 c1 e9 0c          	shr    $0xc,%r9d
        return (long) cr0;
    
    case XENMEM_count_perf:
        /*display cpu's family and model*/
        reg_a = 1;/*get cpu family and model*/
        __asm__ __volatile__(
    1256:	41 89 d4             	mov    %edx,%r12d
            "cpuid"
            :"=a" (reg_a), "=b" (reg_b), "=c" (reg_c), "=d" (reg_d)
            :"a" (reg_a)
            :
        );
        cpu_family = ( (reg_a >> 8) & 0xfU ) + ( (reg_a >> 20) & 0xffU );
    1259:	41 01 c6             	add    %eax,%r14d
        cpu_model = ( ( (reg_a >> 16) & 0xfU ) << 4 ) + ( (reg_a >> 4) & 0xf );
    125c:	89 e8                	mov    %ebp,%eax
    125e:	41 81 e1 f0 00 00 00 	and    $0xf0,%r9d
    1265:	c1 e8 04             	shr    $0x4,%eax
        return (long) cr0;
    
    case XENMEM_count_perf:
        /*display cpu's family and model*/
        reg_a = 1;/*get cpu family and model*/
        __asm__ __volatile__(
    1268:	41 89 cd             	mov    %ecx,%r13d
            :"=a" (reg_a), "=b" (reg_b), "=c" (reg_c), "=d" (reg_d)
            :"a" (reg_a)
            :
        );
        cpu_family = ( (reg_a >> 8) & 0xfU ) + ( (reg_a >> 20) & 0xffU );
        cpu_model = ( ( (reg_a >> 16) & 0xfU ) << 4 ) + ( (reg_a >> 4) & 0xf );
    126b:	83 e0 0f             	and    $0xf,%eax
    126e:	41 01 c1             	add    %eax,%r9d
        gdprintk(XENLOG_INFO, "CPU Family:%#010x, Model:%#010x\n", cpu_family, cpu_model );
    1271:	44 89 4c 24 10       	mov    %r9d,0x10(%rsp)
    1276:	e8 00 00 00 00       	callq  127b <subarch_memory_op+0xfb>
    127b:	44 8b 4c 24 10       	mov    0x10(%rsp),%r9d
    1280:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 1287 <subarch_memory_op+0x107>
    1287:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 128e <subarch_memory_op+0x10e>
    128e:	89 c1                	mov    %eax,%ecx
    1290:	45 89 f0             	mov    %r14d,%r8d
    1293:	ba 28 05 00 00       	mov    $0x528,%edx
    1298:	31 c0                	xor    %eax,%eax
    129a:	e8 00 00 00 00       	callq  129f <subarch_memory_op+0x11f>
        gdprintk(XENLOG_INFO, "cpuid: eax:%#010x, ebx:%#010x, ecx:%#010x, edx:%#010x\n", reg_a, reg_b, reg_c, reg_d); 
    129f:	e8 00 00 00 00       	callq  12a4 <subarch_memory_op+0x124>
    12a4:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 12ab <subarch_memory_op+0x12b>
    12ab:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 12b2 <subarch_memory_op+0x132>
    12b2:	41 89 d9             	mov    %ebx,%r9d
    12b5:	89 c1                	mov    %eax,%ecx
    12b7:	ba 29 05 00 00       	mov    $0x529,%edx
    12bc:	31 c0                	xor    %eax,%eax
    12be:	41 89 e8             	mov    %ebp,%r8d
    12c1:	44 89 64 24 08       	mov    %r12d,0x8(%rsp)
    12c6:	44 89 2c 24          	mov    %r13d,(%rsp)
    12ca:	e8 00 00 00 00       	callq  12cf <subarch_memory_op+0x14f>
    12cf:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax

        if( copy_from_guest(&perf_counter, arg,1) )
    12d6:	48 8d 5c 24 20       	lea    0x20(%rsp),%rbx
    12db:	ba 10 05 00 00       	mov    $0x510,%edx
    12e0:	48 21 e0             	and    %rsp,%rax
    12e3:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    12ea:	4c 89 fe             	mov    %r15,%rsi
    12ed:	48 89 df             	mov    %rbx,%rdi
    12f0:	48 8b 40 10          	mov    0x10(%rax),%rax
    12f4:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    12fb:	0f 84 c7 05 00 00    	je     18c8 <subarch_memory_op+0x748>
    1301:	e8 00 00 00 00       	callq  1306 <subarch_memory_op+0x186>
    1306:	48 85 c0             	test   %rax,%rax
            return -EFAULT;
    1309:	48 c7 c5 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rbp
        cpu_family = ( (reg_a >> 8) & 0xfU ) + ( (reg_a >> 20) & 0xffU );
        cpu_model = ( ( (reg_a >> 16) & 0xfU ) << 4 ) + ( (reg_a >> 4) & 0xf );
        gdprintk(XENLOG_INFO, "CPU Family:%#010x, Model:%#010x\n", cpu_family, cpu_model );
        gdprintk(XENLOG_INFO, "cpuid: eax:%#010x, ebx:%#010x, ecx:%#010x, edx:%#010x\n", reg_a, reg_b, reg_c, reg_d); 

        if( copy_from_guest(&perf_counter, arg,1) )
    1310:	0f 85 ca fe ff ff    	jne    11e0 <subarch_memory_op+0x60>
            return -EFAULT;
        dprintk(XENLOG_INFO, "XENMEM_count_perf, perf_counter.in is %#018lx\n", perf_counter.in);
    1316:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
    131b:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 1322 <subarch_memory_op+0x1a2>
    1322:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 1329 <subarch_memory_op+0x1a9>
    1329:	ba 2d 05 00 00       	mov    $0x52d,%edx
    132e:	e8 00 00 00 00       	callq  1333 <subarch_memory_op+0x1b3>
{
	if (nbits <= BITS_PER_LONG)
		*dst = 0UL;
	else {
		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
		memset(dst, 0, len);
    1333:	48 c7 84 24 60 05 00 	movq   $0x0,0x560(%rsp)
    133a:	00 00 00 00 00 
    133f:	48 c7 84 24 68 05 00 	movq   $0x0,0x568(%rsp)
    1346:	00 00 00 00 00 
    134b:	48 c7 84 24 70 05 00 	movq   $0x0,0x570(%rsp)
    1352:	00 00 00 00 00 
    1357:	48 c7 84 24 78 05 00 	movq   $0x0,0x578(%rsp)
    135e:	00 00 00 00 00 
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 */
static inline void set_bit(int nr, volatile void *addr)
{
    asm volatile (
    1363:	f0 0f ba ac 24 60 05 	lock btsl $0x1,0x560(%rsp)
    136a:	00 00 01 
        
        target_cpu_num = 1;
        cpumask_clear(&target_cpu);
        cpumask_set_cpu(target_cpu_num, &target_cpu);
        dprintk(XENLOG_INFO, "cpu mask is set to 1\n");
    136d:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 1374 <subarch_memory_op+0x1f4>
    1374:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 137b <subarch_memory_op+0x1fb>
    137b:	31 c0                	xor    %eax,%eax
    137d:	ba 32 05 00 00       	mov    $0x532,%edx
    1382:	e8 00 00 00 00       	callq  1387 <subarch_memory_op+0x207>
        on_selected_cpus(&target_cpu, &setread_perf_counter, &perf_counter, 1);
    1387:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 138e <subarch_memory_op+0x20e>
    138e:	48 8d bc 24 60 05 00 	lea    0x560(%rsp),%rdi
    1395:	00 
    1396:	48 89 da             	mov    %rbx,%rdx
    1399:	b9 01 00 00 00       	mov    $0x1,%ecx
    139e:	e8 00 00 00 00       	callq  13a3 <subarch_memory_op+0x223>
    13a3:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
//        on_each_cpu(&setread_perf_counter, &perf_counter, 1);
//        setread_perf_counter(&perf_counter);
        if( copy_to_guest(arg, &perf_counter, 1) )
    13aa:	ba 10 05 00 00       	mov    $0x510,%edx
    13af:	48 89 de             	mov    %rbx,%rsi
    13b2:	48 21 e0             	and    %rsp,%rax
    13b5:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    13bc:	4c 89 ff             	mov    %r15,%rdi
    13bf:	48 8b 40 10          	mov    0x10(%rax),%rax
    13c3:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    13ca:	0f 84 18 05 00 00    	je     18e8 <subarch_memory_op+0x768>
                return -EFAULT;
            last_mfn = mfn;
        }

        xmml.nr_extents = i;
        if ( __copy_to_guest(arg, &xmml, 1) )
    13d0:	e8 00 00 00 00       	callq  13d5 <subarch_memory_op+0x255>
            return -EFAULT;
    13d5:	48 83 f8 01          	cmp    $0x1,%rax
    13d9:	48 19 ed             	sbb    %rbp,%rbp
    13dc:	48 f7 d5             	not    %rbp
    13df:	48 83 e5 f2          	and    $0xfffffffffffffff2,%rbp
    13e3:	e9 f8 fd ff ff       	jmpq   11e0 <subarch_memory_op+0x60>
    13e8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    13ef:	00 
    13f0:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    13f7:	48 21 e0             	and    %rsp,%rax
        if( copy_to_guest(arg, &perf_counter, 1) )
            return -EFAULT;
        break;

    case XENMEM_machphys_mfn_list:
        if ( copy_from_guest(&xmml, arg, 1) )
    13fa:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    1401:	48 8b 40 10          	mov    0x10(%rax),%rax
    1405:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    140c:	0f 84 8e 04 00 00    	je     18a0 <subarch_memory_op+0x720>
    1412:	48 8d 84 24 80 05 00 	lea    0x580(%rsp),%rax
    1419:	00 
    141a:	ba 18 00 00 00       	mov    $0x18,%edx
    141f:	48 89 c7             	mov    %rax,%rdi
    1422:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
    1427:	e8 00 00 00 00       	callq  142c <subarch_memory_op+0x2ac>
    142c:	48 85 c0             	test   %rax,%rax
            return -EFAULT;
    142f:	48 c7 c5 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rbp
        if( copy_to_guest(arg, &perf_counter, 1) )
            return -EFAULT;
        break;

    case XENMEM_machphys_mfn_list:
        if ( copy_from_guest(&xmml, arg, 1) )
    1436:	0f 85 a4 fd ff ff    	jne    11e0 <subarch_memory_op+0x60>
            return -EFAULT;

        BUILD_BUG_ON(RDWR_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        BUILD_BUG_ON(RDWR_MPT_VIRT_END   & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        for ( i = 0, v = RDWR_MPT_VIRT_START, last_mfn = 0;
    143c:	8b 84 24 80 05 00 00 	mov    0x580(%rsp),%eax
    1443:	85 c0                	test   %eax,%eax
    1445:	0f 84 f9 03 00 00    	je     1844 <subarch_memory_op+0x6c4>
              (i != xmml.max_extents) &&
              (v < (unsigned long)(machine_to_phys_mapping + max_page));
    144b:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 1452 <subarch_memory_op+0x2d2>
    1452:	48 bb 00 00 00 00 80 	movabs $0xffff828000000000,%rbx
    1459:	82 ff ff 
            return -EFAULT;

        BUILD_BUG_ON(RDWR_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        BUILD_BUG_ON(RDWR_MPT_VIRT_END   & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        for ( i = 0, v = RDWR_MPT_VIRT_START, last_mfn = 0;
              (i != xmml.max_extents) &&
    145c:	31 ed                	xor    %ebp,%ebp
              (v < (unsigned long)(machine_to_phys_mapping + max_page));
    145e:	48 8d 04 c3          	lea    (%rbx,%rax,8),%rax
            return -EFAULT;

        BUILD_BUG_ON(RDWR_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        BUILD_BUG_ON(RDWR_MPT_VIRT_END   & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        for ( i = 0, v = RDWR_MPT_VIRT_START, last_mfn = 0;
              (i != xmml.max_extents) &&
    1462:	48 39 d8             	cmp    %rbx,%rax
    1465:	0f 86 e5 03 00 00    	jbe    1850 <subarch_memory_op+0x6d0>
    146b:	49 c7 c6 00 80 ff ff 	mov    $0xffffffffffff8000,%r14
    1472:	45 31 c0             	xor    %r8d,%r8d
              (v < (unsigned long)(machine_to_phys_mapping + max_page));
              i++, v += 1UL << L2_PAGETABLE_SHIFT )
        {
            l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
    1475:	49 bc 00 f0 ff ff ff 	movabs $0xffffffffff000,%r12
    147c:	ff 0f 00 
    147f:	49 bd 00 00 00 00 00 	movabs $0xffff830000000000,%r13
    1486:	83 ff ff 
    1489:	49 21 e6             	and    %rsp,%r14
    148c:	e9 cd 00 00 00       	jmpq   155e <subarch_memory_op+0x3de>
    1491:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
                l3_table_offset(v)];
            if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
                mfn = last_mfn;
            else if ( !(l3e_get_flags(l3e) & _PAGE_PSE) )
    1498:	81 e2 80 00 00 00    	and    $0x80,%edx
    149e:	0f 85 7c 03 00 00    	jne    1820 <subarch_memory_op+0x6a0>
            {
                l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
    14a4:	4c 21 e0             	and    %r12,%rax
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    14a7:	48 21 c7             	and    %rax,%rdi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    14aa:	48 21 c6             	and    %rax,%rsi
    14ad:	48 89 d8             	mov    %rbx,%rax
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    14b0:	48 d3 ef             	shr    %cl,%rdi
    14b3:	48 c1 e8 12          	shr    $0x12,%rax
    14b7:	25 f8 0f 00 00       	and    $0xff8,%eax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    14bc:	48 09 f7             	or     %rsi,%rdi
    14bf:	48 01 c7             	add    %rax,%rdi
    14c2:	4a 8b 04 2f          	mov    (%rdi,%r13,1),%rax
                if ( l2e_get_flags(l2e) & _PAGE_PRESENT )
    14c6:	a8 01                	test   $0x1,%al
    14c8:	0f 84 04 01 00 00    	je     15d2 <subarch_memory_op+0x452>
                    mfn = l2e_get_pfn(l2e);
    14ce:	4c 21 e0             	and    %r12,%rax
    14d1:	48 c1 e8 0c          	shr    $0xc,%rax
    14d5:	48 89 84 24 b0 05 00 	mov    %rax,0x5b0(%rsp)
    14dc:	00 
    14dd:	0f 1f 00             	nopl   (%rax)
            {
                mfn = l3e_get_pfn(l3e)
                    + (l2_table_offset(v) << PAGETABLE_ORDER);
            }
            ASSERT(mfn);
            if ( copy_to_guest_offset(xmml.extent_start, i, &mfn, 1) )
    14e0:	49 8b 96 e8 7f 00 00 	mov    0x7fe8(%r14),%rdx
    14e7:	48 8b 84 24 88 05 00 	mov    0x588(%rsp),%rax
    14ee:	00 
    14ef:	48 8d b4 24 b0 05 00 	lea    0x5b0(%rsp),%rsi
    14f6:	00 
    14f7:	48 8b 52 10          	mov    0x10(%rdx),%rdx
    14fb:	80 ba e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rdx)
    1502:	89 ea                	mov    %ebp,%edx
    1504:	48 8d 3c d0          	lea    (%rax,%rdx,8),%rdi
    1508:	ba 08 00 00 00       	mov    $0x8,%edx
    150d:	0f 84 fd 02 00 00    	je     1810 <subarch_memory_op+0x690>
    1513:	e8 00 00 00 00       	callq  1518 <subarch_memory_op+0x398>
    1518:	48 85 c0             	test   %rax,%rax
    151b:	0f 85 d7 03 00 00    	jne    18f8 <subarch_memory_op+0x778>
        BUILD_BUG_ON(RDWR_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        BUILD_BUG_ON(RDWR_MPT_VIRT_END   & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        for ( i = 0, v = RDWR_MPT_VIRT_START, last_mfn = 0;
              (i != xmml.max_extents) &&
              (v < (unsigned long)(machine_to_phys_mapping + max_page));
              i++, v += 1UL << L2_PAGETABLE_SHIFT )
    1521:	83 c5 01             	add    $0x1,%ebp
        if ( copy_from_guest(&xmml, arg, 1) )
            return -EFAULT;

        BUILD_BUG_ON(RDWR_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        BUILD_BUG_ON(RDWR_MPT_VIRT_END   & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        for ( i = 0, v = RDWR_MPT_VIRT_START, last_mfn = 0;
    1524:	39 ac 24 80 05 00 00 	cmp    %ebp,0x580(%rsp)
                    + (l2_table_offset(v) << PAGETABLE_ORDER);
            }
            ASSERT(mfn);
            if ( copy_to_guest_offset(xmml.extent_start, i, &mfn, 1) )
                return -EFAULT;
            last_mfn = mfn;
    152b:	4c 8b 84 24 b0 05 00 	mov    0x5b0(%rsp),%r8
    1532:	00 
        if ( copy_from_guest(&xmml, arg, 1) )
            return -EFAULT;

        BUILD_BUG_ON(RDWR_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        BUILD_BUG_ON(RDWR_MPT_VIRT_END   & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        for ( i = 0, v = RDWR_MPT_VIRT_START, last_mfn = 0;
    1533:	0f 84 17 03 00 00    	je     1850 <subarch_memory_op+0x6d0>
              (i != xmml.max_extents) &&
              (v < (unsigned long)(machine_to_phys_mapping + max_page));
    1539:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 1540 <subarch_memory_op+0x3c0>
    1540:	48 ba 00 00 00 00 80 	movabs $0xffff828000000000,%rdx
    1547:	82 ff ff 
              i++, v += 1UL << L2_PAGETABLE_SHIFT )
    154a:	48 81 c3 00 00 20 00 	add    $0x200000,%rbx

        BUILD_BUG_ON(RDWR_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        BUILD_BUG_ON(RDWR_MPT_VIRT_END   & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        for ( i = 0, v = RDWR_MPT_VIRT_START, last_mfn = 0;
              (i != xmml.max_extents) &&
              (v < (unsigned long)(machine_to_phys_mapping + max_page));
    1551:	48 8d 04 c2          	lea    (%rdx,%rax,8),%rax
            return -EFAULT;

        BUILD_BUG_ON(RDWR_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        BUILD_BUG_ON(RDWR_MPT_VIRT_END   & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        for ( i = 0, v = RDWR_MPT_VIRT_START, last_mfn = 0;
              (i != xmml.max_extents) &&
    1555:	48 39 d8             	cmp    %rbx,%rax
    1558:	0f 86 f2 02 00 00    	jbe    1850 <subarch_memory_op+0x6d0>
              (v < (unsigned long)(machine_to_phys_mapping + max_page));
              i++, v += 1UL << L2_PAGETABLE_SHIFT )
        {
            l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
    155e:	48 89 d8             	mov    %rbx,%rax
    1561:	48 8d 0d 00 00 00 00 	lea    0x0(%rip),%rcx        # 1568 <subarch_memory_op+0x3e8>
    1568:	4c 89 e2             	mov    %r12,%rdx
    156b:	48 c1 e8 27          	shr    $0x27,%rax
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    156f:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 1576 <subarch_memory_op+0x3f6>

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    1576:	48 8b 35 00 00 00 00 	mov    0x0(%rip),%rsi        # 157d <subarch_memory_op+0x3fd>
    157d:	25 ff 01 00 00       	and    $0x1ff,%eax
    1582:	48 23 14 c1          	and    (%rcx,%rax,8),%rdx
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    1586:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 158c <subarch_memory_op+0x40c>
    158c:	48 89 d0             	mov    %rdx,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    158f:	48 21 f2             	and    %rsi,%rdx
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    1592:	48 21 f8             	and    %rdi,%rax
    1595:	48 d3 e8             	shr    %cl,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    1598:	48 09 d0             	or     %rdx,%rax
                l3_table_offset(v)];
    159b:	48 89 da             	mov    %rbx,%rdx
    159e:	48 c1 ea 1b          	shr    $0x1b,%rdx
        for ( i = 0, v = RDWR_MPT_VIRT_START, last_mfn = 0;
              (i != xmml.max_extents) &&
              (v < (unsigned long)(machine_to_phys_mapping + max_page));
              i++, v += 1UL << L2_PAGETABLE_SHIFT )
        {
            l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
    15a2:	81 e2 f8 0f 00 00    	and    $0xff8,%edx
    15a8:	48 01 d0             	add    %rdx,%rax
    15ab:	4a 8b 04 28          	mov    (%rax,%r13,1),%rax
                l3_table_offset(v)];
            if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
    15af:	48 89 c2             	mov    %rax,%rdx
    15b2:	41 89 c1             	mov    %eax,%r9d
    15b5:	48 c1 ea 28          	shr    $0x28,%rdx
    15b9:	41 81 e1 ff 0f 00 00 	and    $0xfff,%r9d
    15c0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    15c6:	44 09 ca             	or     %r9d,%edx
    15c9:	f6 c2 01             	test   $0x1,%dl
    15cc:	0f 85 c6 fe ff ff    	jne    1498 <subarch_memory_op+0x318>
            {
                l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
                if ( l2e_get_flags(l2e) & _PAGE_PRESENT )
                    mfn = l2e_get_pfn(l2e);
                else
                    mfn = last_mfn;
    15d2:	4c 89 84 24 b0 05 00 	mov    %r8,0x5b0(%rsp)
    15d9:	00 
    15da:	e9 01 ff ff ff       	jmpq   14e0 <subarch_memory_op+0x360>
    15df:	90                   	nop
            return -EFAULT;

        break;

    case XENMEM_get_sharing_freed_pages:
        return mem_sharing_get_nr_saved_mfns();
    15e0:	e8 00 00 00 00       	callq  15e5 <subarch_memory_op+0x465>
    15e5:	89 c5                	mov    %eax,%ebp
    15e7:	e9 f4 fb ff ff       	jmpq   11e0 <subarch_memory_op+0x60>
    15ec:	0f 1f 40 00          	nopl   0x0(%rax)
    15f0:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
        break;
    }
    case XENMEM_sharing_op:
    {
        xen_mem_sharing_op_t mso;
        if ( copy_from_guest(&mso, arg, 1) )
    15f7:	48 8d 9c 24 30 05 00 	lea    0x530(%rsp),%rbx
    15fe:	00 
    15ff:	ba 30 00 00 00       	mov    $0x30,%edx
    1604:	48 21 e0             	and    %rsp,%rax
    1607:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    160e:	48 89 df             	mov    %rbx,%rdi
    1611:	48 8b 40 10          	mov    0x10(%rax),%rax
    1615:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    161c:	0f 84 6e 02 00 00    	je     1890 <subarch_memory_op+0x710>
    1622:	e8 00 00 00 00       	callq  1627 <subarch_memory_op+0x4a7>
    1627:	48 85 c0             	test   %rax,%rax
            return -EFAULT;
    162a:	48 c7 c5 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rbp
        break;
    }
    case XENMEM_sharing_op:
    {
        xen_mem_sharing_op_t mso;
        if ( copy_from_guest(&mso, arg, 1) )
    1631:	0f 85 a9 fb ff ff    	jne    11e0 <subarch_memory_op+0x60>
            return -EFAULT;
        if ( mso.op == XENMEM_sharing_op_audit )
    1637:	80 bc 24 30 05 00 00 	cmpb   $0x8,0x530(%rsp)
    163e:	08 
    163f:	0f 84 c3 02 00 00    	je     1908 <subarch_memory_op+0x788>
            return mem_sharing_audit(); 
        rc = do_mem_event_op(op, mso.domain, (void *) &mso);
    1645:	0f b7 b4 24 32 05 00 	movzwl 0x532(%rsp),%esi
    164c:	00 
    164d:	48 89 da             	mov    %rbx,%rdx
    1650:	bf 16 00 00 00       	mov    $0x16,%edi
    1655:	e8 00 00 00 00       	callq  165a <subarch_memory_op+0x4da>
    165a:	48 63 e8             	movslq %eax,%rbp
        if ( !rc && __copy_to_guest(arg, &mso, 1) )
    165d:	48 85 ed             	test   %rbp,%rbp
    1660:	0f 85 7a fb ff ff    	jne    11e0 <subarch_memory_op+0x60>
    1666:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    166d:	ba 30 00 00 00       	mov    $0x30,%edx
    1672:	48 89 de             	mov    %rbx,%rsi
    1675:	48 21 e0             	and    %rsp,%rax
    1678:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    167f:	4c 89 ff             	mov    %r15,%rdi
    1682:	48 8b 40 10          	mov    0x10(%rax),%rax
    1686:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    168d:	0f 85 5f 01 00 00    	jne    17f2 <subarch_memory_op+0x672>
        case 8:
            __put_user_size(*(const u64 *)from, (u64 __user *)to, 8, ret, 8);
            return ret;
        }
    }
    return __copy_to_user_ll(to, from, n);
    1693:	e8 00 00 00 00       	callq  1698 <subarch_memory_op+0x518>
    1698:	e9 5a 01 00 00       	jmpq   17f7 <subarch_memory_op+0x677>
    169d:	0f 1f 00             	nopl   (%rax)
static inline void on_each_cpu(
    void (*func) (void *info),
    void *info,
    int wait)
{
    on_selected_cpus(&cpu_online_map, func, info, wait);
    16a0:	48 8d 94 24 b8 05 00 	lea    0x5b8(%rsp),%rdx
    16a7:	00 
    16a8:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 16af <subarch_memory_op+0x52f>
    16af:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 16b6 <subarch_memory_op+0x536>
    16b6:	b9 01 00 00 00       	mov    $0x1,%ecx
    switch ( op )
    {
    case XENMEM_disable_cache:
        on_each_cpu(&disable_cache, &cr0,1);
        printk("<1>disable cache! cr0=%#018lx\n", cr0);
        rc = 0;
    16bb:	31 ed                	xor    %ebp,%ebp
    16bd:	e8 00 00 00 00       	callq  16c2 <subarch_memory_op+0x542>
    
    switch ( op )
    {
    case XENMEM_disable_cache:
        on_each_cpu(&disable_cache, &cr0,1);
        printk("<1>disable cache! cr0=%#018lx\n", cr0);
    16c2:	48 8b b4 24 b8 05 00 	mov    0x5b8(%rsp),%rsi
    16c9:	00 
    16ca:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 16d1 <subarch_memory_op+0x551>
    16d1:	31 c0                	xor    %eax,%eax
    16d3:	e8 00 00 00 00       	callq  16d8 <subarch_memory_op+0x558>
        rc = 0;
        break;
    16d8:	e9 03 fb ff ff       	jmpq   11e0 <subarch_memory_op+0x60>
    16dd:	0f 1f 00             	nopl   (%rax)
    16e0:	48 8d 94 24 b8 05 00 	lea    0x5b8(%rsp),%rdx
    16e7:	00 
    16e8:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 16ef <subarch_memory_op+0x56f>
    16ef:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 16f6 <subarch_memory_op+0x576>
    16f6:	b9 01 00 00 00       	mov    $0x1,%ecx

    case XENMEM_enable_cache:
        on_each_cpu(&enable_cache, &cr0 , 1);
        printk("<1>enable cache; cr0=%#018lx\n", cr0);
        rc = 0;
    16fb:	31 ed                	xor    %ebp,%ebp
    16fd:	e8 00 00 00 00       	callq  1702 <subarch_memory_op+0x582>
        rc = 0;
        break;

    case XENMEM_enable_cache:
        on_each_cpu(&enable_cache, &cr0 , 1);
        printk("<1>enable cache; cr0=%#018lx\n", cr0);
    1702:	48 8b b4 24 b8 05 00 	mov    0x5b8(%rsp),%rsi
    1709:	00 
    170a:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 1711 <subarch_memory_op+0x591>
    1711:	31 c0                	xor    %eax,%eax
    1713:	e8 00 00 00 00       	callq  1718 <subarch_memory_op+0x598>
        rc = 0;
        break;
    1718:	e9 c3 fa ff ff       	jmpq   11e0 <subarch_memory_op+0x60>
    171d:	0f 1f 00             	nopl   (%rax)

    case XENMEM_show_cache:
        __asm__ __volatile__("pushq %%rax\n\t"
    1720:	50                   	push   %rax
    1721:	0f 20 c0             	mov    %cr0,%rax
    1724:	48 89 c6             	mov    %rax,%rsi
    1727:	58                   	pop    %rax
                            :"=r" (cr0)
                            :
                            :
            );
        //gdprintk(XENLOG_WARNING, "gdprintk:XENMEM_show_cache_status! CR0 value is %#018lx\n", cr0);
        printk("<1>CR0 value is %#018lx\n",cr0);
    1728:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 172f <subarch_memory_op+0x5af>
    172f:	31 c0                	xor    %eax,%eax
        printk("<1>enable cache; cr0=%#018lx\n", cr0);
        rc = 0;
        break;

    case XENMEM_show_cache:
        __asm__ __volatile__("pushq %%rax\n\t"
    1731:	48 89 b4 24 b8 05 00 	mov    %rsi,0x5b8(%rsp)
    1738:	00 
                            :"=r" (cr0)
                            :
                            :
            );
        //gdprintk(XENLOG_WARNING, "gdprintk:XENMEM_show_cache_status! CR0 value is %#018lx\n", cr0);
        printk("<1>CR0 value is %#018lx\n",cr0);
    1739:	e8 00 00 00 00       	callq  173e <subarch_memory_op+0x5be>
        return (long) cr0;
    173e:	48 8b ac 24 b8 05 00 	mov    0x5b8(%rsp),%rbp
    1745:	00 
    1746:	e9 95 fa ff ff       	jmpq   11e0 <subarch_memory_op+0x60>
    174b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

    case XENMEM_get_sharing_freed_pages:
        return mem_sharing_get_nr_saved_mfns();

    case XENMEM_get_sharing_shared_pages:
        return mem_sharing_get_nr_shared_mfns();
    1750:	e8 00 00 00 00       	callq  1755 <subarch_memory_op+0x5d5>
    1755:	89 c5                	mov    %eax,%ebp
    1757:	e9 84 fa ff ff       	jmpq   11e0 <subarch_memory_op+0x60>
    175c:	0f 1f 40 00          	nopl   0x0(%rax)
    1760:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax

    case XENMEM_paging_op:
    case XENMEM_access_op:
    {
        xen_mem_event_op_t meo;
        if ( copy_from_guest(&meo, arg, 1) )
    1767:	4c 8d a4 24 98 05 00 	lea    0x598(%rsp),%r12
    176e:	00 
    176f:	ba 18 00 00 00       	mov    $0x18,%edx
    1774:	48 21 e0             	and    %rsp,%rax
    1777:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    177e:	4c 89 e7             	mov    %r12,%rdi
    1781:	48 8b 40 10          	mov    0x10(%rax),%rax
    1785:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    178c:	0f 84 46 01 00 00    	je     18d8 <subarch_memory_op+0x758>
    1792:	e8 00 00 00 00       	callq  1797 <subarch_memory_op+0x617>
    1797:	48 85 c0             	test   %rax,%rax
            return -EFAULT;
    179a:	48 c7 c5 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rbp

    case XENMEM_paging_op:
    case XENMEM_access_op:
    {
        xen_mem_event_op_t meo;
        if ( copy_from_guest(&meo, arg, 1) )
    17a1:	0f 85 39 fa ff ff    	jne    11e0 <subarch_memory_op+0x60>
            return -EFAULT;
        rc = do_mem_event_op(op, meo.domain, (void *) &meo);
    17a7:	0f b7 b4 24 9a 05 00 	movzwl 0x59a(%rsp),%esi
    17ae:	00 
    17af:	4c 89 e2             	mov    %r12,%rdx
    17b2:	89 df                	mov    %ebx,%edi
    17b4:	e8 00 00 00 00       	callq  17b9 <subarch_memory_op+0x639>
    17b9:	48 63 e8             	movslq %eax,%rbp
        if ( !rc && __copy_to_guest(arg, &meo, 1) )
    17bc:	48 85 ed             	test   %rbp,%rbp
    17bf:	0f 85 1b fa ff ff    	jne    11e0 <subarch_memory_op+0x60>
    17c5:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    17cc:	ba 18 00 00 00       	mov    $0x18,%edx
    17d1:	4c 89 e6             	mov    %r12,%rsi
    17d4:	48 21 e0             	and    %rsp,%rax
    17d7:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    17de:	4c 89 ff             	mov    %r15,%rdi
    17e1:	48 8b 40 10          	mov    0x10(%rax),%rax
    17e5:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    17ec:	0f 84 a1 fe ff ff    	je     1693 <subarch_memory_op+0x513>
        if ( copy_from_guest(&mso, arg, 1) )
            return -EFAULT;
        if ( mso.op == XENMEM_sharing_op_audit )
            return mem_sharing_audit(); 
        rc = do_mem_event_op(op, mso.domain, (void *) &mso);
        if ( !rc && __copy_to_guest(arg, &mso, 1) )
    17f2:	e8 00 00 00 00       	callq  17f7 <subarch_memory_op+0x677>
            return -EFAULT;
    17f7:	48 85 c0             	test   %rax,%rax
    17fa:	48 c7 c0 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rax
    1801:	48 0f 45 e8          	cmovne %rax,%rbp
    1805:	e9 d6 f9 ff ff       	jmpq   11e0 <subarch_memory_op+0x60>
    180a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
            {
                mfn = l3e_get_pfn(l3e)
                    + (l2_table_offset(v) << PAGETABLE_ORDER);
            }
            ASSERT(mfn);
            if ( copy_to_guest_offset(xmml.extent_start, i, &mfn, 1) )
    1810:	e8 00 00 00 00       	callq  1815 <subarch_memory_op+0x695>
    1815:	e9 fe fc ff ff       	jmpq   1518 <subarch_memory_op+0x398>
    181a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
                    mfn = last_mfn;
            }
            else
            {
                mfn = l3e_get_pfn(l3e)
                    + (l2_table_offset(v) << PAGETABLE_ORDER);
    1820:	48 89 da             	mov    %rbx,%rdx
                else
                    mfn = last_mfn;
            }
            else
            {
                mfn = l3e_get_pfn(l3e)
    1823:	4c 21 e0             	and    %r12,%rax
                    + (l2_table_offset(v) << PAGETABLE_ORDER);
    1826:	48 c1 ea 0c          	shr    $0xc,%rdx
                else
                    mfn = last_mfn;
            }
            else
            {
                mfn = l3e_get_pfn(l3e)
    182a:	48 c1 e8 0c          	shr    $0xc,%rax
                    + (l2_table_offset(v) << PAGETABLE_ORDER);
    182e:	81 e2 00 fe 03 00    	and    $0x3fe00,%edx
    1834:	48 01 d0             	add    %rdx,%rax
    1837:	48 89 84 24 b0 05 00 	mov    %rax,0x5b0(%rsp)
    183e:	00 
    183f:	e9 9c fc ff ff       	jmpq   14e0 <subarch_memory_op+0x360>
        if ( copy_from_guest(&xmml, arg, 1) )
            return -EFAULT;

        BUILD_BUG_ON(RDWR_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        BUILD_BUG_ON(RDWR_MPT_VIRT_END   & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        for ( i = 0, v = RDWR_MPT_VIRT_START, last_mfn = 0;
    1844:	31 ed                	xor    %ebp,%ebp
    1846:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    184d:	00 00 00 
    1850:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
            if ( copy_to_guest_offset(xmml.extent_start, i, &mfn, 1) )
                return -EFAULT;
            last_mfn = mfn;
        }

        xmml.nr_extents = i;
    1857:	89 ac 24 90 05 00 00 	mov    %ebp,0x590(%rsp)
        if ( __copy_to_guest(arg, &xmml, 1) )
    185e:	ba 18 00 00 00       	mov    $0x18,%edx
    1863:	48 21 e0             	and    %rsp,%rax
    1866:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    186d:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
    1872:	4c 89 ff             	mov    %r15,%rdi
    1875:	48 8b 40 10          	mov    0x10(%rax),%rax
    1879:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    1880:	0f 85 4a fb ff ff    	jne    13d0 <subarch_memory_op+0x250>
    1886:	e8 00 00 00 00       	callq  188b <subarch_memory_op+0x70b>
    188b:	e9 45 fb ff ff       	jmpq   13d5 <subarch_memory_op+0x255>
        break;
    }
    case XENMEM_sharing_op:
    {
        xen_mem_sharing_op_t mso;
        if ( copy_from_guest(&mso, arg, 1) )
    1890:	e8 00 00 00 00       	callq  1895 <subarch_memory_op+0x715>
    1895:	e9 8d fd ff ff       	jmpq   1627 <subarch_memory_op+0x4a7>
    189a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
        if( copy_to_guest(arg, &perf_counter, 1) )
            return -EFAULT;
        break;

    case XENMEM_machphys_mfn_list:
        if ( copy_from_guest(&xmml, arg, 1) )
    18a0:	48 8d 94 24 80 05 00 	lea    0x580(%rsp),%rdx
    18a7:	00 
    18a8:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
    18ad:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
    18b2:	ba 18 00 00 00       	mov    $0x18,%edx
    18b7:	e8 00 00 00 00       	callq  18bc <subarch_memory_op+0x73c>
    18bc:	e9 6b fb ff ff       	jmpq   142c <subarch_memory_op+0x2ac>
    18c1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
        cpu_family = ( (reg_a >> 8) & 0xfU ) + ( (reg_a >> 20) & 0xffU );
        cpu_model = ( ( (reg_a >> 16) & 0xfU ) << 4 ) + ( (reg_a >> 4) & 0xf );
        gdprintk(XENLOG_INFO, "CPU Family:%#010x, Model:%#010x\n", cpu_family, cpu_model );
        gdprintk(XENLOG_INFO, "cpuid: eax:%#010x, ebx:%#010x, ecx:%#010x, edx:%#010x\n", reg_a, reg_b, reg_c, reg_d); 

        if( copy_from_guest(&perf_counter, arg,1) )
    18c8:	e8 00 00 00 00       	callq  18cd <subarch_memory_op+0x74d>
    18cd:	0f 1f 00             	nopl   (%rax)
    18d0:	e9 31 fa ff ff       	jmpq   1306 <subarch_memory_op+0x186>
    18d5:	0f 1f 00             	nopl   (%rax)

    case XENMEM_paging_op:
    case XENMEM_access_op:
    {
        xen_mem_event_op_t meo;
        if ( copy_from_guest(&meo, arg, 1) )
    18d8:	e8 00 00 00 00       	callq  18dd <subarch_memory_op+0x75d>
    18dd:	0f 1f 00             	nopl   (%rax)
    18e0:	e9 b2 fe ff ff       	jmpq   1797 <subarch_memory_op+0x617>
    18e5:	0f 1f 00             	nopl   (%rax)
        cpumask_set_cpu(target_cpu_num, &target_cpu);
        dprintk(XENLOG_INFO, "cpu mask is set to 1\n");
        on_selected_cpus(&target_cpu, &setread_perf_counter, &perf_counter, 1);
//        on_each_cpu(&setread_perf_counter, &perf_counter, 1);
//        setread_perf_counter(&perf_counter);
        if( copy_to_guest(arg, &perf_counter, 1) )
    18e8:	e8 00 00 00 00       	callq  18ed <subarch_memory_op+0x76d>
    18ed:	0f 1f 00             	nopl   (%rax)
    18f0:	e9 e0 fa ff ff       	jmpq   13d5 <subarch_memory_op+0x255>
    18f5:	0f 1f 00             	nopl   (%rax)
                mfn = l3e_get_pfn(l3e)
                    + (l2_table_offset(v) << PAGETABLE_ORDER);
            }
            ASSERT(mfn);
            if ( copy_to_guest_offset(xmml.extent_start, i, &mfn, 1) )
                return -EFAULT;
    18f8:	48 c7 c5 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rbp
    18ff:	e9 dc f8 ff ff       	jmpq   11e0 <subarch_memory_op+0x60>
    1904:	0f 1f 40 00          	nopl   0x0(%rax)
    {
        xen_mem_sharing_op_t mso;
        if ( copy_from_guest(&mso, arg, 1) )
            return -EFAULT;
        if ( mso.op == XENMEM_sharing_op_audit )
            return mem_sharing_audit(); 
    1908:	e8 00 00 00 00       	callq  190d <subarch_memory_op+0x78d>
    190d:	48 63 e8             	movslq %eax,%rbp
    1910:	e9 cb f8 ff ff       	jmpq   11e0 <subarch_memory_op+0x60>
    1915:	66 66 2e 0f 1f 84 00 	data32 nopw %cs:0x0(%rax,%rax,1)
    191c:	00 00 00 00 

0000000000001920 <do_stack_switch>:
    1920:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    return rc;
}

long do_stack_switch(unsigned long ss, unsigned long esp)
{
    fixup_guest_stack_selector(current->domain, ss);
    1927:	48 89 fa             	mov    %rdi,%rdx
    192a:	48 21 e0             	and    %rsp,%rax
    192d:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    1934:	48 8b 40 10          	mov    0x10(%rax),%rax
    1938:	80 b8 3c 0c 00 00 01 	cmpb   $0x1,0xc3c(%rax)
    193f:	48 19 c0             	sbb    %rax,%rax
    1942:	83 e2 03             	and    $0x3,%edx
    1945:	83 e0 02             	and    $0x2,%eax
    1948:	48 83 c0 01          	add    $0x1,%rax
    194c:	48 39 c2             	cmp    %rax,%rdx
    194f:	73 07                	jae    1958 <do_stack_switch+0x38>
    1951:	48 83 e7 fc          	and    $0xfffffffffffffffc,%rdi
    1955:	48 09 c7             	or     %rax,%rdi
    1958:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    195f:	48 21 e0             	and    %rsp,%rax
    current->arch.pv_vcpu.kernel_ss = ss;
    1962:	48 8b 90 e8 7f 00 00 	mov    0x7fe8(%rax),%rdx
    1969:	48 89 ba 50 04 00 00 	mov    %rdi,0x450(%rdx)
    current->arch.pv_vcpu.kernel_sp = esp;
    1970:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    1977:	48 89 b0 58 04 00 00 	mov    %rsi,0x458(%rax)
    return 0;
}
    197e:	31 c0                	xor    %eax,%eax
    1980:	c3                   	retq   
    1981:	66 66 66 66 66 66 2e 	data32 data32 data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)
    1988:	0f 1f 84 00 00 00 00 
    198f:	00 

0000000000001990 <do_set_segment_base>:
    1990:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    1997:	48 21 e0             	and    %rsp,%rax
long do_set_segment_base(unsigned int which, unsigned long base)
{
    struct vcpu *v = current;
    long ret = 0;

    switch ( which )
    199a:	83 ff 01             	cmp    $0x1,%edi
    return 0;
}

long do_set_segment_base(unsigned int which, unsigned long base)
{
    struct vcpu *v = current;
    199d:	4c 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%r8
    long ret = 0;

    switch ( which )
    19a4:	74 62                	je     1a08 <do_set_segment_base+0x78>
    19a6:	72 18                	jb     19c0 <do_set_segment_base+0x30>
    19a8:	83 ff 02             	cmp    $0x2,%edi
    19ab:	0f 84 7f 00 00 00    	je     1a30 <do_set_segment_base+0xa0>
    19b1:	83 ff 03             	cmp    $0x3,%edi
            _ASM_EXTABLE(1b, 2b)
            : : "r" (base&0xffff) );
        break;

    default:
        ret = -EINVAL;
    19b4:	48 c7 c0 ea ff ff ff 	mov    $0xffffffffffffffea,%rax
long do_set_segment_base(unsigned int which, unsigned long base)
{
    struct vcpu *v = current;
    long ret = 0;

    switch ( which )
    19bb:	74 33                	je     19f0 <do_set_segment_base+0x60>
        ret = -EINVAL;
        break;
    }

    return ret;
}
    19bd:	f3 c3                	repz retq 
    19bf:	90                   	nop
static inline int wrmsr_safe(unsigned int msr, uint64_t val)
{
    int _rc;
    uint32_t lo, hi;
    lo = (uint32_t)val;
    hi = (uint32_t)(val >> 32);
    19c0:	48 89 f2             	mov    %rsi,%rdx

    __asm__ __volatile__(
    19c3:	31 ff                	xor    %edi,%edi
    19c5:	b9 00 01 00 c0       	mov    $0xc0000100,%ecx
static inline int wrmsr_safe(unsigned int msr, uint64_t val)
{
    int _rc;
    uint32_t lo, hi;
    lo = (uint32_t)val;
    hi = (uint32_t)(val >> 32);
    19ca:	48 c1 ea 20          	shr    $0x20,%rdx

    __asm__ __volatile__(
    19ce:	89 f0                	mov    %esi,%eax
    19d0:	0f 30                	wrmsr  
    long ret = 0;

    switch ( which )
    {
    case SEGBASE_FS:
        if ( wrmsr_safe(MSR_FS_BASE, base) )
    19d2:	85 ff                	test   %edi,%edi
            ret = -EFAULT;
    19d4:	48 c7 c0 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rax
    long ret = 0;

    switch ( which )
    {
    case SEGBASE_FS:
        if ( wrmsr_safe(MSR_FS_BASE, base) )
    19db:	75 e0                	jne    19bd <do_set_segment_base+0x2d>
            ret = -EFAULT;
        else
            v->arch.pv_vcpu.fs_base = base;
    19dd:	49 89 b0 d8 04 00 00 	mov    %rsi,0x4d8(%r8)
}

long do_set_segment_base(unsigned int which, unsigned long base)
{
    struct vcpu *v = current;
    long ret = 0;
    19e4:	31 c0                	xor    %eax,%eax
    19e6:	c3                   	retq   
    19e7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    19ee:	00 00 
            ".section .fixup,\"ax\"   \n"
            "2:   xorl %k0,%k0        \n"
            "     jmp  1b             \n"
            ".previous                \n"
            _ASM_EXTABLE(1b, 2b)
            : : "r" (base&0xffff) );
    19f0:	81 e6 ff ff 00 00    	and    $0xffff,%esi
        else
            v->arch.pv_vcpu.gs_base_kernel = base;
        break;

    case SEGBASE_GS_USER_SEL:
        __asm__ __volatile__ (
    19f6:	0f 01 f8             	swapgs 
    19f9:	8e ee                	mov    %esi,%gs
    19fb:	0f ae f0             	mfence 
    19fe:	0f 01 f8             	swapgs 
}

long do_set_segment_base(unsigned int which, unsigned long base)
{
    struct vcpu *v = current;
    long ret = 0;
    1a01:	31 c0                	xor    %eax,%eax
            "2:   xorl %k0,%k0        \n"
            "     jmp  1b             \n"
            ".previous                \n"
            _ASM_EXTABLE(1b, 2b)
            : : "r" (base&0xffff) );
        break;
    1a03:	c3                   	retq   
    1a04:	0f 1f 40 00          	nopl   0x0(%rax)
static inline int wrmsr_safe(unsigned int msr, uint64_t val)
{
    int _rc;
    uint32_t lo, hi;
    lo = (uint32_t)val;
    hi = (uint32_t)(val >> 32);
    1a08:	48 89 f2             	mov    %rsi,%rdx

    __asm__ __volatile__(
    1a0b:	31 ff                	xor    %edi,%edi
    1a0d:	b9 02 01 00 c0       	mov    $0xc0000102,%ecx
static inline int wrmsr_safe(unsigned int msr, uint64_t val)
{
    int _rc;
    uint32_t lo, hi;
    lo = (uint32_t)val;
    hi = (uint32_t)(val >> 32);
    1a12:	48 c1 ea 20          	shr    $0x20,%rdx

    __asm__ __volatile__(
    1a16:	89 f0                	mov    %esi,%eax
    1a18:	0f 30                	wrmsr  
        else
            v->arch.pv_vcpu.fs_base = base;
        break;

    case SEGBASE_GS_USER:
        if ( wrmsr_safe(MSR_SHADOW_GS_BASE, base) )
    1a1a:	85 ff                	test   %edi,%edi
            ret = -EFAULT;
    1a1c:	48 c7 c0 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rax
        else
            v->arch.pv_vcpu.fs_base = base;
        break;

    case SEGBASE_GS_USER:
        if ( wrmsr_safe(MSR_SHADOW_GS_BASE, base) )
    1a23:	75 98                	jne    19bd <do_set_segment_base+0x2d>
            ret = -EFAULT;
        else
            v->arch.pv_vcpu.gs_base_user = base;
    1a25:	49 89 b0 e8 04 00 00 	mov    %rsi,0x4e8(%r8)
}

long do_set_segment_base(unsigned int which, unsigned long base)
{
    struct vcpu *v = current;
    long ret = 0;
    1a2c:	31 c0                	xor    %eax,%eax
    1a2e:	c3                   	retq   
    1a2f:	90                   	nop
static inline int wrmsr_safe(unsigned int msr, uint64_t val)
{
    int _rc;
    uint32_t lo, hi;
    lo = (uint32_t)val;
    hi = (uint32_t)(val >> 32);
    1a30:	48 89 f2             	mov    %rsi,%rdx

    __asm__ __volatile__(
    1a33:	31 ff                	xor    %edi,%edi
    1a35:	b9 01 01 00 c0       	mov    $0xc0000101,%ecx
static inline int wrmsr_safe(unsigned int msr, uint64_t val)
{
    int _rc;
    uint32_t lo, hi;
    lo = (uint32_t)val;
    hi = (uint32_t)(val >> 32);
    1a3a:	48 c1 ea 20          	shr    $0x20,%rdx

    __asm__ __volatile__(
    1a3e:	89 f0                	mov    %esi,%eax
    1a40:	0f 30                	wrmsr  
        else
            v->arch.pv_vcpu.gs_base_user = base;
        break;

    case SEGBASE_GS_KERNEL:
        if ( wrmsr_safe(MSR_GS_BASE, base) )
    1a42:	85 ff                	test   %edi,%edi
            ret = -EFAULT;
    1a44:	48 c7 c0 f2 ff ff ff 	mov    $0xfffffffffffffff2,%rax
        else
            v->arch.pv_vcpu.gs_base_user = base;
        break;

    case SEGBASE_GS_KERNEL:
        if ( wrmsr_safe(MSR_GS_BASE, base) )
    1a4b:	0f 85 6c ff ff ff    	jne    19bd <do_set_segment_base+0x2d>
            ret = -EFAULT;
        else
            v->arch.pv_vcpu.gs_base_kernel = base;
    1a51:	49 89 b0 e0 04 00 00 	mov    %rsi,0x4e0(%r8)
}

long do_set_segment_base(unsigned int which, unsigned long base)
{
    struct vcpu *v = current;
    long ret = 0;
    1a58:	31 c0                	xor    %eax,%eax
    1a5a:	c3                   	retq   
    1a5b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001a60 <check_descriptor>:


/* Returns TRUE if given descriptor is valid for GDT or LDT. */
int check_descriptor(const struct domain *dom, struct desc_struct *d)
{
    u32 a = d->a, b = d->b;
    1a60:	8b 56 04             	mov    0x4(%rsi),%edx
    1a63:	44 8b 06             	mov    (%rsi),%r8d
    u16 cs;
    unsigned int dpl;

    /* A not-present descriptor will always fault, so is safe. */
    if ( !(b & _SEGMENT_P) ) 
    1a66:	f6 c6 80             	test   $0x80,%dh
    1a69:	0f 84 a1 00 00 00    	je     1b10 <check_descriptor+0xb0>
        goto good;

    /* Check and fix up the DPL. */
    dpl = (b >> 13) & 3;
    __fixup_guest_selector(dom, dpl);
    1a6f:	44 0f b6 8f 3c 0c 00 	movzbl 0xc3c(%rdi),%r9d
    1a76:	00 
    /* A not-present descriptor will always fault, so is safe. */
    if ( !(b & _SEGMENT_P) ) 
        goto good;

    /* Check and fix up the DPL. */
    dpl = (b >> 13) & 3;
    1a77:	89 d1                	mov    %edx,%ecx
    1a79:	c1 e9 0d             	shr    $0xd,%ecx
    1a7c:	83 e1 03             	and    $0x3,%ecx
    __fixup_guest_selector(dom, dpl);
    1a7f:	41 80 f9 01          	cmp    $0x1,%r9b
    1a83:	19 c0                	sbb    %eax,%eax
    1a85:	83 e0 02             	and    $0x2,%eax
    1a88:	83 c0 01             	add    $0x1,%eax
    1a8b:	39 c8                	cmp    %ecx,%eax
    1a8d:	0f 43 c8             	cmovae %eax,%ecx
    b = (b & ~_SEGMENT_DPL) | (dpl << 13);
    1a90:	89 d0                	mov    %edx,%eax
    1a92:	89 ca                	mov    %ecx,%edx
    1a94:	80 e4 9f             	and    $0x9f,%ah
    1a97:	c1 e2 0d             	shl    $0xd,%edx
    1a9a:	09 c2                	or     %eax,%edx

    /* All code and data segments are okay. No base/limit checking. */
    if ( (b & _SEGMENT_S) )
    1a9c:	f6 c6 10             	test   $0x10,%dh
    1a9f:	74 7f                	je     1b20 <check_descriptor+0xc0>
    {
        if ( is_pv_32bit_domain(dom) )
    1aa1:	45 84 c9             	test   %r9b,%r9b
    1aa4:	74 6a                	je     1b10 <check_descriptor+0xb0>
 good:
    d->a = a;
    d->b = b;
    return 1;
 bad:
    return 0;
    1aa6:	31 c0                	xor    %eax,%eax
    {
        if ( is_pv_32bit_domain(dom) )
        {
            unsigned long base, limit;

            if ( b & _SEGMENT_L )
    1aa8:	f7 c2 00 00 20 00    	test   $0x200000,%edx
    1aae:	75 6b                	jne    1b1b <check_descriptor+0xbb>
            /*
             * Older PAE Linux guests use segments which are limited to
             * 0xf6800000. Extend these to allow access to the larger read-only
             * M2P table available in 32on64 mode.
             */
            base = (b & (0xff << 24)) | ((b & 0xff) << 16) | (a >> 16);
    1ab0:	41 89 d1             	mov    %edx,%r9d
    1ab3:	44 89 c0             	mov    %r8d,%eax

            limit = (b & 0xf0000) | (a & 0xffff);
    1ab6:	45 0f b7 d0          	movzwl %r8w,%r10d
            /*
             * Older PAE Linux guests use segments which are limited to
             * 0xf6800000. Extend these to allow access to the larger read-only
             * M2P table available in 32on64 mode.
             */
            base = (b & (0xff << 24)) | ((b & 0xff) << 16) | (a >> 16);
    1aba:	c1 e8 10             	shr    $0x10,%eax
    1abd:	41 81 e1 00 00 00 ff 	and    $0xff000000,%r9d
    1ac4:	0f b6 ca             	movzbl %dl,%ecx
    1ac7:	41 09 c1             	or     %eax,%r9d

            limit = (b & 0xf0000) | (a & 0xffff);
    1aca:	89 d0                	mov    %edx,%eax
            /*
             * Older PAE Linux guests use segments which are limited to
             * 0xf6800000. Extend these to allow access to the larger read-only
             * M2P table available in 32on64 mode.
             */
            base = (b & (0xff << 24)) | ((b & 0xff) << 16) | (a >> 16);
    1acc:	c1 e1 10             	shl    $0x10,%ecx

            limit = (b & 0xf0000) | (a & 0xffff);
    1acf:	25 00 00 0f 00       	and    $0xf0000,%eax
    1ad4:	44 09 d0             	or     %r10d,%eax
            limit++; /* We add one because limit is inclusive. */
    1ad7:	48 83 c0 01          	add    $0x1,%rax

            if ( (b & _SEGMENT_G) )
                limit <<= 12;
    1adb:	49 89 c2             	mov    %rax,%r10
    1ade:	49 c1 e2 0c          	shl    $0xc,%r10
    1ae2:	f7 c2 00 00 80 00    	test   $0x800000,%edx
    1ae8:	49 0f 45 c2          	cmovne %r10,%rax

            if ( (base == 0) && (limit > HYPERVISOR_COMPAT_VIRT_START(dom)) )
    1aec:	41 09 c9             	or     %ecx,%r9d
    1aef:	75 1f                	jne    1b10 <check_descriptor+0xb0>
    1af1:	8b 8f 88 02 00 00    	mov    0x288(%rdi),%ecx
    1af7:	48 39 c8             	cmp    %rcx,%rax
    1afa:	76 14                	jbe    1b10 <check_descriptor+0xb0>
            {
                a |= 0x0000ffff;
    1afc:	41 81 c8 ff ff 00 00 	or     $0xffff,%r8d
                b |= 0x000f0000;
    1b03:	81 ca 00 00 0f 00    	or     $0xf0000,%edx
    1b09:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    /* Reserved bits must be zero. */
    if ( b & (is_pv_32bit_domain(dom) ? 0xe0 : 0xff) )
        goto bad;
        
 good:
    d->a = a;
    1b10:	44 89 06             	mov    %r8d,(%rsi)
    d->b = b;
    1b13:	89 56 04             	mov    %edx,0x4(%rsi)
    return 1;
    1b16:	b8 01 00 00 00       	mov    $0x1,%eax
 bad:
    return 0;
}
    1b1b:	f3 c3                	repz retq 
    1b1d:	0f 1f 00             	nopl   (%rax)

        goto good;
    }

    /* Invalid type 0 is harmless. It is used for 2nd half of a call gate. */
    if ( (b & _SEGMENT_TYPE) == 0x000 )
    1b20:	89 d7                	mov    %edx,%edi
    1b22:	81 e7 00 0f 00 00    	and    $0xf00,%edi
    1b28:	74 e6                	je     1b10 <check_descriptor+0xb0>
 good:
    d->a = a;
    d->b = b;
    return 1;
 bad:
    return 0;
    1b2a:	31 c0                	xor    %eax,%eax
    /* Invalid type 0 is harmless. It is used for 2nd half of a call gate. */
    if ( (b & _SEGMENT_TYPE) == 0x000 )
        goto good;

    /* Everything but a call gate is discarded here. */
    if ( (b & _SEGMENT_TYPE) != 0xc00 )
    1b2c:	81 ff 00 0c 00 00    	cmp    $0xc00,%edi
    1b32:	75 e7                	jne    1b1b <check_descriptor+0xbb>
        goto bad;

    /* Validate the target code selector. */
    cs = a >> 16;
    1b34:	45 89 c2             	mov    %r8d,%r10d
    1b37:	41 c1 ea 10          	shr    $0x10,%r10d
    if ( !guest_gate_selector_okay(dom, cs) )
    1b3b:	66 41 81 fa ff df    	cmp    $0xdfff,%r10w
    1b41:	76 1e                	jbe    1b61 <check_descriptor+0x101>
    1b43:	41 80 f9 01          	cmp    $0x1,%r9b
    1b47:	45 0f b7 da          	movzwl %r10w,%r11d
    1b4b:	19 ff                	sbb    %edi,%edi
    1b4d:	83 e7 1a             	and    $0x1a,%edi
    1b50:	81 c7 19 e0 00 00    	add    $0xe019,%edi
    1b56:	41 39 fb             	cmp    %edi,%r11d
    1b59:	74 06                	je     1b61 <check_descriptor+0x101>
    1b5b:	41 83 e3 04          	and    $0x4,%r11d
    1b5f:	74 ba                	je     1b1b <check_descriptor+0xbb>
     * to enter the kernel can only be determined when the gate is being
     * used), and with compat guests call gates cannot be used at all as
     * there are only 64-bit ones.
     * Store the original DPL in the selector's RPL field.
     */
    b &= ~_SEGMENT_DPL;
    1b61:	80 e6 9f             	and    $0x9f,%dh
    cs = (cs & ~3) | dpl;
    a = (a & 0xffffU) | (cs << 16);

    /* Reserved bits must be zero. */
    if ( b & (is_pv_32bit_domain(dom) ? 0xe0 : 0xff) )
    1b64:	41 80 f9 01          	cmp    $0x1,%r9b
    1b68:	19 ff                	sbb    %edi,%edi
 good:
    d->a = a;
    d->b = b;
    return 1;
 bad:
    return 0;
    1b6a:	31 c0                	xor    %eax,%eax
    b &= ~_SEGMENT_DPL;
    cs = (cs & ~3) | dpl;
    a = (a & 0xffffU) | (cs << 16);

    /* Reserved bits must be zero. */
    if ( b & (is_pv_32bit_domain(dom) ? 0xe0 : 0xff) )
    1b6c:	83 e7 1f             	and    $0x1f,%edi
    1b6f:	81 c7 e0 00 00 00    	add    $0xe0,%edi
    1b75:	85 d7                	test   %edx,%edi
    1b77:	75 a2                	jne    1b1b <check_descriptor+0xbb>
     * used), and with compat guests call gates cannot be used at all as
     * there are only 64-bit ones.
     * Store the original DPL in the selector's RPL field.
     */
    b &= ~_SEGMENT_DPL;
    cs = (cs & ~3) | dpl;
    1b79:	41 83 e2 fc          	and    $0xfffffffc,%r10d
    a = (a & 0xffffU) | (cs << 16);
    1b7d:	41 0f b7 c0          	movzwl %r8w,%eax
     * used), and with compat guests call gates cannot be used at all as
     * there are only 64-bit ones.
     * Store the original DPL in the selector's RPL field.
     */
    b &= ~_SEGMENT_DPL;
    cs = (cs & ~3) | dpl;
    1b81:	41 09 ca             	or     %ecx,%r10d
    a = (a & 0xffffU) | (cs << 16);
    1b84:	45 89 d0             	mov    %r10d,%r8d
    1b87:	41 c1 e0 10          	shl    $0x10,%r8d
    1b8b:	41 09 c0             	or     %eax,%r8d
    1b8e:	eb 80                	jmp    1b10 <check_descriptor+0xb0>

0000000000001b90 <pagefault_by_memadd>:
    1b90:	48 c7 c2 00 80 ff ff 	mov    $0xffffffffffff8000,%rdx
    1b97:	48 21 e2             	and    %rsp,%rdx
    return 0;
}

int pagefault_by_memadd(unsigned long addr, struct cpu_user_regs *regs)
{
    struct domain *d = current->domain;
    1b9a:	48 8b 82 e8 7f 00 00 	mov    0x7fe8(%rdx),%rax
    1ba1:	48 8b 48 10          	mov    0x10(%rax),%rcx

    return mem_hotplug && guest_mode(regs) && is_pv_32bit_domain(d) &&
    1ba5:	31 c0                	xor    %eax,%eax
    1ba7:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 1bae <pagefault_by_memadd+0x1e>
    1bae:	74 0c                	je     1bbc <pagefault_by_memadd+0x2c>
    return (struct cpu_info *)(tos + STACK_SIZE) - 1;
    1bb0:	48 81 c2 18 7f 00 00 	add    $0x7f18,%rdx
    1bb7:	48 39 d6             	cmp    %rdx,%rsi
    1bba:	74 04                	je     1bc0 <pagefault_by_memadd+0x30>
           (addr >= HYPERVISOR_COMPAT_VIRT_START(d)) &&
           (addr < MACH2PHYS_COMPAT_VIRT_END);
}
    1bbc:	f3 c3                	repz retq 
    1bbe:	66 90                	xchg   %ax,%ax

int pagefault_by_memadd(unsigned long addr, struct cpu_user_regs *regs)
{
    struct domain *d = current->domain;

    return mem_hotplug && guest_mode(regs) && is_pv_32bit_domain(d) &&
    1bc0:	80 b9 3c 0c 00 00 00 	cmpb   $0x0,0xc3c(%rcx)
    1bc7:	74 f3                	je     1bbc <pagefault_by_memadd+0x2c>
           (addr >= HYPERVISOR_COMPAT_VIRT_START(d)) &&
           (addr < MACH2PHYS_COMPAT_VIRT_END);
    1bc9:	b8 ff ff df ff       	mov    $0xffdfffff,%eax
    1bce:	48 39 c7             	cmp    %rax,%rdi
int pagefault_by_memadd(unsigned long addr, struct cpu_user_regs *regs)
{
    struct domain *d = current->domain;

    return mem_hotplug && guest_mode(regs) && is_pv_32bit_domain(d) &&
           (addr >= HYPERVISOR_COMPAT_VIRT_START(d)) &&
    1bd1:	8b 81 88 02 00 00    	mov    0x288(%rcx),%eax
           (addr < MACH2PHYS_COMPAT_VIRT_END);
    1bd7:	0f 96 c2             	setbe  %dl
int pagefault_by_memadd(unsigned long addr, struct cpu_user_regs *regs)
{
    struct domain *d = current->domain;

    return mem_hotplug && guest_mode(regs) && is_pv_32bit_domain(d) &&
           (addr >= HYPERVISOR_COMPAT_VIRT_START(d)) &&
    1bda:	48 39 f8             	cmp    %rdi,%rax
    1bdd:	0f 96 c0             	setbe  %al
    1be0:	0f b6 c0             	movzbl %al,%eax

int pagefault_by_memadd(unsigned long addr, struct cpu_user_regs *regs)
{
    struct domain *d = current->domain;

    return mem_hotplug && guest_mode(regs) && is_pv_32bit_domain(d) &&
    1be3:	21 d0                	and    %edx,%eax
           (addr >= HYPERVISOR_COMPAT_VIRT_START(d)) &&
           (addr < MACH2PHYS_COMPAT_VIRT_END);
}
    1be5:	c3                   	retq   
    1be6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    1bed:	00 00 00 

0000000000001bf0 <handle_memadd_fault>:

int handle_memadd_fault(unsigned long addr, struct cpu_user_regs *regs)
{
    1bf0:	48 83 ec 48          	sub    $0x48,%rsp
};

static inline struct cpu_info *get_cpu_info(void)
{
    unsigned long tos;
    __asm__ ( "and %%rsp,%0" : "=r" (tos) : "0" (~(STACK_SIZE-1)) );
    1bf4:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    1bfb:	48 89 5c 24 18       	mov    %rbx,0x18(%rsp)
    1c00:	4c 89 64 24 28       	mov    %r12,0x28(%rsp)
    l2_pgentry_t l2e, idle_l2e;
    unsigned long mfn, idle_index;
    int ret = 0;

    if (!is_pv_32on64_domain(d))
        return 0;
    1c05:	31 db                	xor    %ebx,%ebx
           (addr >= HYPERVISOR_COMPAT_VIRT_START(d)) &&
           (addr < MACH2PHYS_COMPAT_VIRT_END);
}

int handle_memadd_fault(unsigned long addr, struct cpu_user_regs *regs)
{
    1c07:	48 89 6c 24 20       	mov    %rbp,0x20(%rsp)
    1c0c:	4c 89 6c 24 30       	mov    %r13,0x30(%rsp)
    1c11:	49 89 fc             	mov    %rdi,%r12
    1c14:	4c 89 74 24 38       	mov    %r14,0x38(%rsp)
    1c19:	4c 89 7c 24 40       	mov    %r15,0x40(%rsp)
    1c1e:	48 21 e0             	and    %rsp,%rax
    struct domain *d = current->domain;
    1c21:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    1c28:	48 8b 68 10          	mov    0x10(%rax),%rbp
    l2_pgentry_t *pl2e = NULL;
    l2_pgentry_t l2e, idle_l2e;
    unsigned long mfn, idle_index;
    int ret = 0;

    if (!is_pv_32on64_domain(d))
    1c2c:	80 bd 3c 0c 00 00 00 	cmpb   $0x0,0xc3c(%rbp)
    1c33:	74 0c                	je     1c41 <handle_memadd_fault+0x51>
        return 0;

    if ( (addr < HYPERVISOR_COMPAT_VIRT_START(d)) ||
    1c35:	b8 ff ff df ff       	mov    $0xffdfffff,%eax
    1c3a:	48 39 c7             	cmp    %rax,%rdi
    1c3d:	76 31                	jbe    1c70 <handle_memadd_fault+0x80>
         (addr >= MACH2PHYS_COMPAT_VIRT_END) )
        return 0;
    1c3f:	31 db                	xor    %ebx,%ebx
        unmap_domain_page(pl3e);
    if ( pl2e )
        unmap_domain_page(pl2e);

    return ret;
}
    1c41:	89 d8                	mov    %ebx,%eax
    1c43:	48 8b 6c 24 20       	mov    0x20(%rsp),%rbp
    1c48:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
    1c4d:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
    1c52:	4c 8b 6c 24 30       	mov    0x30(%rsp),%r13
    1c57:	4c 8b 74 24 38       	mov    0x38(%rsp),%r14
    1c5c:	4c 8b 7c 24 40       	mov    0x40(%rsp),%r15
    1c61:	48 83 c4 48          	add    $0x48,%rsp
    1c65:	c3                   	retq   
    1c66:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    1c6d:	00 00 00 
    int ret = 0;

    if (!is_pv_32on64_domain(d))
        return 0;

    if ( (addr < HYPERVISOR_COMPAT_VIRT_START(d)) ||
    1c70:	8b 85 88 02 00 00    	mov    0x288(%rbp),%eax
    1c76:	48 39 f8             	cmp    %rdi,%rax
    1c79:	77 c4                	ja     1c3f <handle_memadd_fault+0x4f>

/* Read pagetable base. */
static inline unsigned long read_cr3(void)
{
    unsigned long cr3;
    __asm__ __volatile__ (
    1c7b:	0f 20 df             	mov    %cr3,%rdi
         (addr >= MACH2PHYS_COMPAT_VIRT_END) )
        return 0;

    mfn = (read_cr3()) >> PAGE_SHIFT;
    1c7e:	48 c1 ef 0c          	shr    $0xc,%rdi

    pl4e = map_domain_page(mfn);
    1c82:	e8 00 00 00 00       	callq  1c87 <handle_memadd_fault+0x97>

    l4e = pl4e[0];
    1c87:	48 8b 38             	mov    (%rax),%rdi
         (addr >= MACH2PHYS_COMPAT_VIRT_END) )
        return 0;

    mfn = (read_cr3()) >> PAGE_SHIFT;

    pl4e = map_domain_page(mfn);
    1c8a:	49 89 c5             	mov    %rax,%r13

    l4e = pl4e[0];

    if (!(l4e_get_flags(l4e) & _PAGE_PRESENT))
    1c8d:	40 f6 c7 01          	test   $0x1,%dil
    1c91:	75 0d                	jne    1ca0 <handle_memadd_fault+0xb0>

    ret = EXCRET_fault_fixed;

unmap:
    if ( pl4e )
        unmap_domain_page(pl4e);
    1c93:	48 89 c7             	mov    %rax,%rdi
    1c96:	e8 00 00 00 00       	callq  1c9b <handle_memadd_fault+0xab>
    1c9b:	eb a4                	jmp    1c41 <handle_memadd_fault+0x51>
    1c9d:	0f 1f 00             	nopl   (%rax)
    l4e = pl4e[0];

    if (!(l4e_get_flags(l4e) & _PAGE_PRESENT))
        goto unmap;

    mfn = l4e_get_pfn(l4e);
    1ca0:	49 bf 00 f0 ff ff ff 	movabs $0xffffffffff000,%r15
    1ca7:	ff 0f 00 
    1caa:	4c 21 ff             	and    %r15,%rdi
    1cad:	48 c1 ef 0c          	shr    $0xc,%rdi
    /* We don't need get page type here since it is current CR3 */
    pl3e = map_domain_page(mfn);
    1cb1:	e8 00 00 00 00       	callq  1cb6 <handle_memadd_fault+0xc6>

    l3e = pl3e[3];
    1cb6:	48 8b 50 18          	mov    0x18(%rax),%rdx
    if (!(l4e_get_flags(l4e) & _PAGE_PRESENT))
        goto unmap;

    mfn = l4e_get_pfn(l4e);
    /* We don't need get page type here since it is current CR3 */
    pl3e = map_domain_page(mfn);
    1cba:	49 89 c6             	mov    %rax,%r14
    struct domain *d = current->domain;
    l4_pgentry_t *pl4e = NULL;
    l4_pgentry_t l4e;
    l3_pgentry_t  *pl3e = NULL;
    l3_pgentry_t l3e;
    l2_pgentry_t *pl2e = NULL;
    1cbd:	31 c0                	xor    %eax,%eax
    /* We don't need get page type here since it is current CR3 */
    pl3e = map_domain_page(mfn);

    l3e = pl3e[3];

    if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
    1cbf:	f6 c2 01             	test   $0x1,%dl
    1cc2:	75 34                	jne    1cf8 <handle_memadd_fault+0x108>

    ret = EXCRET_fault_fixed;

unmap:
    if ( pl4e )
        unmap_domain_page(pl4e);
    1cc4:	4c 89 ef             	mov    %r13,%rdi
    1cc7:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
    1ccc:	e8 00 00 00 00       	callq  1cd1 <handle_memadd_fault+0xe1>
    if ( pl3e )
        unmap_domain_page(pl3e);
    1cd1:	4c 89 f7             	mov    %r14,%rdi
    1cd4:	e8 00 00 00 00       	callq  1cd9 <handle_memadd_fault+0xe9>
    if ( pl2e )
    1cd9:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    1cde:	48 85 c0             	test   %rax,%rax
    1ce1:	0f 84 5a ff ff ff    	je     1c41 <handle_memadd_fault+0x51>
        unmap_domain_page(pl2e);
    1ce7:	48 89 c7             	mov    %rax,%rdi
    1cea:	e8 00 00 00 00       	callq  1cef <handle_memadd_fault+0xff>
    1cef:	e9 4d ff ff ff       	jmpq   1c41 <handle_memadd_fault+0x51>
    1cf4:	0f 1f 40 00          	nopl   0x0(%rax)
    l3e = pl3e[3];

    if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
        goto unmap;

    mfn = l3e_get_pfn(l3e);
    1cf8:	48 89 d7             	mov    %rdx,%rdi
    pl2e = map_domain_page(mfn);

    l2e = pl2e[l2_table_offset(addr)];
    1cfb:	49 c1 ec 15          	shr    $0x15,%r12
    l3e = pl3e[3];

    if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
        goto unmap;

    mfn = l3e_get_pfn(l3e);
    1cff:	4c 21 ff             	and    %r15,%rdi
    pl2e = map_domain_page(mfn);

    l2e = pl2e[l2_table_offset(addr)];
    1d02:	41 81 e4 ff 01 00 00 	and    $0x1ff,%r12d
    l3e = pl3e[3];

    if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
        goto unmap;

    mfn = l3e_get_pfn(l3e);
    1d09:	48 c1 ef 0c          	shr    $0xc,%rdi
    pl2e = map_domain_page(mfn);
    1d0d:	e8 00 00 00 00       	callq  1d12 <handle_memadd_fault+0x122>

    l2e = pl2e[l2_table_offset(addr)];
    1d12:	4a 8d 14 e0          	lea    (%rax,%r12,8),%rdx

    if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT))
    1d16:	f6 02 01             	testb  $0x1,(%rdx)
    1d19:	74 a9                	je     1cc4 <handle_memadd_fault+0xd4>
        goto unmap;

    idle_index = (l2_table_offset(addr) -
                        COMPAT_L2_PAGETABLE_FIRST_XEN_SLOT(d))/
    1d1b:	8b 8d 88 02 00 00    	mov    0x288(%rbp),%ecx
    1d21:	c1 e9 15             	shr    $0x15,%ecx
    l2e = pl2e[l2_table_offset(addr)];

    if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT))
        goto unmap;

    idle_index = (l2_table_offset(addr) -
    1d24:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
    1d2a:	49 29 cc             	sub    %rcx,%r12
                        COMPAT_L2_PAGETABLE_FIRST_XEN_SLOT(d))/
                  sizeof(l2_pgentry_t);
    idle_l2e = compat_idle_pg_table_l2[idle_index];
    1d2d:	49 83 e4 f8          	and    $0xfffffffffffffff8,%r12
    1d31:	4c 03 25 00 00 00 00 	add    0x0(%rip),%r12        # 1d38 <handle_memadd_fault+0x148>
    1d38:	49 8b 0c 24          	mov    (%r12),%rcx
    if (!(l2e_get_flags(idle_l2e) & _PAGE_PRESENT))
    1d3c:	f6 c1 01             	test   $0x1,%cl
    1d3f:	74 83                	je     1cc4 <handle_memadd_fault+0xd4>
        goto unmap;

    memcpy(&pl2e[l2_table_offset(addr)],
    1d41:	48 89 0a             	mov    %rcx,(%rdx)
            &compat_idle_pg_table_l2[idle_index],
            sizeof(l2_pgentry_t));

    ret = EXCRET_fault_fixed;
    1d44:	b3 01                	mov    $0x1,%bl
    1d46:	e9 79 ff ff ff       	jmpq   1cc4 <handle_memadd_fault+0xd4>
    1d4b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000001d50 <domain_set_alloc_bitsize>:
    return ret;
}

void domain_set_alloc_bitsize(struct domain *d)
{
    if ( !is_pv_32on64_domain(d) ||
    1d50:	80 bf 3c 0c 00 00 00 	cmpb   $0x0,0xc3c(%rdi)
    1d57:	74 37                	je     1d90 <domain_set_alloc_bitsize+0x40>
         (MACH2PHYS_COMPAT_NR_ENTRIES(d) >= max_page) ||
    1d59:	b8 00 00 e0 ff       	mov    $0xffe00000,%eax
    1d5e:	2b 87 88 02 00 00    	sub    0x288(%rdi),%eax
    1d64:	c1 e8 02             	shr    $0x2,%eax
    return ret;
}

void domain_set_alloc_bitsize(struct domain *d)
{
    if ( !is_pv_32on64_domain(d) ||
    1d67:	48 3b 05 00 00 00 00 	cmp    0x0(%rip),%rax        # 1d6e <domain_set_alloc_bitsize+0x1e>
    1d6e:	73 20                	jae    1d90 <domain_set_alloc_bitsize+0x40>
         (MACH2PHYS_COMPAT_NR_ENTRIES(d) >= max_page) ||
    1d70:	8b 97 38 0c 00 00    	mov    0xc38(%rdi),%edx
    1d76:	85 d2                	test   %edx,%edx
    1d78:	75 16                	jne    1d90 <domain_set_alloc_bitsize+0x40>
 */
static inline int fls(unsigned long x)
{
    long r;

    asm ( "bsr %1,%0\n\t"
    1d7a:	48 0f bd c0          	bsr    %rax,%rax
    1d7e:	75 07                	jne    1d87 <domain_set_alloc_bitsize+0x37>
    1d80:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
        return;
    d->arch.physaddr_bitsize =
        /* 2^n entries can be contained in guest's p2m mapping space */
        fls(MACH2PHYS_COMPAT_NR_ENTRIES(d)) - 1
        /* 2^n pages -> 2^(n+PAGE_SHIFT) bits */
        + PAGE_SHIFT;
    1d87:	83 c0 0c             	add    $0xc,%eax
    1d8a:	89 87 38 0c 00 00    	mov    %eax,0xc38(%rdi)
    1d90:	f3 c3                	repz retq 
    1d92:	66 66 66 66 66 2e 0f 	data32 data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)
    1d99:	1f 84 00 00 00 00 00 

0000000000001da0 <domain_clamp_alloc_bitsize>:
}

unsigned int domain_clamp_alloc_bitsize(struct domain *d, unsigned int bits)
{
    if ( (d == NULL) || (d->arch.physaddr_bitsize == 0) )
    1da0:	48 85 ff             	test   %rdi,%rdi
        /* 2^n pages -> 2^(n+PAGE_SHIFT) bits */
        + PAGE_SHIFT;
}

unsigned int domain_clamp_alloc_bitsize(struct domain *d, unsigned int bits)
{
    1da3:	89 f0                	mov    %esi,%eax
    if ( (d == NULL) || (d->arch.physaddr_bitsize == 0) )
    1da5:	74 0f                	je     1db6 <domain_clamp_alloc_bitsize+0x16>
    1da7:	8b 97 38 0c 00 00    	mov    0xc38(%rdi),%edx
    1dad:	85 d2                	test   %edx,%edx
    1daf:	74 05                	je     1db6 <domain_clamp_alloc_bitsize+0x16>
        return bits;
    return min(d->arch.physaddr_bitsize, bits);
    1db1:	39 d6                	cmp    %edx,%esi
    1db3:	0f 47 c2             	cmova  %edx,%eax
}
    1db6:	f3 c3                	repz retq 
    1db8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    1dbf:	00 

0000000000001dc0 <transfer_pages_to_heap>:

int transfer_pages_to_heap(struct mem_hotadd_info *info)
{
    1dc0:	48 83 ec 08          	sub    $0x8,%rsp

    /*
     * Mark the allocated page before put free pages to buddy allocator
     * to avoid merge in free_heap_pages
     */
    for (i = info->spfn; i < info->cur; i++)
    1dc4:	48 8b 17             	mov    (%rdi),%rdx
    1dc7:	48 8b 47 10          	mov    0x10(%rdi),%rax
    1dcb:	48 39 c2             	cmp    %rax,%rdx
    1dce:	73 4c                	jae    1e1c <transfer_pages_to_heap+0x5c>
    1dd0:	4c 8b 0d 00 00 00 00 	mov    0x0(%rip),%r9        # 1dd7 <transfer_pages_to_heap+0x17>
    1dd7:	4c 8b 05 00 00 00 00 	mov    0x0(%rip),%r8        # 1dde <transfer_pages_to_heap+0x1e>
    {
        pg = mfn_to_page(i);
        pg->count_info = PGC_state_inuse;
    1dde:	48 be 00 00 00 00 e0 	movabs $0xffff82e000000000,%rsi
    1de5:	82 ff ff 

    /*
     * Mark the allocated page before put free pages to buddy allocator
     * to avoid merge in free_heap_pages
     */
    for (i = info->spfn; i < info->cur; i++)
    1de8:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 1dee <transfer_pages_to_heap+0x2e>
    1dee:	66 90                	xchg   %ax,%ax
extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1df0:	48 89 d0             	mov    %rdx,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1df3:	49 89 d2             	mov    %rdx,%r10
    1df6:	48 83 c2 01          	add    $0x1,%rdx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1dfa:	4c 21 c0             	and    %r8,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1dfd:	4d 21 ca             	and    %r9,%r10
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1e00:	48 d3 e8             	shr    %cl,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1e03:	4c 09 d0             	or     %r10,%rax
    {
        pg = mfn_to_page(i);
        pg->count_info = PGC_state_inuse;
    1e06:	48 c1 e0 05          	shl    $0x5,%rax
    1e0a:	48 c7 44 30 08 00 00 	movq   $0x0,0x8(%rax,%rsi,1)
    1e11:	00 00 

    /*
     * Mark the allocated page before put free pages to buddy allocator
     * to avoid merge in free_heap_pages
     */
    for (i = info->spfn; i < info->cur; i++)
    1e13:	48 8b 47 10          	mov    0x10(%rdi),%rax
    1e17:	48 39 d0             	cmp    %rdx,%rax
    1e1a:	77 d4                	ja     1df0 <transfer_pages_to_heap+0x30>
    {
        pg = mfn_to_page(i);
        pg->count_info = PGC_state_inuse;
    }

    init_domheap_pages(pfn_to_paddr(info->cur), pfn_to_paddr(info->epfn));
    1e1c:	48 8b 77 08          	mov    0x8(%rdi),%rsi
    1e20:	48 89 c7             	mov    %rax,%rdi
    1e23:	48 c1 e7 0c          	shl    $0xc,%rdi
    1e27:	48 c1 e6 0c          	shl    $0xc,%rsi
    1e2b:	e8 00 00 00 00       	callq  1e30 <transfer_pages_to_heap+0x70>

    return 0;
}
    1e30:	31 c0                	xor    %eax,%eax
    1e32:	48 83 c4 08          	add    $0x8,%rsp
    1e36:	c3                   	retq   
    1e37:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    1e3e:	00 00 

0000000000001e40 <mem_hotadd_check>:

int mem_hotadd_check(unsigned long spfn, unsigned long epfn)
{
    1e40:	48 83 ec 28          	sub    $0x28,%rsp
    1e44:	4c 89 64 24 18       	mov    %r12,0x18(%rsp)
    unsigned long s, e, length, sidx, eidx;

    if ( (spfn >= epfn) )
        return 0;
    1e49:	45 31 e4             	xor    %r12d,%r12d

int mem_hotadd_check(unsigned long spfn, unsigned long epfn)
{
    unsigned long s, e, length, sidx, eidx;

    if ( (spfn >= epfn) )
    1e4c:	48 39 f7             	cmp    %rsi,%rdi

    return 0;
}

int mem_hotadd_check(unsigned long spfn, unsigned long epfn)
{
    1e4f:	48 89 5c 24 08       	mov    %rbx,0x8(%rsp)
    1e54:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
    1e59:	48 89 f3             	mov    %rsi,%rbx
    1e5c:	4c 89 6c 24 20       	mov    %r13,0x20(%rsp)
    1e61:	48 89 fd             	mov    %rdi,%rbp
    unsigned long s, e, length, sidx, eidx;

    if ( (spfn >= epfn) )
    1e64:	0f 83 76 01 00 00    	jae    1fe0 <mem_hotadd_check+0x1a0>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1e6a:	4c 8b 2d 00 00 00 00 	mov    0x0(%rip),%r13        # 1e71 <mem_hotadd_check+0x31>

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1e71:	48 8b 35 00 00 00 00 	mov    0x0(%rip),%rsi        # 1e78 <mem_hotadd_check+0x38>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1e78:	48 89 d8             	mov    %rbx,%rax
    1e7b:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 1e81 <mem_hotadd_check+0x41>

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1e81:	48 89 da             	mov    %rbx,%rdx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1e84:	4c 21 e8             	and    %r13,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1e87:	48 21 f2             	and    %rsi,%rdx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1e8a:	48 d3 e8             	shr    %cl,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1e8d:	48 09 d0             	or     %rdx,%rax
        return 0;

    if (pfn_to_pdx(epfn) > FRAMETABLE_NR)
    1e90:	48 ba 00 00 00 00 01 	movabs $0x100000000,%rdx
    1e97:	00 00 00 
    1e9a:	48 39 d0             	cmp    %rdx,%rax
    1e9d:	0f 87 3d 01 00 00    	ja     1fe0 <mem_hotadd_check+0x1a0>
        return 0;

    if ( (spfn | epfn) & ((1UL << PAGETABLE_ORDER) - 1) )
    1ea3:	48 89 d8             	mov    %rbx,%rax
    1ea6:	48 09 f8             	or     %rdi,%rax
    1ea9:	a9 ff 01 00 00       	test   $0x1ff,%eax
    1eae:	0f 85 2c 01 00 00    	jne    1fe0 <mem_hotadd_check+0x1a0>
        return 0;

    if ( (spfn | epfn) & pfn_hole_mask )
    1eb4:	48 85 05 00 00 00 00 	test   %rax,0x0(%rip)        # 1ebb <mem_hotadd_check+0x7b>
    1ebb:	0f 85 1f 01 00 00    	jne    1fe0 <mem_hotadd_check+0x1a0>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1ec1:	48 89 fa             	mov    %rdi,%rdx

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1ec4:	48 89 f8             	mov    %rdi,%rax
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1ec7:	4c 21 ea             	and    %r13,%rdx

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1eca:	48 21 f0             	and    %rsi,%rax
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1ecd:	48 d3 ea             	shr    %cl,%rdx

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1ed0:	48 09 c2             	or     %rax,%rdx
        return 0;

    /* Make sure the new range is not present now */
    sidx = ((pfn_to_pdx(spfn) + PDX_GROUP_COUNT - 1)  & ~(PDX_GROUP_COUNT - 1))
            / PDX_GROUP_COUNT;
    eidx = (pfn_to_pdx(epfn - 1) & ~(PDX_GROUP_COUNT - 1)) / PDX_GROUP_COUNT;
    1ed3:	48 8d 43 ff          	lea    -0x1(%rbx),%rax

    if ( (spfn | epfn) & pfn_hole_mask )
        return 0;

    /* Make sure the new range is not present now */
    sidx = ((pfn_to_pdx(spfn) + PDX_GROUP_COUNT - 1)  & ~(PDX_GROUP_COUNT - 1))
    1ed7:	48 81 c2 ff ff 00 00 	add    $0xffff,%rdx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1ede:	49 21 c5             	and    %rax,%r13

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1ee1:	48 21 c6             	and    %rax,%rsi
    1ee4:	48 c1 ea 10          	shr    $0x10,%rdx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1ee8:	49 d3 ed             	shr    %cl,%r13

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1eeb:	49 09 f5             	or     %rsi,%r13
            / PDX_GROUP_COUNT;
    eidx = (pfn_to_pdx(epfn - 1) & ~(PDX_GROUP_COUNT - 1)) / PDX_GROUP_COUNT;
    1eee:	49 c1 ed 10          	shr    $0x10,%r13
    if (sidx >= eidx)
    1ef2:	4c 39 ea             	cmp    %r13,%rdx
    1ef5:	0f 83 e5 00 00 00    	jae    1fe0 <mem_hotadd_check+0x1a0>
        return 0;

    s = find_next_zero_bit(pdx_group_valid, eidx, sidx);
    1efb:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 1f02 <mem_hotadd_check+0xc2>
    1f02:	44 89 ee             	mov    %r13d,%esi
    1f05:	e8 00 00 00 00       	callq  1f0a <mem_hotadd_check+0xca>
    1f0a:	89 c2                	mov    %eax,%edx
    if ( s > eidx )
    1f0c:	49 39 d5             	cmp    %rdx,%r13
    1f0f:	0f 82 cb 00 00 00    	jb     1fe0 <mem_hotadd_check+0x1a0>
        return 0;
    e = find_next_bit(pdx_group_valid, eidx, s);
    1f15:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 1f1c <mem_hotadd_check+0xdc>
    1f1c:	89 c2                	mov    %eax,%edx
    1f1e:	44 89 ee             	mov    %r13d,%esi
    1f21:	e8 00 00 00 00       	callq  1f26 <mem_hotadd_check+0xe6>
    1f26:	89 c0                	mov    %eax,%eax
    if ( e < eidx )
    1f28:	49 39 c5             	cmp    %rax,%r13
    1f2b:	0f 87 af 00 00 00    	ja     1fe0 <mem_hotadd_check+0x1a0>
        return 0;

    /* Caculate at most required m2p/compat m2p/frametable pages */
    s = (spfn & ~((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1));
    e = (epfn + (1UL << (L2_PAGETABLE_SHIFT - 3)) - 1) &
    1f31:	48 8d bb ff ff 03 00 	lea    0x3ffff(%rbx),%rdi
    e = find_next_bit(pdx_group_valid, eidx, s);
    if ( e < eidx )
        return 0;

    /* Caculate at most required m2p/compat m2p/frametable pages */
    s = (spfn & ~((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1));
    1f38:	48 89 e8             	mov    %rbp,%rax
    e = (epfn + (1UL << (L2_PAGETABLE_SHIFT - 3)) - 1) &
            ~((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1);

    length = (e - s) * sizeof(unsigned long);

    s = (spfn & ~((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1));
    1f3b:	48 89 e9             	mov    %rbp,%rcx
    e = find_next_bit(pdx_group_valid, eidx, s);
    if ( e < eidx )
        return 0;

    /* Caculate at most required m2p/compat m2p/frametable pages */
    s = (spfn & ~((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1));
    1f3e:	48 25 00 00 fc ff    	and    $0xfffffffffffc0000,%rax
    e = (epfn + (1UL << (L2_PAGETABLE_SHIFT - 3)) - 1) &
            ~((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1);

    length = (e - s) * sizeof(unsigned long);

    s = (spfn & ~((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1));
    1f44:	48 81 e1 00 00 f8 ff 	and    $0xfffffffffff80000,%rcx
    e = (epfn + (1UL << (L2_PAGETABLE_SHIFT - 2)) - 1) &
            ~((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1);

    e = min_t(unsigned long, e,
    1f4b:	ba 00 00 00 10       	mov    $0x10000000,%edx
    if ( e < eidx )
        return 0;

    /* Caculate at most required m2p/compat m2p/frametable pages */
    s = (spfn & ~((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1));
    e = (epfn + (1UL << (L2_PAGETABLE_SHIFT - 3)) - 1) &
    1f50:	48 81 e7 00 00 fc ff 	and    $0xfffffffffffc0000,%rdi
            ~((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1);

    length = (e - s) * sizeof(unsigned long);
    1f57:	48 29 c7             	sub    %rax,%rdi

    s = (spfn & ~((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1));
    e = (epfn + (1UL << (L2_PAGETABLE_SHIFT - 2)) - 1) &
    1f5a:	48 8d 83 ff ff 07 00 	lea    0x7ffff(%rbx),%rax
    /* Caculate at most required m2p/compat m2p/frametable pages */
    s = (spfn & ~((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1));
    e = (epfn + (1UL << (L2_PAGETABLE_SHIFT - 3)) - 1) &
            ~((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1);

    length = (e - s) * sizeof(unsigned long);
    1f61:	48 c1 e7 03          	shl    $0x3,%rdi

    s = (spfn & ~((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1));
    e = (epfn + (1UL << (L2_PAGETABLE_SHIFT - 2)) - 1) &
    1f65:	48 25 00 00 f8 ff    	and    $0xfffffffffff80000,%rax
            ~((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1);

    e = min_t(unsigned long, e,
    1f6b:	48 3d 00 00 00 10    	cmp    $0x10000000,%rax
    1f71:	48 0f 46 d0          	cmovbe %rax,%rdx
            (RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START) >> 2);

    if ( e > s )
    1f75:	48 39 d1             	cmp    %rdx,%rcx
    1f78:	73 07                	jae    1f81 <mem_hotadd_check+0x141>
        length += (e -s) * sizeof(unsigned int);
    1f7a:	48 29 ca             	sub    %rcx,%rdx
    1f7d:	48 8d 3c 97          	lea    (%rdi,%rdx,4),%rdi
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1f81:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 1f88 <mem_hotadd_check+0x148>

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1f88:	48 8b 35 00 00 00 00 	mov    0x0(%rip),%rsi        # 1f8f <mem_hotadd_check+0x14f>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1f8f:	48 89 d8             	mov    %rbx,%rax
    1f92:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 1f98 <mem_hotadd_check+0x158>

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1f98:	49 89 d8             	mov    %rbx,%r8
    s = pfn_to_pdx(spfn) & ~(PDX_GROUP_COUNT - 1);
    e = ( pfn_to_pdx(epfn) + (PDX_GROUP_COUNT - 1) ) & ~(PDX_GROUP_COUNT - 1);

    length += (e - s) * sizeof(struct page_info);

    if ((length >> PAGE_SHIFT) > (epfn - spfn))
    1f9b:	48 29 eb             	sub    %rbp,%rbx
int mem_hotadd_check(unsigned long spfn, unsigned long epfn)
{
    unsigned long s, e, length, sidx, eidx;

    if ( (spfn >= epfn) )
        return 0;
    1f9e:	45 31 e4             	xor    %r12d,%r12d
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1fa1:	48 21 d0             	and    %rdx,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1fa4:	49 21 f0             	and    %rsi,%r8
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    1fa7:	48 21 ea             	and    %rbp,%rdx
    1faa:	48 d3 e8             	shr    %cl,%rax
    1fad:	48 d3 ea             	shr    %cl,%rdx

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    1fb0:	48 21 ee             	and    %rbp,%rsi
    1fb3:	4c 09 c0             	or     %r8,%rax
    1fb6:	48 09 f2             	or     %rsi,%rdx

    if ( e > s )
        length += (e -s) * sizeof(unsigned int);

    s = pfn_to_pdx(spfn) & ~(PDX_GROUP_COUNT - 1);
    e = ( pfn_to_pdx(epfn) + (PDX_GROUP_COUNT - 1) ) & ~(PDX_GROUP_COUNT - 1);
    1fb9:	48 05 ff ff 00 00    	add    $0xffff,%rax
            (RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START) >> 2);

    if ( e > s )
        length += (e -s) * sizeof(unsigned int);

    s = pfn_to_pdx(spfn) & ~(PDX_GROUP_COUNT - 1);
    1fbf:	66 31 d2             	xor    %dx,%dx
    e = ( pfn_to_pdx(epfn) + (PDX_GROUP_COUNT - 1) ) & ~(PDX_GROUP_COUNT - 1);
    1fc2:	66 31 c0             	xor    %ax,%ax

    length += (e - s) * sizeof(struct page_info);
    1fc5:	48 29 d0             	sub    %rdx,%rax
    1fc8:	48 c1 e0 05          	shl    $0x5,%rax
    1fcc:	48 01 f8             	add    %rdi,%rax

    if ((length >> PAGE_SHIFT) > (epfn - spfn))
    1fcf:	48 c1 e8 0c          	shr    $0xc,%rax
int mem_hotadd_check(unsigned long spfn, unsigned long epfn)
{
    unsigned long s, e, length, sidx, eidx;

    if ( (spfn >= epfn) )
        return 0;
    1fd3:	48 39 d8             	cmp    %rbx,%rax
    1fd6:	41 0f 96 c4          	setbe  %r12b
    1fda:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

    if ((length >> PAGE_SHIFT) > (epfn - spfn))
        return 0;

    return 1;
}
    1fe0:	44 89 e0             	mov    %r12d,%eax
    1fe3:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
    1fe8:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
    1fed:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
    1ff2:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
    1ff7:	48 83 c4 28          	add    $0x28,%rsp
    1ffb:	c3                   	retq   
    1ffc:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000002000 <memory_add>:
/*
 * A bit paranoid for memory allocation failure issue since
 * it may be reason for memory add
 */
int memory_add(unsigned long spfn, unsigned long epfn, unsigned int pxm)
{
    2000:	41 57                	push   %r15
    int ret, node;
    unsigned long old_max = max_page, old_total = total_pages;
    unsigned long old_node_start, old_node_span, orig_online;
    unsigned long i;

    dprintk(XENLOG_INFO, "memory_add %lx ~ %lx with pxm %x\n", spfn, epfn, pxm);
    2002:	49 89 f0             	mov    %rsi,%r8
    2005:	48 89 f9             	mov    %rdi,%rcx
/*
 * A bit paranoid for memory allocation failure issue since
 * it may be reason for memory add
 */
int memory_add(unsigned long spfn, unsigned long epfn, unsigned int pxm)
{
    2008:	41 56                	push   %r14
    200a:	41 55                	push   %r13
    200c:	41 54                	push   %r12
    200e:	55                   	push   %rbp
    200f:	89 d5                	mov    %edx,%ebp
    int ret, node;
    unsigned long old_max = max_page, old_total = total_pages;
    unsigned long old_node_start, old_node_span, orig_online;
    unsigned long i;

    dprintk(XENLOG_INFO, "memory_add %lx ~ %lx with pxm %x\n", spfn, epfn, pxm);
    2011:	41 89 e9             	mov    %ebp,%r9d
/*
 * A bit paranoid for memory allocation failure issue since
 * it may be reason for memory add
 */
int memory_add(unsigned long spfn, unsigned long epfn, unsigned int pxm)
{
    2014:	53                   	push   %rbx
    unsigned long i;

    dprintk(XENLOG_INFO, "memory_add %lx ~ %lx with pxm %x\n", spfn, epfn, pxm);

    if ( !mem_hotadd_check(spfn, epfn) )
        return -EINVAL;
    2015:	bb ea ff ff ff       	mov    $0xffffffea,%ebx
/*
 * A bit paranoid for memory allocation failure issue since
 * it may be reason for memory add
 */
int memory_add(unsigned long spfn, unsigned long epfn, unsigned int pxm)
{
    201a:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
    struct mem_hotadd_info info;
    int ret, node;
    unsigned long old_max = max_page, old_total = total_pages;
    2021:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 2028 <memory_add+0x28>
    2028:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 202f <memory_add+0x2f>
/*
 * A bit paranoid for memory allocation failure issue since
 * it may be reason for memory add
 */
int memory_add(unsigned long spfn, unsigned long epfn, unsigned int pxm)
{
    202f:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
    2034:	48 89 74 24 30       	mov    %rsi,0x30(%rsp)
    int ret, node;
    unsigned long old_max = max_page, old_total = total_pages;
    unsigned long old_node_start, old_node_span, orig_online;
    unsigned long i;

    dprintk(XENLOG_INFO, "memory_add %lx ~ %lx with pxm %x\n", spfn, epfn, pxm);
    2039:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 2040 <memory_add+0x40>
    2040:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 2047 <memory_add+0x47>
 */
int memory_add(unsigned long spfn, unsigned long epfn, unsigned int pxm)
{
    struct mem_hotadd_info info;
    int ret, node;
    unsigned long old_max = max_page, old_total = total_pages;
    2047:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
    204c:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
    unsigned long old_node_start, old_node_span, orig_online;
    unsigned long i;

    dprintk(XENLOG_INFO, "memory_add %lx ~ %lx with pxm %x\n", spfn, epfn, pxm);
    2051:	31 c0                	xor    %eax,%eax
    2053:	ba d5 06 00 00       	mov    $0x6d5,%edx
    2058:	e8 00 00 00 00       	callq  205d <memory_add+0x5d>

    if ( !mem_hotadd_check(spfn, epfn) )
    205d:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
    2062:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
    2067:	e8 00 00 00 00       	callq  206c <memory_add+0x6c>
    206c:	85 c0                	test   %eax,%eax
    206e:	0f 84 e1 02 00 00    	je     2355 <memory_add+0x355>
        return -EINVAL;

    if ( (node = setup_node(pxm)) == -1 )
    2074:	89 ef                	mov    %ebp,%edi
    2076:	e8 00 00 00 00       	callq  207b <memory_add+0x7b>
    207b:	83 f8 ff             	cmp    $0xffffffff,%eax
    207e:	89 44 24 44          	mov    %eax,0x44(%rsp)
    2082:	0f 84 cd 02 00 00    	je     2355 <memory_add+0x355>
        return -EINVAL;

    if ( !valid_numa_range(spfn << PAGE_SHIFT, epfn << PAGE_SHIFT, node) )
    2088:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
    208d:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
    2092:	89 c2                	mov    %eax,%edx
    2094:	48 c1 e1 0c          	shl    $0xc,%rcx
    2098:	49 c1 e0 0c          	shl    $0xc,%r8
    209c:	48 89 ce             	mov    %rcx,%rsi
    209f:	4c 89 c7             	mov    %r8,%rdi
    20a2:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
    20a7:	4c 89 44 24 48       	mov    %r8,0x48(%rsp)
    20ac:	e8 00 00 00 00       	callq  20b1 <memory_add+0xb1>
    20b1:	85 c0                	test   %eax,%eax
    20b3:	0f 84 9f 0a 00 00    	je     2b58 <memory_add+0xb58>
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
    20b9:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 20bf <memory_add+0xbf>
    20bf:	48 b8 ff ff ff ff ff 	movabs $0x4ffffffffff,%rax
    20c6:	04 00 00 
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
    20c9:	48 8b 35 00 00 00 00 	mov    0x0(%rip),%rsi        # 20d0 <memory_add+0xd0>
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
    20d0:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 20d7 <memory_add+0xd7>
    20d7:	49 89 c4             	mov    %rax,%r12
    20da:	49 d3 e4             	shl    %cl,%r12
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
    20dd:	48 21 f0             	and    %rsi,%rax
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
    20e0:	49 21 fc             	and    %rdi,%r12
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
    20e3:	49 09 c4             	or     %rax,%r12
        dprintk(XENLOG_WARNING, "spfn %lx ~ epfn %lx pxm %x node %x"
            "is not numa valid", spfn, epfn, pxm, node);
        return -EINVAL;
    }

    i = virt_to_mfn(HYPERVISOR_VIRT_END - 1) + 1;
    20e6:	49 c1 ec 0c          	shr    $0xc,%r12
    20ea:	49 83 c4 01          	add    $0x1,%r12
    if ( spfn < i )
    20ee:	4c 39 64 24 28       	cmp    %r12,0x28(%rsp)
    20f3:	0f 82 0d 05 00 00    	jb     2606 <memory_add+0x606>
        ret = map_pages_to_xen((unsigned long)mfn_to_virt(spfn), spfn,
                               min(epfn, i) - spfn, PAGE_HYPERVISOR);
        if ( ret )
            return ret;
    }
    if ( i < epfn )
    20f9:	4c 39 64 24 30       	cmp    %r12,0x30(%rsp)
    20fe:	0f 87 65 02 00 00    	ja     2369 <memory_add+0x369>
                               epfn - i, __PAGE_HYPERVISOR);
        if ( ret )
            return ret;
    }

    old_node_start = NODE_DATA(node)->node_start_pfn;
    2104:	48 63 44 24 44       	movslq 0x44(%rsp),%rax
    2109:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
    210d:	48 8d 05 00 00 00 00 	lea    0x0(%rip),%rax        # 2114 <memory_add+0x114>
    2114:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
    2118:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
    old_node_span = NODE_DATA(node)->node_spanned_pages;
    211d:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
                               epfn - i, __PAGE_HYPERVISOR);
        if ( ret )
            return ret;
    }

    old_node_start = NODE_DATA(node)->node_start_pfn;
    2122:	48 8b 00             	mov    (%rax),%rax
    old_node_span = NODE_DATA(node)->node_spanned_pages;
    2125:	48 8b 52 08          	mov    0x8(%rdx),%rdx
                               epfn - i, __PAGE_HYPERVISOR);
        if ( ret )
            return ret;
    }

    old_node_start = NODE_DATA(node)->node_start_pfn;
    2129:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
    old_node_span = NODE_DATA(node)->node_spanned_pages;
    212e:	48 89 94 24 80 00 00 	mov    %rdx,0x80(%rsp)
    2135:	00 

static inline int variable_test_bit(int nr, const volatile void *addr)
{
    int oldbit;

    asm volatile (
    2136:	44 8b 44 24 44       	mov    0x44(%rsp),%r8d
    213b:	44 0f a3 05 00 00 00 	bt     %r8d,0x0(%rip)        # 2143 <memory_add+0x143>
    2142:	00 
    2143:	19 c0                	sbb    %eax,%eax
    orig_online = node_online(node);
    2145:	48 98                	cltq   

    if ( !orig_online )
    2147:	48 85 c0             	test   %rax,%rax
            return ret;
    }

    old_node_start = NODE_DATA(node)->node_start_pfn;
    old_node_span = NODE_DATA(node)->node_spanned_pages;
    orig_online = node_online(node);
    214a:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
    2151:	00 

    if ( !orig_online )
    2152:	0f 84 7b 09 00 00    	je     2ad3 <memory_add+0xad3>
        NODE_DATA(node)->node_spanned_pages =
                epfn - node_start_pfn(node);
        node_set_online(node);
    }else
    {
        if (NODE_DATA(node)->node_start_pfn > spfn)
    2158:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
    215d:	48 8b 02             	mov    (%rdx),%rax
    2160:	48 39 44 24 28       	cmp    %rax,0x28(%rsp)
    2165:	73 0b                	jae    2172 <memory_add+0x172>
            NODE_DATA(node)->node_start_pfn = spfn;
    2167:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
    216c:	48 89 0a             	mov    %rcx,(%rdx)
    216f:	48 89 c8             	mov    %rcx,%rax
        if (node_end_pfn(node) < epfn)
    2172:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
    2177:	48 89 c2             	mov    %rax,%rdx
    217a:	49 03 50 08          	add    0x8(%r8),%rdx
    217e:	48 39 54 24 30       	cmp    %rdx,0x30(%rsp)
    2183:	76 0c                	jbe    2191 <memory_add+0x191>
            NODE_DATA(node)->node_spanned_pages = epfn - node_start_pfn(node);
    2185:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
    218a:	48 29 c2             	sub    %rax,%rdx
    218d:	49 89 50 08          	mov    %rdx,0x8(%r8)
    }

    ret = -EINVAL;
    info.spfn = spfn;
    info.epfn = epfn;
    2191:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
        if (node_end_pfn(node) < epfn)
            NODE_DATA(node)->node_spanned_pages = epfn - node_start_pfn(node);
    }

    ret = -EINVAL;
    info.spfn = spfn;
    2196:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    219b:	4c 8b 35 00 00 00 00 	mov    0x0(%rip),%r14        # 21a2 <memory_add+0x1a2>

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    21a2:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 21a9 <memory_add+0x1a9>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    21a9:	4d 89 c7             	mov    %r8,%r15
    21ac:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
    21b3:	00 
    info.epfn = epfn;
    info.cur = spfn;
    21b4:	48 89 8c 24 a8 00 00 	mov    %rcx,0xa8(%rsp)
    21bb:	00 
    21bc:	4d 21 f7             	and    %r14,%r15
    21bf:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 21c5 <memory_add+0x1c5>

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    21c5:	4c 89 c2             	mov    %r8,%rdx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    21c8:	4c 23 74 24 28       	and    0x28(%rsp),%r14

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    21cd:	48 21 c2             	and    %rax,%rdx
    21d0:	48 23 44 24 28       	and    0x28(%rsp),%rax
            NODE_DATA(node)->node_spanned_pages = epfn - node_start_pfn(node);
    }

    ret = -EINVAL;
    info.spfn = spfn;
    info.epfn = epfn;
    21d5:	4c 89 84 24 a0 00 00 	mov    %r8,0xa0(%rsp)
    21dc:	00 
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    21dd:	49 d3 ef             	shr    %cl,%r15

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    21e0:	49 09 d7             	or     %rdx,%r15
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    21e3:	49 d3 ee             	shr    %cl,%r14
    unsigned long cidx, nidx, eidx, spfn, epfn;

    spfn = info->spfn;
    epfn = info->epfn;

    eidx = (pfn_to_pdx(epfn) + PDX_GROUP_COUNT - 1) / PDX_GROUP_COUNT;
    21e6:	49 81 c7 ff ff 00 00 	add    $0xffff,%r15

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    21ed:	49 09 c6             	or     %rax,%r14
    21f0:	49 c1 ef 10          	shr    $0x10,%r15
    nidx = cidx = pfn_to_pdx(spfn)/PDX_GROUP_COUNT;
    21f4:	49 c1 ee 10          	shr    $0x10,%r14
    21f8:	44 0f a3 35 00 00 00 	bt     %r14d,0x0(%rip)        # 2200 <memory_add+0x200>
    21ff:	00 
    2200:	19 c0                	sbb    %eax,%eax

    ASSERT( pfn_to_pdx(epfn) <= (DIRECTMAP_SIZE >> PAGE_SHIFT) &&
            pfn_to_pdx(epfn) <= FRAMETABLE_NR );

    if ( test_bit(cidx, pdx_group_valid) )
    2202:	85 c0                	test   %eax,%eax
    2204:	74 15                	je     221b <memory_add+0x21b>
        cidx = find_next_zero_bit(pdx_group_valid, eidx, cidx);
    2206:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 220d <memory_add+0x20d>
    220d:	44 89 f2             	mov    %r14d,%edx
    2210:	44 89 fe             	mov    %r15d,%esi
    2213:	e8 00 00 00 00       	callq  2218 <memory_add+0x218>
    2218:	41 89 c6             	mov    %eax,%r14d

    if ( cidx >= eidx )
    221b:	4d 39 f7             	cmp    %r14,%r15
    221e:	4c 8d ac 24 98 00 00 	lea    0x98(%rsp),%r13
    2225:	00 
    2226:	0f 86 58 02 00 00    	jbe    2484 <memory_add+0x484>
    222c:	4c 8d ac 24 98 00 00 	lea    0x98(%rsp),%r13
    2233:	00 
    2234:	44 89 7c 24 20       	mov    %r15d,0x20(%rsp)
        int err;

        nidx = find_next_bit(pdx_group_valid, eidx, cidx);
        if ( nidx >= eidx )
            nidx = eidx;
        err = setup_frametable_chunk(pdx_to_page(cidx * PDX_GROUP_COUNT ),
    2239:	4c 89 fb             	mov    %r15,%rbx
    223c:	0f 1f 40 00          	nopl   0x0(%rax)

    while ( cidx < eidx )
    {
        int err;

        nidx = find_next_bit(pdx_group_valid, eidx, cidx);
    2240:	8b 74 24 20          	mov    0x20(%rsp),%esi
    2244:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 224b <memory_add+0x24b>
    224b:	44 89 f2             	mov    %r14d,%edx
    224e:	e8 00 00 00 00       	callq  2253 <memory_add+0x253>
    2253:	41 89 c7             	mov    %eax,%r15d
        if ( nidx >= eidx )
            nidx = eidx;
        err = setup_frametable_chunk(pdx_to_page(cidx * PDX_GROUP_COUNT ),
    2256:	48 b8 00 00 00 00 e0 	movabs $0xffff82e000000000,%rax
    225d:	82 ff ff 

    while ( cidx < eidx )
    {
        int err;

        nidx = find_next_bit(pdx_group_valid, eidx, cidx);
    2260:	49 39 df             	cmp    %rbx,%r15
    2263:	4c 0f 47 fb          	cmova  %rbx,%r15
        if ( nidx >= eidx )
            nidx = eidx;
        err = setup_frametable_chunk(pdx_to_page(cidx * PDX_GROUP_COUNT ),
    2267:	49 c1 e6 15          	shl    $0x15,%r14
                                     pdx_to_page(nidx * PDX_GROUP_COUNT),
    226b:	4d 89 fc             	mov    %r15,%r12
        int err;

        nidx = find_next_bit(pdx_group_valid, eidx, cidx);
        if ( nidx >= eidx )
            nidx = eidx;
        err = setup_frametable_chunk(pdx_to_page(cidx * PDX_GROUP_COUNT ),
    226e:	49 01 c6             	add    %rax,%r14
                                     pdx_to_page(nidx * PDX_GROUP_COUNT),
    2271:	49 c1 e4 15          	shl    $0x15,%r12
        int err;

        nidx = find_next_bit(pdx_group_valid, eidx, cidx);
        if ( nidx >= eidx )
            nidx = eidx;
        err = setup_frametable_chunk(pdx_to_page(cidx * PDX_GROUP_COUNT ),
    2275:	49 01 c4             	add    %rax,%r12
    int err;

    ASSERT(!(s & ((1 << L2_PAGETABLE_SHIFT) - 1)));
    ASSERT(!(e & ((1 << L2_PAGETABLE_SHIFT) - 1)));

    for ( ; s < e; s += (1UL << L2_PAGETABLE_SHIFT))
    2278:	4d 39 e6             	cmp    %r12,%r14
    227b:	0f 83 4b 08 00 00    	jae    2acc <memory_add+0xacc>
    2281:	4c 89 f5             	mov    %r14,%rbp
    2284:	eb 1a                	jmp    22a0 <memory_add+0x2a0>
    2286:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    228d:	00 00 00 
    2290:	48 81 c5 00 00 20 00 	add    $0x200000,%rbp
    2297:	49 39 ec             	cmp    %rbp,%r12
    229a:	0f 86 58 01 00 00    	jbe    23f8 <memory_add+0x3f8>
    unsigned mfn;

    ASSERT((info->cur + ( 1UL << PAGETABLE_ORDER) < info->epfn) &&
            info->cur >= info->spfn);

    mfn = info->cur;
    22a0:	49 8b 75 10          	mov    0x10(%r13),%rsi
    ASSERT(!(e & ((1 << L2_PAGETABLE_SHIFT) - 1)));

    for ( ; s < e; s += (1UL << L2_PAGETABLE_SHIFT))
    {
        mfn = alloc_hotadd_mfn(info);
        err = map_pages_to_xen(s, mfn, 1UL << PAGETABLE_ORDER,
    22a4:	b9 63 01 00 00       	mov    $0x163,%ecx
    22a9:	ba 00 02 00 00       	mov    $0x200,%edx
    22ae:	48 89 ef             	mov    %rbp,%rdi

    ASSERT((info->cur + ( 1UL << PAGETABLE_ORDER) < info->epfn) &&
            info->cur >= info->spfn);

    mfn = info->cur;
    info->cur += (1UL << PAGETABLE_ORDER);
    22b1:	48 8d 86 00 02 00 00 	lea    0x200(%rsi),%rax
    return mfn;
    22b8:	89 f6                	mov    %esi,%esi

    ASSERT((info->cur + ( 1UL << PAGETABLE_ORDER) < info->epfn) &&
            info->cur >= info->spfn);

    mfn = info->cur;
    info->cur += (1UL << PAGETABLE_ORDER);
    22ba:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
    22c1:	00 
    ASSERT(!(e & ((1 << L2_PAGETABLE_SHIFT) - 1)));

    for ( ; s < e; s += (1UL << L2_PAGETABLE_SHIFT))
    {
        mfn = alloc_hotadd_mfn(info);
        err = map_pages_to_xen(s, mfn, 1UL << PAGETABLE_ORDER,
    22c2:	e8 00 00 00 00       	callq  22c7 <memory_add+0x2c7>
                               PAGE_HYPERVISOR);
        if ( err )
    22c7:	85 c0                	test   %eax,%eax
    22c9:	74 c5                	je     2290 <memory_add+0x290>
    22cb:	89 c3                	mov    %eax,%ebx
    destroy_m2p_mapping(&info);
    max_page = old_max;
    total_pages = old_total;
    max_pdx = pfn_to_pdx(max_page - 1) + 1;
destroy_frametable:
    cleanup_frame_table(&info);
    22cd:	4c 89 ef             	mov    %r13,%rdi
    22d0:	e8 00 00 00 00       	callq  22d5 <memory_add+0x2d5>
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    22d5:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 22dc <memory_add+0x2dc>
    22dc:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
    22e1:	48 bf 00 00 00 00 00 	movabs $0xffff830000000000,%rdi
    22e8:	83 ff ff 
                    ((ma & ma_va_bottom_mask) |
    22eb:	4c 8b 05 00 00 00 00 	mov    0x0(%rip),%r8        # 22f2 <memory_add+0x2f2>
    22f2:	48 8b 74 24 50       	mov    0x50(%rsp),%rsi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    22f7:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 22fd <memory_add+0x2fd>
    22fd:	48 21 c2             	and    %rax,%rdx
    2300:	48 23 44 24 48       	and    0x48(%rsp),%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    2305:	4c 21 c6             	and    %r8,%rsi
    2308:	4c 23 44 24 48       	and    0x48(%rsp),%r8
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    230d:	48 d3 ea             	shr    %cl,%rdx

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    2310:	48 09 f2             	or     %rsi,%rdx
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    2313:	48 d3 e8             	shr    %cl,%rax
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
    2316:	48 8d 34 3a          	lea    (%rdx,%rdi,1),%rsi
                    ((ma & ma_va_bottom_mask) |
    231a:	4c 09 c0             	or     %r8,%rax
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
    231d:	48 01 c7             	add    %rax,%rdi
    destroy_xen_mappings((unsigned long)mfn_to_virt(spfn),
    2320:	e8 00 00 00 00       	callq  2325 <memory_add+0x325>
                         (unsigned long)mfn_to_virt(epfn));

    if ( !orig_online )
    2325:	48 83 bc 24 88 00 00 	cmpq   $0x0,0x88(%rsp)
    232c:	00 00 
    232e:	75 0c                	jne    233c <memory_add+0x33c>
 *
 * clear_bit() is atomic and may not be reordered.
 */
static inline void clear_bit(int nr, volatile void *addr)
{
    asm volatile (
    2330:	8b 44 24 44          	mov    0x44(%rsp),%eax
    2334:	f0 0f b3 05 00 00 00 	lock btr %eax,0x0(%rip)        # 233c <memory_add+0x33c>
    233b:	00 
        node_set_offline(node);
    NODE_DATA(node)->node_start_pfn = old_node_start;
    233c:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
    2341:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
    NODE_DATA(node)->node_spanned_pages = old_node_span;
    2346:	4c 8b 84 24 80 00 00 	mov    0x80(%rsp),%r8
    234d:	00 
    destroy_xen_mappings((unsigned long)mfn_to_virt(spfn),
                         (unsigned long)mfn_to_virt(epfn));

    if ( !orig_online )
        node_set_offline(node);
    NODE_DATA(node)->node_start_pfn = old_node_start;
    234e:	48 89 0a             	mov    %rcx,(%rdx)
    NODE_DATA(node)->node_spanned_pages = old_node_span;
    2351:	4c 89 42 08          	mov    %r8,0x8(%rdx)

    return ret;
}
    2355:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
    235c:	89 d8                	mov    %ebx,%eax
    235e:	5b                   	pop    %rbx
    235f:	5d                   	pop    %rbp
    2360:	41 5c                	pop    %r12
    2362:	41 5d                	pop    %r13
    2364:	41 5e                	pop    %r14
    2366:	41 5f                	pop    %r15
    2368:	c3                   	retq   
        ret = map_pages_to_xen((unsigned long)mfn_to_virt(spfn), spfn,
                               min(epfn, i) - spfn, PAGE_HYPERVISOR);
        if ( ret )
            return ret;
    }
    if ( i < epfn )
    2369:	4c 3b 64 24 28       	cmp    0x28(%rsp),%r12
    236e:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    2373:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 2379 <memory_add+0x379>
    {
        if ( i < spfn )
            i = spfn;
        ret = map_pages_to_xen((unsigned long)mfn_to_virt(i), i,
    2379:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
        ret = map_pages_to_xen((unsigned long)mfn_to_virt(spfn), spfn,
                               min(epfn, i) - spfn, PAGE_HYPERVISOR);
        if ( ret )
            return ret;
    }
    if ( i < epfn )
    237e:	49 0f 43 f4          	cmovae %r12,%rsi
    {
        if ( i < spfn )
            i = spfn;
        ret = map_pages_to_xen((unsigned long)mfn_to_virt(i), i,
    2382:	48 89 f7             	mov    %rsi,%rdi
    2385:	48 29 f2             	sub    %rsi,%rdx
    2388:	48 c1 e7 0c          	shl    $0xc,%rdi
    238c:	48 89 f8             	mov    %rdi,%rax
    238f:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 2396 <memory_add+0x396>

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    2396:	48 23 3d 00 00 00 00 	and    0x0(%rip),%rdi        # 239d <memory_add+0x39d>
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    239d:	48 d3 e8             	shr    %cl,%rax
    23a0:	b9 63 00 00 00       	mov    $0x63,%ecx

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    23a5:	48 09 f8             	or     %rdi,%rax
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
    23a8:	48 bf 00 00 00 00 00 	movabs $0xffff830000000000,%rdi
    23af:	83 ff ff 
    23b2:	48 01 c7             	add    %rax,%rdi
    23b5:	e8 00 00 00 00       	callq  23ba <memory_add+0x3ba>
                               epfn - i, __PAGE_HYPERVISOR);
        if ( ret )
    23ba:	85 c0                	test   %eax,%eax
    }
    if ( i < epfn )
    {
        if ( i < spfn )
            i = spfn;
        ret = map_pages_to_xen((unsigned long)mfn_to_virt(i), i,
    23bc:	89 c3                	mov    %eax,%ebx
                               epfn - i, __PAGE_HYPERVISOR);
        if ( ret )
    23be:	75 95                	jne    2355 <memory_add+0x355>
            return ret;
    }

    old_node_start = NODE_DATA(node)->node_start_pfn;
    23c0:	48 63 44 24 44       	movslq 0x44(%rsp),%rax
    23c5:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
    23c9:	48 8d 05 00 00 00 00 	lea    0x0(%rip),%rax        # 23d0 <memory_add+0x3d0>
    23d0:	48 8d 04 d0          	lea    (%rax,%rdx,8),%rax
    23d4:	48 8b 10             	mov    (%rax),%rdx
    old_node_span = NODE_DATA(node)->node_spanned_pages;
    23d7:	48 8b 48 08          	mov    0x8(%rax),%rcx
                               epfn - i, __PAGE_HYPERVISOR);
        if ( ret )
            return ret;
    }

    old_node_start = NODE_DATA(node)->node_start_pfn;
    23db:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
    23e0:	48 89 54 24 78       	mov    %rdx,0x78(%rsp)
    old_node_span = NODE_DATA(node)->node_spanned_pages;
    23e5:	48 89 8c 24 80 00 00 	mov    %rcx,0x80(%rsp)
    23ec:	00 
    23ed:	e9 44 fd ff ff       	jmpq   2136 <memory_add+0x136>
    23f2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    int err;

    ASSERT(!(s & ((1 << L2_PAGETABLE_SHIFT) - 1)));
    ASSERT(!(e & ((1 << L2_PAGETABLE_SHIFT) - 1)));

    for ( ; s < e; s += (1UL << L2_PAGETABLE_SHIFT))
    23f8:	48 89 ea             	mov    %rbp,%rdx
    23fb:	4c 29 f2             	sub    %r14,%rdx
        err = map_pages_to_xen(s, mfn, 1UL << PAGETABLE_ORDER,
                               PAGE_HYPERVISOR);
        if ( err )
            return err;
    }
    memset(start, -1, s - (unsigned long)start);
    23fe:	4c 89 f7             	mov    %r14,%rdi
    2401:	be ff ff ff ff       	mov    $0xffffffff,%esi
    2406:	e8 00 00 00 00       	callq  240b <memory_add+0x40b>
                                     pdx_to_page(nidx * PDX_GROUP_COUNT),
                                     info);
        if ( err )
            return err;

        cidx = find_next_zero_bit(pdx_group_valid, eidx, nidx);
    240b:	8b 74 24 20          	mov    0x20(%rsp),%esi
    240f:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 2416 <memory_add+0x416>
    2416:	44 89 fa             	mov    %r15d,%edx
    2419:	e8 00 00 00 00       	callq  241e <memory_add+0x41e>
    241e:	41 89 c6             	mov    %eax,%r14d
        cidx = find_next_zero_bit(pdx_group_valid, eidx, cidx);

    if ( cidx >= eidx )
        return 0;

    while ( cidx < eidx )
    2421:	4c 39 f3             	cmp    %r14,%rbx
    2424:	0f 87 16 fe ff ff    	ja     2240 <memory_add+0x240>
extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    242a:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 2431 <memory_add+0x431>
    2431:	48 8b 44 24 28       	mov    0x28(%rsp),%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    2436:	48 8b 35 00 00 00 00 	mov    0x0(%rip),%rsi        # 243d <memory_add+0x43d>
    243d:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    2442:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 2448 <memory_add+0x448>
    2448:	48 21 d0             	and    %rdx,%rax
    244b:	48 23 54 24 30       	and    0x30(%rsp),%rdx

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    2450:	48 21 f7             	and    %rsi,%rdi
    2453:	48 23 74 24 30       	and    0x30(%rsp),%rsi
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    2458:	48 d3 e8             	shr    %cl,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    245b:	48 09 f8             	or     %rdi,%rax
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    245e:	48 d3 ea             	shr    %cl,%rdx
            return err;

        cidx = find_next_zero_bit(pdx_group_valid, eidx, nidx);
    }

    memset(mfn_to_page(spfn), 0,
    2461:	48 b9 00 00 00 00 e0 	movabs $0xffff82e000000000,%rcx
    2468:	82 ff ff 

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    246b:	48 09 f2             	or     %rsi,%rdx
    246e:	31 f6                	xor    %esi,%esi
    2470:	48 29 c2             	sub    %rax,%rdx
    2473:	48 c1 e0 05          	shl    $0x5,%rax
    2477:	48 8d 3c 08          	lea    (%rax,%rcx,1),%rdi
    247b:	48 c1 e2 05          	shl    $0x5,%rdx
    247f:	e8 00 00 00 00       	callq  2484 <memory_add+0x484>
    ret = extend_frame_table(&info);
    if (ret)
        goto destroy_frametable;

    /* Set max_page as setup_m2p_table will use it*/
    if (max_page < epfn)
    2484:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
    2489:	48 3b 15 00 00 00 00 	cmp    0x0(%rip),%rdx        # 2490 <memory_add+0x490>
    2490:	0f 87 be 01 00 00    	ja     2654 <memory_add+0x654>
        max_page = epfn;
        max_pdx = pfn_to_pdx(max_page - 1) + 1;
    }
    total_pages += epfn - spfn;

    set_pdx_range(spfn, epfn);
    2496:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
    249b:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
    24a0:	49 bf 00 00 00 00 00 	movabs $0xffff830000000000,%r15
    24a7:	83 ff ff 
    if (max_page < epfn)
    {
        max_page = epfn;
        max_pdx = pfn_to_pdx(max_page - 1) + 1;
    }
    total_pages += epfn - spfn;
    24aa:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
    24af:	48 2b 44 24 28       	sub    0x28(%rsp),%rax
    24b4:	48 01 05 00 00 00 00 	add    %rax,0x0(%rip)        # 24bb <memory_add+0x4bb>

    set_pdx_range(spfn, epfn);
    24bb:	e8 00 00 00 00       	callq  24c0 <memory_add+0x4c0>
    l3_pgentry_t *l3_ro_mpt = NULL;
    int ret = 0;

    ASSERT(l4e_get_flags(idle_pg_table[l4_table_offset(RO_MPT_VIRT_START)])
            & _PAGE_PRESENT);
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(RO_MPT_VIRT_START)]);
    24c0:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
    24c7:	ff 0f 00 
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    24ca:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 24d1 <memory_add+0x4d1>

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    24d1:	48 8b 35 00 00 00 00 	mov    0x0(%rip),%rsi        # 24d8 <memory_add+0x4d8>
    24d8:	49 89 c0             	mov    %rax,%r8
    24db:	4c 23 05 00 00 00 00 	and    0x0(%rip),%r8        # 24e2 <memory_add+0x4e2>
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    24e2:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 24e8 <memory_add+0x4e8>
    24e8:	4c 89 c2             	mov    %r8,%rdx

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    24eb:	49 21 f0             	and    %rsi,%r8
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    24ee:	48 21 fa             	and    %rdi,%rdx
    24f1:	48 d3 ea             	shr    %cl,%rdx

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    24f4:	4c 09 c2             	or     %r8,%rdx

    smap = (info->spfn & (~((1UL << (L2_PAGETABLE_SHIFT - 3)) -1)));
    24f7:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
    24fe:	00 
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
    24ff:	4c 01 fa             	add    %r15,%rdx
    2502:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
    emap = ((info->epfn + ((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1 )) &
    2507:	48 8b 94 24 a0 00 00 	mov    0xa0(%rsp),%rdx
    250e:	00 

    ASSERT(l4e_get_flags(idle_pg_table[l4_table_offset(RO_MPT_VIRT_START)])
            & _PAGE_PRESENT);
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(RO_MPT_VIRT_START)]);

    smap = (info->spfn & (~((1UL << (L2_PAGETABLE_SHIFT - 3)) -1)));
    250f:	4c 89 c5             	mov    %r8,%rbp
    2512:	48 81 e5 00 00 fc ff 	and    $0xfffffffffffc0000,%rbp
    emap = ((info->epfn + ((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1 )) &
    2519:	4c 8d b2 ff ff 03 00 	lea    0x3ffff(%rdx),%r14
    2520:	49 81 e6 00 00 fc ff 	and    $0xfffffffffffc0000,%r14

    BUILD_BUG_ON((sizeof(*frame_table) & -sizeof(*frame_table)) % \
                 sizeof(*machine_to_phys_mapping));

    i = smap;
    while ( i < emap )
    2527:	4c 39 f5             	cmp    %r14,%rbp
    252a:	0f 83 8c 01 00 00    	jae    26bc <memory_add+0x6bc>
                break;
        if ( n < CNT )
        {
            unsigned long mfn = alloc_hotadd_mfn(info);

            ret = map_pages_to_xen(
    2530:	4c 89 6c 24 68       	mov    %r13,0x68(%rsp)
    2535:	0f 1f 00             	nopl   (%rax)
{
    unsigned long va;
    l3_pgentry_t *l3_ro_mpt;
    l2_pgentry_t *l2_ro_mpt;

    va = RO_MPT_VIRT_START + spfn * sizeof(*machine_to_phys_mapping);
    2538:	4c 8d 04 ed 00 00 00 	lea    0x0(,%rbp,8),%r8
    253f:	00 
    2540:	49 bd 00 00 00 00 00 	movabs $0xffff800000000000,%r13
    2547:	80 ff ff 
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(va)]);
    254a:	48 ba 00 f0 ff ff ff 	movabs $0xffffffffff000,%rdx
    2551:	ff 0f 00 
{
    unsigned long va;
    l3_pgentry_t *l3_ro_mpt;
    l2_pgentry_t *l2_ro_mpt;

    va = RO_MPT_VIRT_START + spfn * sizeof(*machine_to_phys_mapping);
    2554:	4d 01 c5             	add    %r8,%r13
    2557:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(va)]);
    255c:	4c 8d 05 00 00 00 00 	lea    0x0(%rip),%r8        # 2563 <memory_add+0x563>
    2563:	4c 89 e8             	mov    %r13,%rax

    switch ( l3e_get_flags(l3_ro_mpt[l3_table_offset(va)]) &
    2566:	4d 89 ec             	mov    %r13,%r12
    unsigned long va;
    l3_pgentry_t *l3_ro_mpt;
    l2_pgentry_t *l2_ro_mpt;

    va = RO_MPT_VIRT_START + spfn * sizeof(*machine_to_phys_mapping);
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(va)]);
    2569:	48 c1 e8 27          	shr    $0x27,%rax

    switch ( l3e_get_flags(l3_ro_mpt[l3_table_offset(va)]) &
    256d:	49 c1 ec 1b          	shr    $0x1b,%r12
    unsigned long va;
    l3_pgentry_t *l3_ro_mpt;
    l2_pgentry_t *l2_ro_mpt;

    va = RO_MPT_VIRT_START + spfn * sizeof(*machine_to_phys_mapping);
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(va)]);
    2571:	25 ff 01 00 00       	and    $0x1ff,%eax

    switch ( l3e_get_flags(l3_ro_mpt[l3_table_offset(va)]) &
    2576:	41 81 e4 f8 0f 00 00 	and    $0xff8,%r12d
    unsigned long va;
    l3_pgentry_t *l3_ro_mpt;
    l2_pgentry_t *l2_ro_mpt;

    va = RO_MPT_VIRT_START + spfn * sizeof(*machine_to_phys_mapping);
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(va)]);
    257d:	49 23 14 c0          	and    (%r8,%rax,8),%rdx
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    2581:	48 89 f8             	mov    %rdi,%rax
    2584:	48 21 d0             	and    %rdx,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    2587:	48 21 f2             	and    %rsi,%rdx
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    258a:	48 d3 e8             	shr    %cl,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    258d:	48 09 d0             	or     %rdx,%rax

    switch ( l3e_get_flags(l3_ro_mpt[l3_table_offset(va)]) &
    2590:	4c 01 e0             	add    %r12,%rax
    2593:	4a 8b 04 38          	mov    (%rax,%r15,1),%rax
    2597:	89 c2                	mov    %eax,%edx
    2599:	81 e2 81 00 00 00    	and    $0x81,%edx
    259f:	83 fa 01             	cmp    $0x1,%edx
    25a2:	0f 84 28 03 00 00    	je     28d0 <memory_add+0x8d0>
    25a8:	81 fa 81 00 00 00    	cmp    $0x81,%edx
    25ae:	0f 84 dc 00 00 00    	je     2690 <memory_add+0x690>
                 sizeof(*machine_to_phys_mapping));

    i = smap;
    while ( i < emap )
    {
        switch ( m2p_mapped(i) )
    25b4:	31 d2                	xor    %edx,%edx
    25b6:	4c 89 e3             	mov    %r12,%rbx
    25b9:	41 89 d4             	mov    %edx,%r12d
        }

        va = RO_MPT_VIRT_START + i * sizeof(*machine_to_phys_mapping);

        for ( n = 0; n < CNT; ++n)
            if ( mfn_valid(i + n * PDX_GROUP_COUNT) )
    25bc:	44 89 e7             	mov    %r12d,%edi
    25bf:	48 c1 e7 10          	shl    $0x10,%rdi
    25c3:	48 01 ef             	add    %rbp,%rdi
    25c6:	e8 00 00 00 00       	callq  25cb <memory_add+0x5cb>
    25cb:	85 c0                	test   %eax,%eax
    25cd:	0f 85 4d 03 00 00    	jne    2920 <memory_add+0x920>
            break;
        }

        va = RO_MPT_VIRT_START + i * sizeof(*machine_to_phys_mapping);

        for ( n = 0; n < CNT; ++n)
    25d3:	41 83 c4 01          	add    $0x1,%r12d
    25d7:	41 83 fc 04          	cmp    $0x4,%r12d
    25db:	75 df                	jne    25bc <memory_add+0x5bc>
            l2e_write(l2_ro_mpt, l2e_from_pfn(mfn,
                   /*_PAGE_GLOBAL|*/_PAGE_PSE|_PAGE_USER|_PAGE_PRESENT));
        }
        if ( !((unsigned long)l2_ro_mpt & ~PAGE_MASK) )
            l2_ro_mpt = NULL;
        i += ( 1UL << (L2_PAGETABLE_SHIFT - 3));
    25dd:	48 81 c5 00 00 04 00 	add    $0x40000,%rbp

    BUILD_BUG_ON((sizeof(*frame_table) & -sizeof(*frame_table)) % \
                 sizeof(*machine_to_phys_mapping));

    i = smap;
    while ( i < emap )
    25e4:	49 39 ee             	cmp    %rbp,%r14
    25e7:	0f 86 ba 00 00 00    	jbe    26a7 <memory_add+0x6a7>
    25ed:	48 8b 35 00 00 00 00 	mov    0x0(%rip),%rsi        # 25f4 <memory_add+0x5f4>
    25f4:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 25fb <memory_add+0x5fb>
    25fb:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 2601 <memory_add+0x601>
    2601:	e9 32 ff ff ff       	jmpq   2538 <memory_add+0x538>

    i = virt_to_mfn(HYPERVISOR_VIRT_END - 1) + 1;
    if ( spfn < i )
    {
        ret = map_pages_to_xen((unsigned long)mfn_to_virt(spfn), spfn,
                               min(epfn, i) - spfn, PAGE_HYPERVISOR);
    2606:	4c 3b 64 24 30       	cmp    0x30(%rsp),%r12
    260b:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
    2610:	48 b8 00 00 00 00 00 	movabs $0xffff830000000000,%rax
    2617:	83 ff ff 
    261a:	49 0f 46 d4          	cmovbe %r12,%rdx
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    261e:	48 23 7c 24 48       	and    0x48(%rsp),%rdi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    2623:	48 23 74 24 48       	and    0x48(%rsp),%rsi
    }

    i = virt_to_mfn(HYPERVISOR_VIRT_END - 1) + 1;
    if ( spfn < i )
    {
        ret = map_pages_to_xen((unsigned long)mfn_to_virt(spfn), spfn,
    2628:	48 2b 54 24 28       	sub    0x28(%rsp),%rdx
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    262d:	48 d3 ef             	shr    %cl,%rdi
    2630:	b9 63 01 00 00       	mov    $0x163,%ecx

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    2635:	48 09 f7             	or     %rsi,%rdi
    2638:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
    263d:	48 01 c7             	add    %rax,%rdi
    2640:	e8 00 00 00 00       	callq  2645 <memory_add+0x645>
                               min(epfn, i) - spfn, PAGE_HYPERVISOR);
        if ( ret )
    2645:	85 c0                	test   %eax,%eax
    }

    i = virt_to_mfn(HYPERVISOR_VIRT_END - 1) + 1;
    if ( spfn < i )
    {
        ret = map_pages_to_xen((unsigned long)mfn_to_virt(spfn), spfn,
    2647:	89 c3                	mov    %eax,%ebx
                               min(epfn, i) - spfn, PAGE_HYPERVISOR);
        if ( ret )
    2649:	0f 84 aa fa ff ff    	je     20f9 <memory_add+0xf9>
    264f:	e9 01 fd ff ff       	jmpq   2355 <memory_add+0x355>
        goto destroy_frametable;

    /* Set max_page as setup_m2p_table will use it*/
    if (max_page < epfn)
    {
        max_page = epfn;
    2654:	48 89 15 00 00 00 00 	mov    %rdx,0x0(%rip)        # 265b <memory_add+0x65b>
        max_pdx = pfn_to_pdx(max_page - 1) + 1;
    265b:	48 83 ea 01          	sub    $0x1,%rdx
extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    265f:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 2665 <memory_add+0x665>
    2665:	48 89 d0             	mov    %rdx,%rax
    2668:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 266f <memory_add+0x66f>

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    266f:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 2676 <memory_add+0x676>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    2676:	48 d3 e8             	shr    %cl,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    2679:	48 09 d0             	or     %rdx,%rax
    267c:	48 83 c0 01          	add    $0x1,%rax
    2680:	48 89 05 00 00 00 00 	mov    %rax,0x0(%rip)        # 2687 <memory_add+0x687>
    2687:	e9 0a fe ff ff       	jmpq   2496 <memory_add+0x496>
    268c:	0f 1f 40 00          	nopl   0x0(%rax)
    while ( i < emap )
    {
        switch ( m2p_mapped(i) )
        {
        case M2P_1G_MAPPED:
            i = ( i & ~((1UL << (L3_PAGETABLE_SHIFT - 3)) - 1)) +
    2690:	48 81 e5 00 00 00 f8 	and    $0xfffffffff8000000,%rbp
    2697:	48 81 c5 00 00 00 08 	add    $0x8000000,%rbp

    BUILD_BUG_ON((sizeof(*frame_table) & -sizeof(*frame_table)) % \
                 sizeof(*machine_to_phys_mapping));

    i = smap;
    while ( i < emap )
    269e:	49 39 ee             	cmp    %rbp,%r14
    26a1:	0f 87 46 ff ff ff    	ja     25ed <memory_add+0x5ed>
    26a7:	4c 8b 6c 24 68       	mov    0x68(%rsp),%r13
    26ac:	48 8b 94 24 a0 00 00 	mov    0xa0(%rsp),%rdx
    26b3:	00 
    26b4:	4c 8b 84 24 98 00 00 	mov    0x98(%rsp),%r8
    26bb:	00 
    unsigned int n;
    l3_pgentry_t *l3_ro_mpt = NULL;
    l2_pgentry_t *l2_ro_mpt = NULL;
    int err = 0;

    smap = info->spfn & (~((1UL << (L2_PAGETABLE_SHIFT - 2)) -1));
    26bc:	4c 89 c5             	mov    %r8,%rbp
    26bf:	48 81 e5 00 00 f8 ff 	and    $0xfffffffffff80000,%rbp

    /*
     * Notice: For hot-added memory, only range below m2p_compat_vstart
     * will be filled up (assuming memory is discontinous when booting).
     */
    if   ((smap > ((RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START) >> 2)) )
    26c6:	48 81 fd 00 00 00 10 	cmp    $0x10000000,%rbp
    26cd:	0f 87 51 04 00 00    	ja     2b24 <memory_add+0xb24>
        return 0;

    if ( epfn > ((RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START) >> 2) )
        epfn = (RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START) >> 2;

    emap = ( (epfn + ((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1 )) &
    26d3:	48 81 fa 00 00 00 10 	cmp    $0x10000000,%rdx
                ~((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1) );

    va = HIRO_COMPAT_MPT_VIRT_START +
         smap * sizeof(*compat_machine_to_phys_mapping);
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(va)]);
    26da:	48 bf 00 f0 ff ff ff 	movabs $0xffffffffff000,%rdi
    26e1:	ff 0f 00 
        return 0;

    if ( epfn > ((RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START) >> 2) )
        epfn = (RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START) >> 2;

    emap = ( (epfn + ((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1 )) &
    26e4:	41 bf 00 00 00 10    	mov    $0x10000000,%r15d
    26ea:	4c 0f 46 fa          	cmovbe %rdx,%r15
                ~((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1) );

    va = HIRO_COMPAT_MPT_VIRT_START +
         smap * sizeof(*compat_machine_to_phys_mapping);
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(va)]);
    26ee:	48 89 fe             	mov    %rdi,%rsi
    26f1:	48 23 35 00 00 00 00 	and    0x0(%rip),%rsi        # 26f8 <memory_add+0x6f8>
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    26f8:	4c 8b 05 00 00 00 00 	mov    0x0(%rip),%r8        # 26ff <memory_add+0x6ff>

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    26ff:	4c 8b 0d 00 00 00 00 	mov    0x0(%rip),%r9        # 2706 <memory_add+0x706>

    emap = ( (epfn + ((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1 )) &
                ~((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1) );

    va = HIRO_COMPAT_MPT_VIRT_START +
         smap * sizeof(*compat_machine_to_phys_mapping);
    2706:	48 8d 14 ad 00 00 00 	lea    0x0(,%rbp,4),%rdx
    270d:	00 
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    270e:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 2714 <memory_add+0x714>
        return 0;

    if ( epfn > ((RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START) >> 2) )
        epfn = (RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START) >> 2;

    emap = ( (epfn + ((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1 )) &
    2714:	49 81 c7 ff ff 07 00 	add    $0x7ffff,%r15
    271b:	49 81 e7 00 00 f8 ff 	and    $0xfffffffffff80000,%r15
    2722:	48 89 f0             	mov    %rsi,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    2725:	4c 21 ce             	and    %r9,%rsi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    2728:	4c 21 c0             	and    %r8,%rax
    272b:	48 d3 e8             	shr    %cl,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    272e:	48 09 f0             	or     %rsi,%rax
                ~((1UL << (L2_PAGETABLE_SHIFT - 2)) - 1) );

    va = HIRO_COMPAT_MPT_VIRT_START +
    2731:	48 be 00 00 00 80 c4 	movabs $0xffff82c480000000,%rsi
    2738:	82 ff ff 
    273b:	48 01 d6             	add    %rdx,%rsi
         smap * sizeof(*compat_machine_to_phys_mapping);
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(va)]);

    ASSERT(l3e_get_flags(l3_ro_mpt[l3_table_offset(va)]) & _PAGE_PRESENT);

    l2_ro_mpt = l3e_to_l2e(l3_ro_mpt[l3_table_offset(va)]);
    273e:	48 c1 ee 1b          	shr    $0x1b,%rsi
    2742:	81 e6 f8 0f 00 00    	and    $0xff8,%esi
    2748:	48 01 f0             	add    %rsi,%rax
    274b:	48 be 00 00 00 00 00 	movabs $0xffff830000000000,%rsi
    2752:	83 ff ff 
    2755:	48 23 3c 30          	and    (%rax,%rsi,1),%rdi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    2759:	48 89 f8             	mov    %rdi,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    275c:	4c 21 cf             	and    %r9,%rdi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    275f:	4c 21 c0             	and    %r8,%rax
    2762:	48 d3 e8             	shr    %cl,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    2765:	48 09 f8             	or     %rdi,%rax
#define CNT ((sizeof(*frame_table) & -sizeof(*frame_table)) / \
             sizeof(*compat_machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & -sizeof(*frame_table)) % \
                 sizeof(*compat_machine_to_phys_mapping));

    for ( i = smap; i < emap; i += (1UL << (L2_PAGETABLE_SHIFT - 2)) )
    2768:	4c 39 fd             	cmp    %r15,%rbp
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
    276b:	4c 8d 34 30          	lea    (%rax,%rsi,1),%r14
    276f:	0f 83 af 03 00 00    	jae    2b24 <memory_add+0xb24>
    2775:	49 bc 00 00 00 40 c4 	movabs $0xffff82c440000000,%r12
    277c:	82 ff ff 
    277f:	4c 89 6c 24 20       	mov    %r13,0x20(%rsp)
    2784:	49 01 d4             	add    %rdx,%r12
    2787:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    278e:	00 00 
              i * sizeof(*compat_machine_to_phys_mapping);

        rwva = RDWR_COMPAT_MPT_VIRT_START +
                i * sizeof(*compat_machine_to_phys_mapping);

        if (l2e_get_flags(l2_ro_mpt[l2_table_offset(va)]) & _PAGE_PRESENT)
    2790:	4d 89 e5             	mov    %r12,%r13
    2793:	49 c1 ed 12          	shr    $0x12,%r13
    2797:	41 81 e5 f8 0f 00 00 	and    $0xff8,%r13d
    279e:	4d 01 f5             	add    %r14,%r13
    27a1:	41 f6 45 00 01       	testb  $0x1,0x0(%r13)
    27a6:	75 29                	jne    27d1 <memory_add+0x7d1>
    27a8:	31 db                	xor    %ebx,%ebx
    27aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
            continue;

        for ( n = 0; n < CNT; ++n)
            if ( mfn_valid(i + n * PDX_GROUP_COUNT) )
    27b0:	48 8d 3c 2b          	lea    (%rbx,%rbp,1),%rdi
    27b4:	e8 00 00 00 00       	callq  27b9 <memory_add+0x7b9>
    27b9:	85 c0                	test   %eax,%eax
    27bb:	0f 85 27 02 00 00    	jne    29e8 <memory_add+0x9e8>
    27c1:	48 81 c3 00 00 01 00 	add    $0x10000,%rbx
                i * sizeof(*compat_machine_to_phys_mapping);

        if (l2e_get_flags(l2_ro_mpt[l2_table_offset(va)]) & _PAGE_PRESENT)
            continue;

        for ( n = 0; n < CNT; ++n)
    27c8:	48 81 fb 00 00 08 00 	cmp    $0x80000,%rbx
    27cf:	75 df                	jne    27b0 <memory_add+0x7b0>
#define CNT ((sizeof(*frame_table) & -sizeof(*frame_table)) / \
             sizeof(*compat_machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & -sizeof(*frame_table)) % \
                 sizeof(*compat_machine_to_phys_mapping));

    for ( i = smap; i < emap; i += (1UL << (L2_PAGETABLE_SHIFT - 2)) )
    27d1:	48 81 c5 00 00 08 00 	add    $0x80000,%rbp
    27d8:	49 81 c4 00 00 20 00 	add    $0x200000,%r12
    27df:	49 39 ef             	cmp    %rbp,%r15
    27e2:	77 ac                	ja     2790 <memory_add+0x790>
    27e4:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
    27e9:	31 db                	xor    %ebx,%ebx
    ret = setup_m2p_table(&info);

    if ( ret )
        goto destroy_m2p;

    if ( !need_iommu(dom0) )
    27eb:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 27f2 <memory_add+0x7f2>
    27f2:	80 bf e1 01 00 00 00 	cmpb   $0x0,0x1e1(%rdi)
    27f9:	0f 85 2c 03 00 00    	jne    2b2b <memory_add+0xb2b>
    {
        for ( i = spfn; i < epfn; i++ )
    27ff:	48 8b 6c 24 28       	mov    0x28(%rsp),%rbp
    2804:	48 3b 6c 24 30       	cmp    0x30(%rsp),%rbp
    2809:	73 31                	jae    283c <memory_add+0x83c>
    280b:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
    2810:	eb 16                	jmp    2828 <memory_add+0x828>
    2812:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    2818:	48 83 c5 01          	add    $0x1,%rbp
    281c:	49 39 ec             	cmp    %rbp,%r12
    281f:	76 1b                	jbe    283c <memory_add+0x83c>
    2821:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 2828 <memory_add+0x828>
            if ( iommu_map_page(dom0, i, i, IOMMUF_readable|IOMMUF_writable) )
    2828:	b9 03 00 00 00       	mov    $0x3,%ecx
    282d:	48 89 ea             	mov    %rbp,%rdx
    2830:	48 89 ee             	mov    %rbp,%rsi
    2833:	e8 00 00 00 00       	callq  2838 <memory_add+0x838>
    2838:	85 c0                	test   %eax,%eax
    283a:	74 dc                	je     2818 <memory_add+0x818>
                break;
        if ( i != epfn )
    283c:	48 3b 6c 24 30       	cmp    0x30(%rsp),%rbp
    2841:	0f 84 e4 02 00 00    	je     2b2b <memory_add+0xb2b>
        {
            while (i-- > old_max)
    2847:	48 39 6c 24 58       	cmp    %rbp,0x58(%rsp)
    284c:	73 2d                	jae    287b <memory_add+0x87b>
    284e:	48 83 ed 01          	sub    $0x1,%rbp
    2852:	4c 8b 64 24 58       	mov    0x58(%rsp),%r12
    2857:	eb 0a                	jmp    2863 <memory_add+0x863>
    2859:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    2860:	48 89 c5             	mov    %rax,%rbp
                iommu_unmap_page(dom0, i);
    2863:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 286a <memory_add+0x86a>
    286a:	48 89 ee             	mov    %rbp,%rsi
    286d:	e8 00 00 00 00       	callq  2872 <memory_add+0x872>
        for ( i = spfn; i < epfn; i++ )
            if ( iommu_map_page(dom0, i, i, IOMMUF_readable|IOMMUF_writable) )
                break;
        if ( i != epfn )
        {
            while (i-- > old_max)
    2872:	49 39 ec             	cmp    %rbp,%r12
    2875:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
    2879:	72 e5                	jb     2860 <memory_add+0x860>
    share_hotadd_m2p_table(&info);

    return 0;

destroy_m2p:
    destroy_m2p_mapping(&info);
    287b:	4c 89 ef             	mov    %r13,%rdi
    287e:	e8 00 00 00 00       	callq  2883 <memory_add+0x883>
    max_page = old_max;
    2883:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
    total_pages = old_total;
    2888:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx

    return 0;

destroy_m2p:
    destroy_m2p_mapping(&info);
    max_page = old_max;
    288d:	48 89 15 00 00 00 00 	mov    %rdx,0x0(%rip)        # 2894 <memory_add+0x894>
    total_pages = old_total;
    max_pdx = pfn_to_pdx(max_page - 1) + 1;
    2894:	48 83 ea 01          	sub    $0x1,%rdx
    return 0;

destroy_m2p:
    destroy_m2p_mapping(&info);
    max_page = old_max;
    total_pages = old_total;
    2898:	48 89 0d 00 00 00 00 	mov    %rcx,0x0(%rip)        # 289f <memory_add+0x89f>
extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    289f:	48 89 d0             	mov    %rdx,%rax
    28a2:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 28a9 <memory_add+0x8a9>
    28a9:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 28af <memory_add+0x8af>

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    28af:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 28b6 <memory_add+0x8b6>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
    28b6:	48 d3 e8             	shr    %cl,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
    28b9:	48 09 d0             	or     %rdx,%rax
    max_pdx = pfn_to_pdx(max_page - 1) + 1;
    28bc:	48 83 c0 01          	add    $0x1,%rax
    28c0:	48 89 05 00 00 00 00 	mov    %rax,0x0(%rip)        # 28c7 <memory_add+0x8c7>
    28c7:	e9 01 fa ff ff       	jmpq   22cd <memory_add+0x2cd>
    28cc:	0f 1f 40 00          	nopl   0x0(%rax)
            break;
        default:
            return M2P_NO_MAPPED;
            break;
    }
    l2_ro_mpt = l3e_to_l2e(l3_ro_mpt[l3_table_offset(va)]);
    28d0:	48 ba 00 f0 ff ff ff 	movabs $0xffffffffff000,%rdx
    28d7:	ff 0f 00 
    28da:	48 21 d0             	and    %rdx,%rax
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    28dd:	48 21 c7             	and    %rax,%rdi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    28e0:	48 21 c6             	and    %rax,%rsi

    if (l2e_get_flags(l2_ro_mpt[l2_table_offset(va)]) & _PAGE_PRESENT)
    28e3:	4c 89 e8             	mov    %r13,%rax
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    28e6:	48 d3 ef             	shr    %cl,%rdi
    28e9:	48 c1 e8 12          	shr    $0x12,%rax
    28ed:	25 f8 0f 00 00       	and    $0xff8,%eax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    28f2:	48 09 f7             	or     %rsi,%rdi
    28f5:	48 01 c7             	add    %rax,%rdi
    28f8:	4a 8b 04 3f          	mov    (%rdi,%r15,1),%rax
    28fc:	83 e0 01             	and    $0x1,%eax
                 sizeof(*machine_to_phys_mapping));

    i = smap;
    while ( i < emap )
    {
        switch ( m2p_mapped(i) )
    28ff:	83 f8 01             	cmp    $0x1,%eax
    2902:	0f 85 ac fc ff ff    	jne    25b4 <memory_add+0x5b4>
        case M2P_1G_MAPPED:
            i = ( i & ~((1UL << (L3_PAGETABLE_SHIFT - 3)) - 1)) +
                (1UL << (L3_PAGETABLE_SHIFT - 3));
            continue;
        case M2P_2M_MAPPED:
            i = (i & ~((1UL << (L2_PAGETABLE_SHIFT - 3)) - 1)) +
    2908:	48 81 e5 00 00 fc ff 	and    $0xfffffffffffc0000,%rbp
    290f:	48 81 c5 00 00 04 00 	add    $0x40000,%rbp
    2916:	e9 c9 fc ff ff       	jmpq   25e4 <memory_add+0x5e4>
    291b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    unsigned mfn;

    ASSERT((info->cur + ( 1UL << PAGETABLE_ORDER) < info->epfn) &&
            info->cur >= info->spfn);

    mfn = info->cur;
    2920:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
                break;
        if ( n < CNT )
        {
            unsigned long mfn = alloc_hotadd_mfn(info);

            ret = map_pages_to_xen(
    2925:	49 b8 00 00 00 00 80 	movabs $0xffff828000000000,%r8
    292c:	82 ff ff 
    292f:	4c 03 44 24 20       	add    0x20(%rsp),%r8
    2934:	49 89 dc             	mov    %rbx,%r12
    unsigned mfn;

    ASSERT((info->cur + ( 1UL << PAGETABLE_ORDER) < info->epfn) &&
            info->cur >= info->spfn);

    mfn = info->cur;
    2937:	48 8b 41 10          	mov    0x10(%rcx),%rax
                break;
        if ( n < CNT )
        {
            unsigned long mfn = alloc_hotadd_mfn(info);

            ret = map_pages_to_xen(
    293b:	b9 63 01 00 00       	mov    $0x163,%ecx
    2940:	4c 89 c7             	mov    %r8,%rdi
    2943:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)

    ASSERT((info->cur + ( 1UL << PAGETABLE_ORDER) < info->epfn) &&
            info->cur >= info->spfn);

    mfn = info->cur;
    info->cur += (1UL << PAGETABLE_ORDER);
    2948:	48 8d 90 00 02 00 00 	lea    0x200(%rax),%rdx
    return mfn;
    294f:	89 c3                	mov    %eax,%ebx
                break;
        if ( n < CNT )
        {
            unsigned long mfn = alloc_hotadd_mfn(info);

            ret = map_pages_to_xen(
    2951:	48 89 de             	mov    %rbx,%rsi

    ASSERT((info->cur + ( 1UL << PAGETABLE_ORDER) < info->epfn) &&
            info->cur >= info->spfn);

    mfn = info->cur;
    info->cur += (1UL << PAGETABLE_ORDER);
    2954:	48 89 94 24 a8 00 00 	mov    %rdx,0xa8(%rsp)
    295b:	00 
                break;
        if ( n < CNT )
        {
            unsigned long mfn = alloc_hotadd_mfn(info);

            ret = map_pages_to_xen(
    295c:	ba 00 02 00 00       	mov    $0x200,%edx
    2961:	e8 00 00 00 00       	callq  2966 <memory_add+0x966>
                        RDWR_MPT_VIRT_START + i * sizeof(unsigned long),
                        mfn, 1UL << PAGETABLE_ORDER,
                        PAGE_HYPERVISOR);
            if ( ret )
    2966:	85 c0                	test   %eax,%eax
    2968:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
    296d:	0f 85 d9 01 00 00    	jne    2b4c <memory_add+0xb4c>
                goto error;
            /* Fill with INVALID_M2P_ENTRY. */
            memset((void *)(RDWR_MPT_VIRT_START + i * sizeof(unsigned long)),
    2973:	ba 00 00 20 00       	mov    $0x200000,%edx
    2978:	be ff 00 00 00       	mov    $0xff,%esi
    297d:	4c 89 c7             	mov    %r8,%rdi
    2980:	e8 00 00 00 00       	callq  2985 <memory_add+0x985>
                   0xFF, 1UL << L2_PAGETABLE_SHIFT);

            ASSERT(!(l3e_get_flags(l3_ro_mpt[l3_table_offset(va)]) &
                  _PAGE_PSE));
            if ( l3e_get_flags(l3_ro_mpt[l3_table_offset(va)]) &
    2985:	4c 03 64 24 60       	add    0x60(%rsp),%r12
    298a:	49 8b 14 24          	mov    (%r12),%rdx
    298e:	f6 c2 01             	test   $0x1,%dl
    2991:	0f 84 aa 00 00 00    	je     2a41 <memory_add+0xa41>
              _PAGE_PRESENT )
                l2_ro_mpt = l3e_to_l2e(l3_ro_mpt[l3_table_offset(va)]) +
    2997:	49 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%r8
    299e:	ff 0f 00 
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    29a1:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 29a7 <memory_add+0x9a7>
                  l2_table_offset(va);
    29a7:	49 c1 ed 12          	shr    $0x12,%r13

            ASSERT(!(l3e_get_flags(l3_ro_mpt[l3_table_offset(va)]) &
                  _PAGE_PSE));
            if ( l3e_get_flags(l3_ro_mpt[l3_table_offset(va)]) &
              _PAGE_PRESENT )
                l2_ro_mpt = l3e_to_l2e(l3_ro_mpt[l3_table_offset(va)]) +
    29ab:	4c 21 c2             	and    %r8,%rdx
    29ae:	41 81 e5 f8 0f 00 00 	and    $0xff8,%r13d
    29b5:	48 89 d0             	mov    %rdx,%rax
    29b8:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 29bf <memory_add+0x9bf>

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    29bf:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 29c6 <memory_add+0x9c6>
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
    29c6:	48 d3 e8             	shr    %cl,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
    29c9:	48 09 d0             	or     %rdx,%rax
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
    29cc:	4c 01 f8             	add    %r15,%rax
    29cf:	4c 01 e8             	add    %r13,%rax
                                         __PAGE_HYPERVISOR | _PAGE_USER));
                l2_ro_mpt += l2_table_offset(va);
            }

            /* NB. Cannot be GLOBAL as shadow_mode_translate reuses this area. */
            l2e_write(l2_ro_mpt, l2e_from_pfn(mfn,
    29d2:	48 89 da             	mov    %rbx,%rdx
    29d5:	48 c1 e2 0c          	shl    $0xc,%rdx
    29d9:	80 ca 85             	or     $0x85,%dl
    29dc:	48 89 10             	mov    %rdx,(%rax)
    29df:	e9 f9 fb ff ff       	jmpq   25dd <memory_add+0x5dd>
    29e4:	0f 1f 40 00          	nopl   0x0(%rax)
    unsigned mfn;

    ASSERT((info->cur + ( 1UL << PAGETABLE_ORDER) < info->epfn) &&
            info->cur >= info->spfn);

    mfn = info->cur;
    29e8:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
                break;
        if ( n == CNT )
            continue;

        mfn = alloc_hotadd_mfn(info);
        err = map_pages_to_xen(rwva, mfn, 1UL << PAGETABLE_ORDER,
    29ed:	b9 63 01 00 00       	mov    $0x163,%ecx
    29f2:	ba 00 02 00 00       	mov    $0x200,%edx
    29f7:	4c 89 e7             	mov    %r12,%rdi
    unsigned mfn;

    ASSERT((info->cur + ( 1UL << PAGETABLE_ORDER) < info->epfn) &&
            info->cur >= info->spfn);

    mfn = info->cur;
    29fa:	48 8b 58 10          	mov    0x10(%rax),%rbx
    info->cur += (1UL << PAGETABLE_ORDER);
    29fe:	48 8d 83 00 02 00 00 	lea    0x200(%rbx),%rax
    return mfn;
    2a05:	89 db                	mov    %ebx,%ebx
                break;
        if ( n == CNT )
            continue;

        mfn = alloc_hotadd_mfn(info);
        err = map_pages_to_xen(rwva, mfn, 1UL << PAGETABLE_ORDER,
    2a07:	48 89 de             	mov    %rbx,%rsi

    ASSERT((info->cur + ( 1UL << PAGETABLE_ORDER) < info->epfn) &&
            info->cur >= info->spfn);

    mfn = info->cur;
    info->cur += (1UL << PAGETABLE_ORDER);
    2a0a:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
    2a11:	00 
                break;
        if ( n == CNT )
            continue;

        mfn = alloc_hotadd_mfn(info);
        err = map_pages_to_xen(rwva, mfn, 1UL << PAGETABLE_ORDER,
    2a12:	e8 00 00 00 00       	callq  2a17 <memory_add+0xa17>
                               PAGE_HYPERVISOR);
        if ( err )
    2a17:	85 c0                	test   %eax,%eax
    2a19:	0f 85 21 01 00 00    	jne    2b40 <memory_add+0xb40>
            break;
        /* Fill with INVALID_M2P_ENTRY. */
        memset((void *)rwva, 0xFF, 1UL << L2_PAGETABLE_SHIFT);
    2a1f:	ba 00 00 20 00       	mov    $0x200000,%edx
    2a24:	be ff 00 00 00       	mov    $0xff,%esi
    2a29:	4c 89 e7             	mov    %r12,%rdi
        /* NB. Cannot be GLOBAL as the ptes get copied into per-VM space. */
        l2e_write(&l2_ro_mpt[l2_table_offset(va)],
    2a2c:	48 c1 e3 0c          	shl    $0xc,%rbx
        err = map_pages_to_xen(rwva, mfn, 1UL << PAGETABLE_ORDER,
                               PAGE_HYPERVISOR);
        if ( err )
            break;
        /* Fill with INVALID_M2P_ENTRY. */
        memset((void *)rwva, 0xFF, 1UL << L2_PAGETABLE_SHIFT);
    2a30:	e8 00 00 00 00       	callq  2a35 <memory_add+0xa35>
        /* NB. Cannot be GLOBAL as the ptes get copied into per-VM space. */
        l2e_write(&l2_ro_mpt[l2_table_offset(va)],
    2a35:	80 cb 81             	or     $0x81,%bl
    2a38:	49 89 5d 00          	mov    %rbx,0x0(%r13)
    2a3c:	e9 90 fd ff ff       	jmpq   27d1 <memory_add+0x7d1>
              _PAGE_PRESENT )
                l2_ro_mpt = l3e_to_l2e(l3_ro_mpt[l3_table_offset(va)]) +
                  l2_table_offset(va);
            else
            {
                l2_ro_mpt = alloc_xen_pagetable();
    2a41:	e8 00 00 00 00       	callq  2a46 <memory_add+0xa46>
                if ( !l2_ro_mpt )
    2a46:	48 85 c0             	test   %rax,%rax
    2a49:	0f 84 3c 01 00 00    	je     2b8b <memory_add+0xb8b>
                {
                    ret = -ENOMEM;
                    goto error;
                }

                clear_page(l2_ro_mpt);
    2a4f:	48 89 c7             	mov    %rax,%rdi
    2a52:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
    2a57:	e8 00 00 00 00       	callq  2a5c <memory_add+0xa5c>

static inline unsigned long __virt_to_maddr(unsigned long va)
{
    ASSERT(va >= XEN_VIRT_START);
    ASSERT(va < DIRECTMAP_VIRT_END);
    if ( va >= DIRECTMAP_VIRT_START )
    2a5c:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    2a61:	48 ba ff ff ff ff ff 	movabs $0xffff82ffffffffff,%rdx
    2a68:	82 ff ff 
        va -= DIRECTMAP_VIRT_START;
    2a6b:	48 be 00 00 00 00 00 	movabs $0x7d0000000000,%rsi
    2a72:	7d 00 00 
    2a75:	48 01 c6             	add    %rax,%rsi

static inline unsigned long __virt_to_maddr(unsigned long va)
{
    ASSERT(va >= XEN_VIRT_START);
    ASSERT(va < DIRECTMAP_VIRT_END);
    if ( va >= DIRECTMAP_VIRT_START )
    2a78:	48 39 d0             	cmp    %rdx,%rax
    2a7b:	77 14                	ja     2a91 <memory_add+0xa91>
        va -= DIRECTMAP_VIRT_START;
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    2a7d:	48 be 00 00 00 40 3b 	movabs $0x7d3b40000000,%rsi
    2a84:	7d 00 00 
    2a87:	48 03 35 00 00 00 00 	add    0x0(%rip),%rsi        # 2a8e <memory_add+0xa8e>
    2a8e:	48 01 c6             	add    %rax,%rsi
    }
    return (va & ma_va_bottom_mask) |
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
    2a91:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 2a97 <memory_add+0xa97>
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
    2a97:	48 89 f2             	mov    %rsi,%rdx
    2a9a:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 2aa1 <memory_add+0xaa1>
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
    2aa1:	48 d3 e6             	shl    %cl,%rsi
    2aa4:	48 89 f1             	mov    %rsi,%rcx
    2aa7:	48 23 0d 00 00 00 00 	and    0x0(%rip),%rcx        # 2aae <memory_add+0xaae>
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
    2aae:	48 83 ca 67          	or     $0x67,%rdx
}
static inline l3_pgentry_t l3e_from_paddr(paddr_t pa, unsigned int flags)
{
    ASSERT((pa & ~(PADDR_MASK & PAGE_MASK)) == 0);
    return (l3_pgentry_t) { pa | put_pte_flags(flags) };
    2ab2:	48 09 ca             	or     %rcx,%rdx
    2ab5:	49 89 14 24          	mov    %rdx,(%r12)
                l3e_write(&l3_ro_mpt[l3_table_offset(va)],
                          l3e_from_paddr(__pa(l2_ro_mpt),
                                         __PAGE_HYPERVISOR | _PAGE_USER));
                l2_ro_mpt += l2_table_offset(va);
    2ab9:	49 c1 ed 12          	shr    $0x12,%r13
    2abd:	41 81 e5 f8 0f 00 00 	and    $0xff8,%r13d
    2ac4:	4c 01 e8             	add    %r13,%rax
    2ac7:	e9 06 ff ff ff       	jmpq   29d2 <memory_add+0x9d2>
    int err;

    ASSERT(!(s & ((1 << L2_PAGETABLE_SHIFT) - 1)));
    ASSERT(!(e & ((1 << L2_PAGETABLE_SHIFT) - 1)));

    for ( ; s < e; s += (1UL << L2_PAGETABLE_SHIFT))
    2acc:	31 d2                	xor    %edx,%edx
    2ace:	e9 2b f9 ff ff       	jmpq   23fe <memory_add+0x3fe>
    old_node_span = NODE_DATA(node)->node_spanned_pages;
    orig_online = node_online(node);

    if ( !orig_online )
    {
        dprintk(XENLOG_WARNING, "node %x pxm %x is not online\n",node, pxm);
    2ad3:	8b 4c 24 44          	mov    0x44(%rsp),%ecx
    2ad7:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 2ade <memory_add+0xade>
    2ade:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 2ae5 <memory_add+0xae5>
    2ae5:	41 89 e8             	mov    %ebp,%r8d
    2ae8:	ba fc 06 00 00       	mov    $0x6fc,%edx
    2aed:	e8 00 00 00 00       	callq  2af2 <memory_add+0xaf2>
        NODE_DATA(node)->node_id = node;
    2af2:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
        NODE_DATA(node)->node_start_pfn = spfn;
    2af7:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
    orig_online = node_online(node);

    if ( !orig_online )
    {
        dprintk(XENLOG_WARNING, "node %x pxm %x is not online\n",node, pxm);
        NODE_DATA(node)->node_id = node;
    2afc:	8b 54 24 44          	mov    0x44(%rsp),%edx
        NODE_DATA(node)->node_start_pfn = spfn;
        NODE_DATA(node)->node_spanned_pages =
                epfn - node_start_pfn(node);
    2b00:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8

    if ( !orig_online )
    {
        dprintk(XENLOG_WARNING, "node %x pxm %x is not online\n",node, pxm);
        NODE_DATA(node)->node_id = node;
        NODE_DATA(node)->node_start_pfn = spfn;
    2b05:	48 89 08             	mov    %rcx,(%rax)
    orig_online = node_online(node);

    if ( !orig_online )
    {
        dprintk(XENLOG_WARNING, "node %x pxm %x is not online\n",node, pxm);
        NODE_DATA(node)->node_id = node;
    2b08:	89 50 10             	mov    %edx,0x10(%rax)
        NODE_DATA(node)->node_start_pfn = spfn;
        NODE_DATA(node)->node_spanned_pages =
                epfn - node_start_pfn(node);
    2b0b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
    2b10:	48 29 c8             	sub    %rcx,%rax
    2b13:	49 89 40 08          	mov    %rax,0x8(%r8)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 */
static inline void set_bit(int nr, volatile void *addr)
{
    asm volatile (
    2b17:	f0 0f ab 15 00 00 00 	lock bts %edx,0x0(%rip)        # 2b1f <memory_add+0xb1f>
    2b1e:	00 
    2b1f:	e9 6d f6 ff ff       	jmpq   2191 <memory_add+0x191>
#define CNT ((sizeof(*frame_table) & -sizeof(*frame_table)) / \
             sizeof(*compat_machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & -sizeof(*frame_table)) % \
                 sizeof(*compat_machine_to_phys_mapping));

    for ( i = smap; i < emap; i += (1UL << (L2_PAGETABLE_SHIFT - 2)) )
    2b24:	31 db                	xor    %ebx,%ebx
    2b26:	e9 c0 fc ff ff       	jmpq   27eb <memory_add+0x7eb>
            goto destroy_m2p;
        }
    }

    /* We can't revert any more */
    transfer_pages_to_heap(&info);
    2b2b:	4c 89 ef             	mov    %r13,%rdi
    2b2e:	e8 00 00 00 00       	callq  2b33 <memory_add+0xb33>

    share_hotadd_m2p_table(&info);
    2b33:	4c 89 ef             	mov    %r13,%rdi
    2b36:	e8 00 00 00 00       	callq  2b3b <memory_add+0xb3b>

    return 0;
    2b3b:	e9 15 f8 ff ff       	jmpq   2355 <memory_add+0x355>
    2b40:	89 c3                	mov    %eax,%ebx
    2b42:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
    2b47:	e9 2f fd ff ff       	jmpq   287b <memory_add+0x87b>
    2b4c:	89 c3                	mov    %eax,%ebx
    2b4e:	4c 8b 6c 24 68       	mov    0x68(%rsp),%r13
    2b53:	e9 23 fd ff ff       	jmpq   287b <memory_add+0x87b>
    if ( (node = setup_node(pxm)) == -1 )
        return -EINVAL;

    if ( !valid_numa_range(spfn << PAGE_SHIFT, epfn << PAGE_SHIFT, node) )
    {
        dprintk(XENLOG_WARNING, "spfn %lx ~ epfn %lx pxm %x node %x"
    2b58:	8b 44 24 44          	mov    0x44(%rsp),%eax
    2b5c:	4c 8b 44 24 30       	mov    0x30(%rsp),%r8
    2b61:	48 8d 35 00 00 00 00 	lea    0x0(%rip),%rsi        # 2b68 <memory_add+0xb68>
    2b68:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
    2b6d:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 2b74 <memory_add+0xb74>
    2b74:	41 89 e9             	mov    %ebp,%r9d
    2b77:	ba e0 06 00 00       	mov    $0x6e0,%edx
    2b7c:	89 04 24             	mov    %eax,(%rsp)
    2b7f:	31 c0                	xor    %eax,%eax
    2b81:	e8 00 00 00 00       	callq  2b86 <memory_add+0xb86>
            "is not numa valid", spfn, epfn, pxm, node);
        return -EINVAL;
    2b86:	e9 ca f7 ff ff       	jmpq   2355 <memory_add+0x355>
    2b8b:	4c 8b 6c 24 68       	mov    0x68(%rsp),%r13
            else
            {
                l2_ro_mpt = alloc_xen_pagetable();
                if ( !l2_ro_mpt )
                {
                    ret = -ENOMEM;
    2b90:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
    2b95:	e9 e1 fc ff ff       	jmpq   287b <memory_add+0x87b>
    2b9a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000002ba0 <compat_set_gdt>:
#include <compat/xen.h>
#include <asm/mem_event.h>
#include <asm/mem_sharing.h>

int compat_set_gdt(XEN_GUEST_HANDLE_PARAM(uint) frame_list, unsigned int entries)
{
    2ba0:	41 57                	push   %r15
    unsigned long frames[16];
    long ret;

    /* Rechecked in set_gdt, but ensures a sane limit for copy_from_user(). */
    if ( entries > FIRST_RESERVED_GDT_ENTRY )
        return -EINVAL;
    2ba2:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
#include <compat/xen.h>
#include <asm/mem_event.h>
#include <asm/mem_sharing.h>

int compat_set_gdt(XEN_GUEST_HANDLE_PARAM(uint) frame_list, unsigned int entries)
{
    2ba7:	41 89 f7             	mov    %esi,%r15d
    2baa:	41 56                	push   %r14
    2bac:	41 55                	push   %r13
    2bae:	41 54                	push   %r12
    2bb0:	55                   	push   %rbp
    2bb1:	53                   	push   %rbx
    2bb2:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
    unsigned int i, nr_pages = (entries + 511) / 512;
    unsigned long frames[16];
    long ret;

    /* Rechecked in set_gdt, but ensures a sane limit for copy_from_user(). */
    if ( entries > FIRST_RESERVED_GDT_ENTRY )
    2bb9:	81 fe 00 1c 00 00    	cmp    $0x1c00,%esi
    2bbf:	0f 87 bc 00 00 00    	ja     2c81 <compat_set_gdt+0xe1>
    2bc5:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
#include <asm/mem_event.h>
#include <asm/mem_sharing.h>

int compat_set_gdt(XEN_GUEST_HANDLE_PARAM(uint) frame_list, unsigned int entries)
{
    unsigned int i, nr_pages = (entries + 511) / 512;
    2bcc:	41 8d 97 ff 01 00 00 	lea    0x1ff(%r15),%edx
    2bd3:	48 21 e0             	and    %rsp,%rax

    /* Rechecked in set_gdt, but ensures a sane limit for copy_from_user(). */
    if ( entries > FIRST_RESERVED_GDT_ENTRY )
        return -EINVAL;

    if ( !guest_handle_okay(frame_list, nr_pages) )
    2bd6:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
#include <asm/mem_event.h>
#include <asm/mem_sharing.h>

int compat_set_gdt(XEN_GUEST_HANDLE_PARAM(uint) frame_list, unsigned int entries)
{
    unsigned int i, nr_pages = (entries + 511) / 512;
    2bdd:	c1 ea 09             	shr    $0x9,%edx

    /* Rechecked in set_gdt, but ensures a sane limit for copy_from_user(). */
    if ( entries > FIRST_RESERVED_GDT_ENTRY )
        return -EINVAL;

    if ( !guest_handle_okay(frame_list, nr_pages) )
    2be0:	48 8b 48 10          	mov    0x10(%rax),%rcx
    2be4:	f6 81 d1 0a 00 00 40 	testb  $0x40,0xad1(%rcx)
    2beb:	0f 84 a7 00 00 00    	je     2c98 <compat_set_gdt+0xf8>
        return -EFAULT;

    for ( i = 0; i < nr_pages; ++i )
    2bf1:	85 d2                	test   %edx,%edx
    2bf3:	0f 84 f8 00 00 00    	je     2cf1 <compat_set_gdt+0x151>
    2bf9:	48 8d 44 24 18       	lea    0x18(%rsp),%rax
#include <compat/memory.h>
#include <compat/xen.h>
#include <asm/mem_event.h>
#include <asm/mem_sharing.h>

int compat_set_gdt(XEN_GUEST_HANDLE_PARAM(uint) frame_list, unsigned int entries)
    2bfe:	83 ea 01             	sub    $0x1,%edx
    2c01:	49 c7 c4 00 80 ff ff 	mov    $0xffffffffffff8000,%r12
        return -EINVAL;

    if ( !guest_handle_okay(frame_list, nr_pages) )
        return -EFAULT;

    for ( i = 0; i < nr_pages; ++i )
    2c08:	48 89 fd             	mov    %rdi,%rbp
            return ret;
        case 2:
            __get_user_size(*(u16 *)to, from, 2, ret, 2);
            return ret;
        case 4:
            __get_user_size(*(u32 *)to, from, 4, ret, 4);
    2c0b:	45 31 f6             	xor    %r14d,%r14d
    2c0e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
    2c13:	48 89 c3             	mov    %rax,%rbx
#include <compat/memory.h>
#include <compat/xen.h>
#include <asm/mem_event.h>
#include <asm/mem_sharing.h>

int compat_set_gdt(XEN_GUEST_HANDLE_PARAM(uint) frame_list, unsigned int entries)
    2c16:	4c 8d 6c d0 08       	lea    0x8(%rax,%rdx,8),%r13
    2c1b:	49 21 e4             	and    %rsp,%r12
    2c1e:	eb 2d                	jmp    2c4d <compat_set_gdt+0xad>
    2c20:	4c 89 f0             	mov    %r14,%rax
    2c23:	8b 55 00             	mov    0x0(%rbp),%edx

    for ( i = 0; i < nr_pages; ++i )
    {
        unsigned int frame;

        if ( __copy_from_guest(&frame, frame_list, 1) )
    2c26:	48 85 c0             	test   %rax,%rax
    2c29:	89 94 24 9c 00 00 00 	mov    %edx,0x9c(%rsp)
    2c30:	75 4a                	jne    2c7c <compat_set_gdt+0xdc>
            return -EFAULT;
        frames[i] = frame;
    2c32:	8b 84 24 9c 00 00 00 	mov    0x9c(%rsp),%eax
    2c39:	48 83 c5 04          	add    $0x4,%rbp
    2c3d:	48 89 03             	mov    %rax,(%rbx)
    2c40:	48 83 c3 08          	add    $0x8,%rbx
        return -EINVAL;

    if ( !guest_handle_okay(frame_list, nr_pages) )
        return -EFAULT;

    for ( i = 0; i < nr_pages; ++i )
    2c44:	4c 39 eb             	cmp    %r13,%rbx
    2c47:	0f 84 b3 00 00 00    	je     2d00 <compat_set_gdt+0x160>
    {
        unsigned int frame;

        if ( __copy_from_guest(&frame, frame_list, 1) )
    2c4d:	49 8b 84 24 e8 7f 00 	mov    0x7fe8(%r12),%rax
    2c54:	00 
    2c55:	48 8b 40 10          	mov    0x10(%rax),%rax
    2c59:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    2c60:	74 be                	je     2c20 <compat_set_gdt+0x80>
    2c62:	48 8d bc 24 9c 00 00 	lea    0x9c(%rsp),%rdi
    2c69:	00 
    2c6a:	ba 04 00 00 00       	mov    $0x4,%edx
    2c6f:	48 89 ee             	mov    %rbp,%rsi
    2c72:	e8 00 00 00 00       	callq  2c77 <compat_set_gdt+0xd7>
    2c77:	48 85 c0             	test   %rax,%rax
    2c7a:	74 b6                	je     2c32 <compat_set_gdt+0x92>
            return -EFAULT;
    2c7c:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
        flush_tlb_local();

    domain_unlock(current->domain);

    return ret;
}
    2c81:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
    2c88:	5b                   	pop    %rbx
    2c89:	5d                   	pop    %rbp
    2c8a:	41 5c                	pop    %r12
    2c8c:	41 5d                	pop    %r13
    2c8e:	41 5e                	pop    %r14
    2c90:	41 5f                	pop    %r15
    2c92:	c3                   	retq   
    2c93:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

    /* Rechecked in set_gdt, but ensures a sane limit for copy_from_user(). */
    if ( entries > FIRST_RESERVED_GDT_ENTRY )
        return -EINVAL;

    if ( !guest_handle_okay(frame_list, nr_pages) )
    2c98:	48 be 00 00 00 00 00 	movabs $0xffff800000000000,%rsi
    2c9f:	80 ff ff 
    2ca2:	48 b9 ff ff ff ff ff 	movabs $0xffff07ffffffffff,%rcx
    2ca9:	07 ff ff 
    2cac:	48 01 fe             	add    %rdi,%rsi
    2caf:	48 39 ce             	cmp    %rcx,%rsi
    2cb2:	0f 87 39 ff ff ff    	ja     2bf1 <compat_set_gdt+0x51>
    2cb8:	8b 00                	mov    (%rax),%eax
    2cba:	48 b9 00 00 00 80 ff 	movabs $0x7dff80000000,%rcx
    2cc1:	7d 00 00 
    2cc4:	48 01 f9             	add    %rdi,%rcx
    2cc7:	c1 e0 0e             	shl    $0xe,%eax
    2cca:	48 98                	cltq   
    2ccc:	48 29 c1             	sub    %rax,%rcx
        return -EFAULT;
    2ccf:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax

    /* Rechecked in set_gdt, but ensures a sane limit for copy_from_user(). */
    if ( entries > FIRST_RESERVED_GDT_ENTRY )
        return -EINVAL;

    if ( !guest_handle_okay(frame_list, nr_pages) )
    2cd4:	48 81 f9 ff 1f 00 00 	cmp    $0x1fff,%rcx
    2cdb:	77 a4                	ja     2c81 <compat_set_gdt+0xe1>
    2cdd:	89 d6                	mov    %edx,%esi
    2cdf:	48 8d 0c b1          	lea    (%rcx,%rsi,4),%rcx
    2ce3:	48 81 f9 00 20 00 00 	cmp    $0x2000,%rcx
    2cea:	77 95                	ja     2c81 <compat_set_gdt+0xe1>
    2cec:	e9 00 ff ff ff       	jmpq   2bf1 <compat_set_gdt+0x51>
    2cf1:	48 8d 44 24 18       	lea    0x18(%rsp),%rax
    2cf6:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
    2cfb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    2d00:	48 c7 c3 00 80 ff ff 	mov    $0xffffffffffff8000,%rbx
    2d07:	48 21 e3             	and    %rsp,%rbx
            return -EFAULT;
        frames[i] = frame;
        guest_handle_add_offset(frame_list, 1);
    }

    domain_lock(current->domain);
    2d0a:	48 8b 83 e8 7f 00 00 	mov    0x7fe8(%rbx),%rax
    2d11:	48 8b 78 10          	mov    0x10(%rax),%rdi
    2d15:	48 83 c7 10          	add    $0x10,%rdi
    2d19:	e8 00 00 00 00       	callq  2d1e <compat_set_gdt+0x17e>

    if ( (ret = set_gdt(current, frames, entries)) == 0 )
    2d1e:	48 8b bb e8 7f 00 00 	mov    0x7fe8(%rbx),%rdi
    2d25:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
    2d2a:	44 89 fa             	mov    %r15d,%edx
    2d2d:	e8 00 00 00 00       	callq  2d32 <compat_set_gdt+0x192>
    2d32:	48 85 c0             	test   %rax,%rax
    2d35:	48 89 c3             	mov    %rax,%rbx
    2d38:	74 26                	je     2d60 <compat_set_gdt+0x1c0>
    2d3a:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    2d41:	48 21 e0             	and    %rsp,%rax
        flush_tlb_local();

    domain_unlock(current->domain);
    2d44:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    2d4b:	48 8b 78 10          	mov    0x10(%rax),%rdi
    2d4f:	48 83 c7 10          	add    $0x10,%rdi
    2d53:	e8 00 00 00 00       	callq  2d58 <compat_set_gdt+0x1b8>

    return ret;
    2d58:	89 d8                	mov    %ebx,%eax
    2d5a:	e9 22 ff ff ff       	jmpq   2c81 <compat_set_gdt+0xe1>
    2d5f:	90                   	nop
    }

    domain_lock(current->domain);

    if ( (ret = set_gdt(current, frames, entries)) == 0 )
        flush_tlb_local();
    2d60:	be 00 01 00 00       	mov    $0x100,%esi
    2d65:	31 ff                	xor    %edi,%edi
    2d67:	e8 00 00 00 00       	callq  2d6c <compat_set_gdt+0x1cc>
    2d6c:	eb cc                	jmp    2d3a <compat_set_gdt+0x19a>
    2d6e:	66 90                	xchg   %ax,%ax

0000000000002d70 <compat_update_descriptor>:

    return ret;
}

int compat_update_descriptor(u32 pa_lo, u32 pa_hi, u32 desc_lo, u32 desc_hi)
{
    2d70:	89 f8                	mov    %edi,%eax
    2d72:	89 f7                	mov    %esi,%edi
    return do_update_descriptor(pa_lo | ((u64)pa_hi << 32),
                                desc_lo | ((u64)desc_hi << 32));
    2d74:	48 89 ce             	mov    %rcx,%rsi
    return ret;
}

int compat_update_descriptor(u32 pa_lo, u32 pa_hi, u32 desc_lo, u32 desc_hi)
{
    return do_update_descriptor(pa_lo | ((u64)pa_hi << 32),
    2d77:	89 d2                	mov    %edx,%edx
                                desc_lo | ((u64)desc_hi << 32));
    2d79:	48 c1 e6 20          	shl    $0x20,%rsi
    return ret;
}

int compat_update_descriptor(u32 pa_lo, u32 pa_hi, u32 desc_lo, u32 desc_hi)
{
    return do_update_descriptor(pa_lo | ((u64)pa_hi << 32),
    2d7d:	48 c1 e7 20          	shl    $0x20,%rdi

    return ret;
}

int compat_update_descriptor(u32 pa_lo, u32 pa_hi, u32 desc_lo, u32 desc_hi)
{
    2d81:	48 83 ec 08          	sub    $0x8,%rsp
    return do_update_descriptor(pa_lo | ((u64)pa_hi << 32),
    2d85:	48 09 d6             	or     %rdx,%rsi
    2d88:	48 09 c7             	or     %rax,%rdi
    2d8b:	e8 00 00 00 00       	callq  2d90 <compat_update_descriptor+0x20>
                                desc_lo | ((u64)desc_hi << 32));
}
    2d90:	48 83 c4 08          	add    $0x8,%rsp
    2d94:	c3                   	retq   
    2d95:	66 66 2e 0f 1f 84 00 	data32 nopw %cs:0x0(%rax,%rax,1)
    2d9c:	00 00 00 00 

0000000000002da0 <compat_arch_memory_op>:

int compat_arch_memory_op(int op, XEN_GUEST_HANDLE_PARAM(void) arg)
{
    2da0:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
    2da7:	4c 89 b4 24 98 00 00 	mov    %r14,0x98(%rsp)
    2dae:	00 
    2daf:	41 89 fe             	mov    %edi,%r14d
    2db2:	48 89 ac 24 80 00 00 	mov    %rbp,0x80(%rsp)
    2db9:	00 
    unsigned long v;
    compat_pfn_t mfn;
    unsigned int i;
    int rc = 0;

    switch ( op )
    2dba:	41 8d 46 fb          	lea    -0x5(%r14),%eax
    return do_update_descriptor(pa_lo | ((u64)pa_hi << 32),
                                desc_lo | ((u64)desc_hi << 32));
}

int compat_arch_memory_op(int op, XEN_GUEST_HANDLE_PARAM(void) arg)
{
    2dbe:	48 89 5c 24 78       	mov    %rbx,0x78(%rsp)
    2dc3:	4c 89 a4 24 88 00 00 	mov    %r12,0x88(%rsp)
    2dca:	00 
    2dcb:	4c 89 ac 24 90 00 00 	mov    %r13,0x90(%rsp)
    2dd2:	00 
    2dd3:	4c 89 bc 24 a0 00 00 	mov    %r15,0xa0(%rsp)
    2dda:	00 
    2ddb:	48 89 f5             	mov    %rsi,%rbp
    unsigned long v;
    compat_pfn_t mfn;
    unsigned int i;
    int rc = 0;

    switch ( op )
    2dde:	83 f8 11             	cmp    $0x11,%eax
    2de1:	76 4d                	jbe    2e30 <compat_arch_memory_op+0x90>
            return -EFAULT;
        break;
    }

    default:
        rc = -ENOSYS;
    2de3:	bb da ff ff ff       	mov    $0xffffffda,%ebx
    2de8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    2def:	00 
        break;
    }

    return rc;
}
    2df0:	89 d8                	mov    %ebx,%eax
    2df2:	48 8b ac 24 80 00 00 	mov    0x80(%rsp),%rbp
    2df9:	00 
    2dfa:	48 8b 5c 24 78       	mov    0x78(%rsp),%rbx
    2dff:	4c 8b a4 24 88 00 00 	mov    0x88(%rsp),%r12
    2e06:	00 
    2e07:	4c 8b ac 24 90 00 00 	mov    0x90(%rsp),%r13
    2e0e:	00 
    2e0f:	4c 8b b4 24 98 00 00 	mov    0x98(%rsp),%r14
    2e16:	00 
    2e17:	4c 8b bc 24 a0 00 00 	mov    0xa0(%rsp),%r15
    2e1e:	00 
    2e1f:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
    2e26:	c3                   	retq   
    2e27:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    2e2e:	00 00 
    unsigned long v;
    compat_pfn_t mfn;
    unsigned int i;
    int rc = 0;

    switch ( op )
    2e30:	48 8d 15 00 00 00 00 	lea    0x0(%rip),%rdx        # 2e37 <compat_arch_memory_op+0x97>
    2e37:	48 63 04 82          	movslq (%rdx,%rax,4),%rax
    2e3b:	48 01 c2             	add    %rax,%rdx
    2e3e:	ff e2                	jmpq   *%rdx
    2e40:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
        break;
    }
    case XENMEM_sharing_op:
    {
        xen_mem_sharing_op_t mso;
        if ( copy_from_guest(&mso, arg, 1) )
    2e47:	4c 8d 64 24 08       	lea    0x8(%rsp),%r12
    2e4c:	ba 30 00 00 00       	mov    $0x30,%edx
    2e51:	48 21 e0             	and    %rsp,%rax
    2e54:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    2e5b:	4c 89 e7             	mov    %r12,%rdi
    2e5e:	48 8b 40 10          	mov    0x10(%rax),%rax
    2e62:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    2e69:	0f 85 e1 06 00 00    	jne    3550 <compat_arch_memory_op+0x7b0>
    2e6f:	e8 00 00 00 00       	callq  2e74 <compat_arch_memory_op+0xd4>
    2e74:	48 85 c0             	test   %rax,%rax
            return -EFAULT;
    2e77:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
        break;
    }
    case XENMEM_sharing_op:
    {
        xen_mem_sharing_op_t mso;
        if ( copy_from_guest(&mso, arg, 1) )
    2e7c:	0f 85 6e ff ff ff    	jne    2df0 <compat_arch_memory_op+0x50>
            return -EFAULT;
        if ( mso.op == XENMEM_sharing_op_audit )
    2e82:	80 7c 24 08 08       	cmpb   $0x8,0x8(%rsp)
    2e87:	0f 84 53 07 00 00    	je     35e0 <compat_arch_memory_op+0x840>
            return mem_sharing_audit(); 
        rc = do_mem_event_op(op, mso.domain, (void *) &mso);
    2e8d:	0f b7 74 24 0a       	movzwl 0xa(%rsp),%esi
    2e92:	4c 89 e2             	mov    %r12,%rdx
    2e95:	bf 16 00 00 00       	mov    $0x16,%edi
    2e9a:	e8 00 00 00 00       	callq  2e9f <compat_arch_memory_op+0xff>
        if ( !rc && __copy_to_guest(arg, &mso, 1) )
    2e9f:	85 c0                	test   %eax,%eax
        xen_mem_sharing_op_t mso;
        if ( copy_from_guest(&mso, arg, 1) )
            return -EFAULT;
        if ( mso.op == XENMEM_sharing_op_audit )
            return mem_sharing_audit(); 
        rc = do_mem_event_op(op, mso.domain, (void *) &mso);
    2ea1:	89 c3                	mov    %eax,%ebx
        if ( !rc && __copy_to_guest(arg, &mso, 1) )
    2ea3:	0f 85 47 ff ff ff    	jne    2df0 <compat_arch_memory_op+0x50>
    2ea9:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    2eb0:	ba 30 00 00 00       	mov    $0x30,%edx
    2eb5:	4c 89 e6             	mov    %r12,%rsi
    2eb8:	48 21 e0             	and    %rsp,%rax
    2ebb:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    2ec2:	48 89 ef             	mov    %rbp,%rdi
    2ec5:	48 8b 40 10          	mov    0x10(%rax),%rax
    2ec9:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    2ed0:	0f 85 f7 05 00 00    	jne    34cd <compat_arch_memory_op+0x72d>
        case 8:
            __put_user_size(*(const u64 *)from, (u64 __user *)to, 8, ret, 8);
            return ret;
        }
    }
    return __copy_to_user_ll(to, from, n);
    2ed6:	e8 00 00 00 00       	callq  2edb <compat_arch_memory_op+0x13b>
    2edb:	e9 f2 05 00 00       	jmpq   34d2 <compat_arch_memory_op+0x732>
    2ee0:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    case XENMEM_machphys_mfn_list:
    {
        unsigned long limit;
        compat_pfn_t last_mfn;

        if ( copy_from_guest(&xmml, arg, 1) )
    2ee7:	4c 8d 7c 24 60       	lea    0x60(%rsp),%r15
    2eec:	ba 0c 00 00 00       	mov    $0xc,%edx
    2ef1:	48 21 e0             	and    %rsp,%rax
    2ef4:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    2efb:	4c 89 ff             	mov    %r15,%rdi
    2efe:	48 8b 40 10          	mov    0x10(%rax),%rax
    2f02:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    2f09:	0f 85 31 06 00 00    	jne    3540 <compat_arch_memory_op+0x7a0>
    2f0f:	e8 00 00 00 00       	callq  2f14 <compat_arch_memory_op+0x174>
    2f14:	48 85 c0             	test   %rax,%rax
            return -EFAULT;
    2f17:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
    case XENMEM_machphys_mfn_list:
    {
        unsigned long limit;
        compat_pfn_t last_mfn;

        if ( copy_from_guest(&xmml, arg, 1) )
    2f1c:	0f 85 ce fe ff ff    	jne    2df0 <compat_arch_memory_op+0x50>
            return -EFAULT;

        limit = (unsigned long)(compat_machine_to_phys_mapping + max_page);
    2f22:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 2f29 <compat_arch_memory_op+0x189>
    2f29:	49 bc 00 00 00 40 c4 	movabs $0xffff82c440000000,%r12
    2f30:	82 ff ff 
    2f33:	4d 8d 34 84          	lea    (%r12,%rax,4),%r14
    2f37:	48 b8 00 00 00 80 c4 	movabs $0xffff82c480000000,%rax
    2f3e:	82 ff ff 
    2f41:	49 39 c6             	cmp    %rax,%r14
    2f44:	4c 0f 47 f0          	cmova  %rax,%r14
        if ( limit > RDWR_COMPAT_MPT_VIRT_END )
            limit = RDWR_COMPAT_MPT_VIRT_END;
        for ( i = 0, v = RDWR_COMPAT_MPT_VIRT_START, last_mfn = 0;
    2f48:	4d 39 e6             	cmp    %r12,%r14
    2f4b:	0f 86 19 06 00 00    	jbe    356a <compat_arch_memory_op+0x7ca>
    2f51:	8b 4c 24 60          	mov    0x60(%rsp),%ecx
    2f55:	85 c9                	test   %ecx,%ecx
    2f57:	0f 84 0d 06 00 00    	je     356a <compat_arch_memory_op+0x7ca>
    2f5d:	49 c7 c5 00 80 ff ff 	mov    $0xffffffffffff8000,%r13
    2f64:	31 c9                	xor    %ecx,%ecx
    2f66:	31 db                	xor    %ebx,%ebx
    2f68:	49 21 e5             	and    %rsp,%r13
    2f6b:	eb 73                	jmp    2fe0 <compat_arch_memory_op+0x240>
    2f6d:	0f 1f 00             	nopl   (%rax)
              (i != xmml.max_extents) && (v < limit);
              i++, v += 1 << L2_PAGETABLE_SHIFT )
        {
            l2e = compat_idle_pg_table_l2[l2_table_offset(v)];
            if ( l2e_get_flags(l2e) & _PAGE_PRESENT )
                mfn = l2e_get_pfn(l2e);
    2f70:	48 ba 00 f0 ff ff ff 	movabs $0xffffffffff000,%rdx
    2f77:	ff 0f 00 
    2f7a:	48 21 d0             	and    %rdx,%rax
    2f7d:	48 c1 e8 0c          	shr    $0xc,%rax
    2f81:	89 44 24 6c          	mov    %eax,0x6c(%rsp)
            else
                mfn = last_mfn;
            ASSERT(mfn);
            if ( copy_to_compat_offset(xmml.extent_start, i, &mfn, 1) )
    2f85:	49 8b 85 e8 7f 00 00 	mov    0x7fe8(%r13),%rax
    2f8c:	8b 54 24 64          	mov    0x64(%rsp),%edx
    2f90:	48 8d 74 24 6c       	lea    0x6c(%rsp),%rsi
    2f95:	48 8b 40 10          	mov    0x10(%rax),%rax
    2f99:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    2fa0:	89 d8                	mov    %ebx,%eax
    2fa2:	48 8d 3c 82          	lea    (%rdx,%rax,4),%rdi
    2fa6:	ba 04 00 00 00       	mov    $0x4,%edx
    2fab:	0f 84 af 05 00 00    	je     3560 <compat_arch_memory_op+0x7c0>
    2fb1:	e8 00 00 00 00       	callq  2fb6 <compat_arch_memory_op+0x216>
    2fb6:	48 85 c0             	test   %rax,%rax
    2fb9:	0f 85 58 04 00 00    	jne    3417 <compat_arch_memory_op+0x677>
        limit = (unsigned long)(compat_machine_to_phys_mapping + max_page);
        if ( limit > RDWR_COMPAT_MPT_VIRT_END )
            limit = RDWR_COMPAT_MPT_VIRT_END;
        for ( i = 0, v = RDWR_COMPAT_MPT_VIRT_START, last_mfn = 0;
              (i != xmml.max_extents) && (v < limit);
              i++, v += 1 << L2_PAGETABLE_SHIFT )
    2fbf:	49 81 c4 00 00 20 00 	add    $0x200000,%r12
    2fc6:	83 c3 01             	add    $0x1,%ebx
            else
                mfn = last_mfn;
            ASSERT(mfn);
            if ( copy_to_compat_offset(xmml.extent_start, i, &mfn, 1) )
                return -EFAULT;
            last_mfn = mfn;
    2fc9:	8b 4c 24 6c          	mov    0x6c(%rsp),%ecx
            return -EFAULT;

        limit = (unsigned long)(compat_machine_to_phys_mapping + max_page);
        if ( limit > RDWR_COMPAT_MPT_VIRT_END )
            limit = RDWR_COMPAT_MPT_VIRT_END;
        for ( i = 0, v = RDWR_COMPAT_MPT_VIRT_START, last_mfn = 0;
    2fcd:	4d 39 f4             	cmp    %r14,%r12
    2fd0:	0f 83 9a 05 00 00    	jae    3570 <compat_arch_memory_op+0x7d0>
    2fd6:	39 5c 24 60          	cmp    %ebx,0x60(%rsp)
    2fda:	0f 84 90 05 00 00    	je     3570 <compat_arch_memory_op+0x7d0>
              (i != xmml.max_extents) && (v < limit);
              i++, v += 1 << L2_PAGETABLE_SHIFT )
        {
            l2e = compat_idle_pg_table_l2[l2_table_offset(v)];
    2fe0:	4c 89 e0             	mov    %r12,%rax
    2fe3:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 2fea <compat_arch_memory_op+0x24a>
    2fea:	48 c1 e8 15          	shr    $0x15,%rax
    2fee:	25 ff 01 00 00       	and    $0x1ff,%eax
    2ff3:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
            if ( l2e_get_flags(l2e) & _PAGE_PRESENT )
    2ff7:	a8 01                	test   $0x1,%al
    2ff9:	0f 85 71 ff ff ff    	jne    2f70 <compat_arch_memory_op+0x1d0>
                mfn = l2e_get_pfn(l2e);
            else
                mfn = last_mfn;
    2fff:	89 4c 24 6c          	mov    %ecx,0x6c(%rsp)
    3003:	eb 80                	jmp    2f85 <compat_arch_memory_op+0x1e5>
    3005:	0f 1f 00             	nopl   (%rax)
    3008:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    case XENMEM_add_to_physmap:
    {
        struct compat_add_to_physmap cmp;
        struct xen_add_to_physmap *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
    300f:	4c 8d 64 24 38       	lea    0x38(%rsp),%r12
    3014:	ba 10 00 00 00       	mov    $0x10,%edx
    3019:	48 21 e0             	and    %rsp,%rax
    switch ( op )
    {
    case XENMEM_add_to_physmap:
    {
        struct compat_add_to_physmap cmp;
        struct xen_add_to_physmap *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    301c:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax

        if ( copy_from_guest(&cmp, arg, 1) )
    3023:	4c 89 e7             	mov    %r12,%rdi
    switch ( op )
    {
    case XENMEM_add_to_physmap:
    {
        struct compat_add_to_physmap cmp;
        struct xen_add_to_physmap *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    3026:	44 8b 28             	mov    (%rax),%r13d

        if ( copy_from_guest(&cmp, arg, 1) )
    3029:	48 8b 40 10          	mov    0x10(%rax),%rax
    302d:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    3034:	0f 85 f6 04 00 00    	jne    3530 <compat_arch_memory_op+0x790>
    303a:	e8 00 00 00 00       	callq  303f <compat_arch_memory_op+0x29f>
    303f:	48 85 c0             	test   %rax,%rax
            return -EFAULT;
    3042:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
    case XENMEM_add_to_physmap:
    {
        struct compat_add_to_physmap cmp;
        struct xen_add_to_physmap *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
    3047:	0f 85 a3 fd ff ff    	jne    2df0 <compat_arch_memory_op+0x50>
    switch ( op )
    {
    case XENMEM_add_to_physmap:
    {
        struct compat_add_to_physmap cmp;
        struct xen_add_to_physmap *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    304d:	41 c1 e5 0e          	shl    $0xe,%r13d
    3051:	48 b8 00 00 00 80 00 	movabs $0xffff820080000000,%rax
    3058:	82 ff ff 

        if ( copy_from_guest(&cmp, arg, 1) )
            return -EFAULT;

        XLAT_add_to_physmap(nat, &cmp);
        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    305b:	bf 07 00 00 00       	mov    $0x7,%edi
    switch ( op )
    {
    case XENMEM_add_to_physmap:
    {
        struct compat_add_to_physmap cmp;
        struct xen_add_to_physmap *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    3060:	4d 63 ed             	movslq %r13d,%r13
    3063:	49 01 c5             	add    %rax,%r13

        if ( copy_from_guest(&cmp, arg, 1) )
            return -EFAULT;

        XLAT_add_to_physmap(nat, &cmp);
    3066:	0f b7 44 24 38       	movzwl 0x38(%rsp),%eax
        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    306b:	4c 89 ee             	mov    %r13,%rsi
        struct xen_add_to_physmap *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
            return -EFAULT;

        XLAT_add_to_physmap(nat, &cmp);
    306e:	66 41 89 45 00       	mov    %ax,0x0(%r13)
    3073:	0f b7 44 24 3a       	movzwl 0x3a(%rsp),%eax
    3078:	66 41 89 45 02       	mov    %ax,0x2(%r13)
    307d:	8b 44 24 3c          	mov    0x3c(%rsp),%eax
    3081:	41 89 45 04          	mov    %eax,0x4(%r13)
    3085:	8b 44 24 40          	mov    0x40(%rsp),%eax
    3089:	49 89 45 08          	mov    %rax,0x8(%r13)
    308d:	8b 54 24 44          	mov    0x44(%rsp),%edx
    3091:	49 89 55 10          	mov    %rdx,0x10(%r13)
        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    3095:	e8 00 00 00 00       	callq  309a <compat_arch_memory_op+0x2fa>

        if ( !rc || cmp.space != XENMAPSPACE_gmfn_range )
    309a:	85 c0                	test   %eax,%eax

        if ( copy_from_guest(&cmp, arg, 1) )
            return -EFAULT;

        XLAT_add_to_physmap(nat, &cmp);
        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    309c:	89 c3                	mov    %eax,%ebx

        if ( !rc || cmp.space != XENMAPSPACE_gmfn_range )
    309e:	0f 84 4c fd ff ff    	je     2df0 <compat_arch_memory_op+0x50>
    30a4:	83 7c 24 3c 03       	cmpl   $0x3,0x3c(%rsp)
    30a9:	0f 85 41 fd ff ff    	jne    2df0 <compat_arch_memory_op+0x50>
            break;

        XLAT_add_to_physmap(&cmp, nat);
    30af:	41 0f b7 45 00       	movzwl 0x0(%r13),%eax
        if ( __copy_to_guest(arg, &cmp, 1) )
    30b4:	ba 10 00 00 00       	mov    $0x10,%edx
    30b9:	4c 89 e6             	mov    %r12,%rsi
    30bc:	48 89 ef             	mov    %rbp,%rdi
        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));

        if ( !rc || cmp.space != XENMAPSPACE_gmfn_range )
            break;

        XLAT_add_to_physmap(&cmp, nat);
    30bf:	66 89 44 24 38       	mov    %ax,0x38(%rsp)
    30c4:	41 0f b7 45 02       	movzwl 0x2(%r13),%eax
    30c9:	66 89 44 24 3a       	mov    %ax,0x3a(%rsp)
    30ce:	41 8b 45 04          	mov    0x4(%r13),%eax
    30d2:	89 44 24 3c          	mov    %eax,0x3c(%rsp)
    30d6:	49 8b 45 08          	mov    0x8(%r13),%rax
    30da:	89 44 24 40          	mov    %eax,0x40(%rsp)
    30de:	49 8b 45 10          	mov    0x10(%r13),%rax
    30e2:	89 44 24 44          	mov    %eax,0x44(%rsp)
    30e6:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    30ed:	48 21 e0             	and    %rsp,%rax
        if ( __copy_to_guest(arg, &cmp, 1) )
    30f0:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    30f7:	48 8b 40 10          	mov    0x10(%rax),%rax
    30fb:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    3102:	0f 84 fd 04 00 00    	je     3605 <compat_arch_memory_op+0x865>
    3108:	e8 00 00 00 00       	callq  310d <compat_arch_memory_op+0x36d>
    310d:	48 85 c0             	test   %rax,%rax
    3110:	0f 85 f8 02 00 00    	jne    340e <compat_arch_memory_op+0x66e>
            if ( rc == __HYPERVISOR_memory_op )
                hypercall_cancel_continuation();
            return -EFAULT;
        }

        if ( rc == __HYPERVISOR_memory_op )
    3116:	83 fb 0c             	cmp    $0xc,%ebx
    3119:	0f 85 d1 fc ff ff    	jne    2df0 <compat_arch_memory_op+0x50>
            hypercall_xlat_continuation(NULL, 0x2, nat, arg);
    311f:	48 89 e9             	mov    %rbp,%rcx
    3122:	4c 89 ea             	mov    %r13,%rdx
    3125:	be 02 00 00 00       	mov    $0x2,%esi
    312a:	31 ff                	xor    %edi,%edi
    312c:	31 c0                	xor    %eax,%eax
    312e:	e8 00 00 00 00       	callq  3133 <compat_arch_memory_op+0x393>
    3133:	e9 b8 fc ff ff       	jmpq   2df0 <compat_arch_memory_op+0x50>
    3138:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    313f:	00 
    3140:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    case XENMEM_machine_memory_map:
    {
        struct compat_memory_map cmp;
        struct xen_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
    3147:	4c 8d 64 24 38       	lea    0x38(%rsp),%r12
    314c:	ba 08 00 00 00       	mov    $0x8,%edx
    3151:	48 21 e0             	and    %rsp,%rax

    case XENMEM_memory_map:
    case XENMEM_machine_memory_map:
    {
        struct compat_memory_map cmp;
        struct xen_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    3154:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax

        if ( copy_from_guest(&cmp, arg, 1) )
    315b:	4c 89 e7             	mov    %r12,%rdi

    case XENMEM_memory_map:
    case XENMEM_machine_memory_map:
    {
        struct compat_memory_map cmp;
        struct xen_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    315e:	44 8b 28             	mov    (%rax),%r13d

        if ( copy_from_guest(&cmp, arg, 1) )
    3161:	48 8b 40 10          	mov    0x10(%rax),%rax
    3165:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    316c:	0f 85 ae 03 00 00    	jne    3520 <compat_arch_memory_op+0x780>
    3172:	e8 00 00 00 00       	callq  3177 <compat_arch_memory_op+0x3d7>
    3177:	49 89 c7             	mov    %rax,%r15
    317a:	4d 85 ff             	test   %r15,%r15
            return -EFAULT;
    317d:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
    case XENMEM_machine_memory_map:
    {
        struct compat_memory_map cmp;
        struct xen_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
    3182:	0f 85 68 fc ff ff    	jne    2df0 <compat_arch_memory_op+0x50>

    case XENMEM_memory_map:
    case XENMEM_machine_memory_map:
    {
        struct compat_memory_map cmp;
        struct xen_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    3188:	41 c1 e5 0e          	shl    $0xe,%r13d
    318c:	48 b8 00 00 00 80 00 	movabs $0xffff820080000000,%rax
    3193:	82 ff ff 
#define XLAT_memory_map_HNDL_buffer(_d_, _s_) \
        guest_from_compat_handle((_d_)->buffer, (_s_)->buffer)
        XLAT_memory_map(nat, &cmp);
#undef XLAT_memory_map_HNDL_buffer

        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    3196:	44 89 f7             	mov    %r14d,%edi

    case XENMEM_memory_map:
    case XENMEM_machine_memory_map:
    {
        struct compat_memory_map cmp;
        struct xen_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    3199:	4d 63 ed             	movslq %r13d,%r13
    319c:	49 01 c5             	add    %rax,%r13
        if ( copy_from_guest(&cmp, arg, 1) )
            return -EFAULT;

#define XLAT_memory_map_HNDL_buffer(_d_, _s_) \
        guest_from_compat_handle((_d_)->buffer, (_s_)->buffer)
        XLAT_memory_map(nat, &cmp);
    319f:	8b 44 24 38          	mov    0x38(%rsp),%eax
#undef XLAT_memory_map_HNDL_buffer

        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    31a3:	4c 89 ee             	mov    %r13,%rsi
        if ( copy_from_guest(&cmp, arg, 1) )
            return -EFAULT;

#define XLAT_memory_map_HNDL_buffer(_d_, _s_) \
        guest_from_compat_handle((_d_)->buffer, (_s_)->buffer)
        XLAT_memory_map(nat, &cmp);
    31a6:	41 89 45 00          	mov    %eax,0x0(%r13)
    31aa:	8b 54 24 3c          	mov    0x3c(%rsp),%edx
    31ae:	49 89 55 08          	mov    %rdx,0x8(%r13)
#undef XLAT_memory_map_HNDL_buffer

        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    31b2:	e8 00 00 00 00       	callq  31b7 <compat_arch_memory_op+0x417>
        if ( rc < 0 )
    31b7:	85 c0                	test   %eax,%eax
#define XLAT_memory_map_HNDL_buffer(_d_, _s_) \
        guest_from_compat_handle((_d_)->buffer, (_s_)->buffer)
        XLAT_memory_map(nat, &cmp);
#undef XLAT_memory_map_HNDL_buffer

        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    31b9:	89 c3                	mov    %eax,%ebx
        if ( rc < 0 )
    31bb:	0f 88 2f fc ff ff    	js     2df0 <compat_arch_memory_op+0x50>
            break;

#define XLAT_memory_map_HNDL_buffer(_d_, _s_) ((void)0)
        XLAT_memory_map(&cmp, nat);
    31c1:	41 8b 45 00          	mov    0x0(%r13),%eax
    31c5:	89 44 24 38          	mov    %eax,0x38(%rsp)
    31c9:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    31d0:	48 21 e0             	and    %rsp,%rax
#undef XLAT_memory_map_HNDL_buffer
        if ( __copy_to_guest(arg, &cmp, 1) )
    31d3:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    31da:	48 8b 40 10          	mov    0x10(%rax),%rax
    31de:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    31e5:	0f 85 d5 03 00 00    	jne    35c0 <compat_arch_memory_op+0x820>
            return ret;
        case 4:
            __put_user_size(*(const u32 *)from, (u32 __user *)to, 4, ret, 4);
            return ret;
        case 8:
            __put_user_size(*(const u64 *)from, (u64 __user *)to, 8, ret, 8);
    31eb:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
    31f0:	48 89 45 00          	mov    %rax,0x0(%rbp)
            rc = -EFAULT;
    31f4:	4d 85 ff             	test   %r15,%r15
    31f7:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
    31fc:	0f 45 d8             	cmovne %eax,%ebx
    31ff:	e9 ec fb ff ff       	jmpq   2df0 <compat_arch_memory_op+0x50>
    3204:	0f 1f 40 00          	nopl   0x0(%rax)
    3208:	48 c7 c2 00 80 ff ff 	mov    $0xffffffffffff8000,%rdx
            .v_start = MACH2PHYS_COMPAT_VIRT_START(d),
            .v_end   = MACH2PHYS_COMPAT_VIRT_END,
            .max_mfn = MACH2PHYS_COMPAT_NR_ENTRIES(d) - 1
        };

        if ( copy_to_guest(arg, &mapping, 1) )
    320f:	48 8d 74 24 38       	lea    0x38(%rsp),%rsi
    3214:	48 89 ef             	mov    %rbp,%rdi
    3217:	48 21 e2             	and    %rsp,%rdx
        break;
    }

    case XENMEM_machphys_mapping:
    {
        struct domain *d = current->domain;
    321a:	48 8b 82 e8 7f 00 00 	mov    0x7fe8(%rdx),%rax
        struct compat_machphys_mapping mapping = {
            .v_start = MACH2PHYS_COMPAT_VIRT_START(d),
    3221:	48 8b 40 10          	mov    0x10(%rax),%rax
    3225:	8b 88 88 02 00 00    	mov    0x288(%rax),%ecx
            .v_end   = MACH2PHYS_COMPAT_VIRT_END,
            .max_mfn = MACH2PHYS_COMPAT_NR_ENTRIES(d) - 1
    322b:	b8 00 00 e0 ff       	mov    $0xffe00000,%eax
    }

    case XENMEM_machphys_mapping:
    {
        struct domain *d = current->domain;
        struct compat_machphys_mapping mapping = {
    3230:	c7 44 24 3c 00 00 e0 	movl   $0xffe00000,0x3c(%rsp)
    3237:	ff 
            .v_start = MACH2PHYS_COMPAT_VIRT_START(d),
            .v_end   = MACH2PHYS_COMPAT_VIRT_END,
            .max_mfn = MACH2PHYS_COMPAT_NR_ENTRIES(d) - 1
    3238:	29 c8                	sub    %ecx,%eax
    }

    case XENMEM_machphys_mapping:
    {
        struct domain *d = current->domain;
        struct compat_machphys_mapping mapping = {
    323a:	89 4c 24 38          	mov    %ecx,0x38(%rsp)
            .v_start = MACH2PHYS_COMPAT_VIRT_START(d),
            .v_end   = MACH2PHYS_COMPAT_VIRT_END,
            .max_mfn = MACH2PHYS_COMPAT_NR_ENTRIES(d) - 1
    323e:	c1 e8 02             	shr    $0x2,%eax
    3241:	83 e8 01             	sub    $0x1,%eax
    3244:	89 44 24 40          	mov    %eax,0x40(%rsp)
        };

        if ( copy_to_guest(arg, &mapping, 1) )
    3248:	48 8b 82 e8 7f 00 00 	mov    0x7fe8(%rdx),%rax
    324f:	ba 0c 00 00 00       	mov    $0xc,%edx
    3254:	48 8b 40 10          	mov    0x10(%rax),%rax
    3258:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    325f:	0f 84 9b 02 00 00    	je     3500 <compat_arch_memory_op+0x760>
                return -EFAULT;
            last_mfn = mfn;
        }

        xmml.nr_extents = i;
        if ( __copy_to_guest(arg, &xmml, 1) )
    3265:	e8 00 00 00 00       	callq  326a <compat_arch_memory_op+0x4ca>
    struct compat_machphys_mfn_list xmml;
    l2_pgentry_t l2e;
    unsigned long v;
    compat_pfn_t mfn;
    unsigned int i;
    int rc = 0;
    326a:	48 83 f8 01          	cmp    $0x1,%rax
    326e:	19 db                	sbb    %ebx,%ebx
    3270:	f7 d3                	not    %ebx
    3272:	83 e3 f2             	and    $0xfffffff2,%ebx
    3275:	e9 76 fb ff ff       	jmpq   2df0 <compat_arch_memory_op+0x50>
    327a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3280:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    case XENMEM_set_memory_map:
    {
        struct compat_foreign_memory_map cmp;
        struct xen_foreign_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
    3287:	ba 0c 00 00 00       	mov    $0xc,%edx
    328c:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
    3291:	48 21 e0             	and    %rsp,%rax
    }

    case XENMEM_set_memory_map:
    {
        struct compat_foreign_memory_map cmp;
        struct xen_foreign_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    3294:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    329b:	44 8b 20             	mov    (%rax),%r12d

        if ( copy_from_guest(&cmp, arg, 1) )
    329e:	48 8b 40 10          	mov    0x10(%rax),%rax
    32a2:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    32a9:	0f 84 61 02 00 00    	je     3510 <compat_arch_memory_op+0x770>
    32af:	e8 00 00 00 00       	callq  32b4 <compat_arch_memory_op+0x514>
    32b4:	48 85 c0             	test   %rax,%rax
            return -EFAULT;
    32b7:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
    case XENMEM_set_memory_map:
    {
        struct compat_foreign_memory_map cmp;
        struct xen_foreign_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
    32bc:	0f 85 2e fb ff ff    	jne    2df0 <compat_arch_memory_op+0x50>
    }

    case XENMEM_set_memory_map:
    {
        struct compat_foreign_memory_map cmp;
        struct xen_foreign_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    32c2:	44 89 e6             	mov    %r12d,%esi
    32c5:	48 b8 00 00 00 80 00 	movabs $0xffff820080000000,%rax
    32cc:	82 ff ff 
#define XLAT_memory_map_HNDL_buffer(_d_, _s_) \
        guest_from_compat_handle((_d_)->buffer, (_s_)->buffer)
        XLAT_foreign_memory_map(nat, &cmp);
#undef XLAT_memory_map_HNDL_buffer

        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    32cf:	bf 0d 00 00 00       	mov    $0xd,%edi
    }

    case XENMEM_set_memory_map:
    {
        struct compat_foreign_memory_map cmp;
        struct xen_foreign_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    32d4:	c1 e6 0e             	shl    $0xe,%esi
    32d7:	48 63 f6             	movslq %esi,%rsi
    32da:	48 01 c6             	add    %rax,%rsi
        if ( copy_from_guest(&cmp, arg, 1) )
            return -EFAULT;

#define XLAT_memory_map_HNDL_buffer(_d_, _s_) \
        guest_from_compat_handle((_d_)->buffer, (_s_)->buffer)
        XLAT_foreign_memory_map(nat, &cmp);
    32dd:	0f b7 44 24 38       	movzwl 0x38(%rsp),%eax
    32e2:	66 89 06             	mov    %ax,(%rsi)
    32e5:	8b 44 24 3c          	mov    0x3c(%rsp),%eax
    32e9:	89 46 08             	mov    %eax,0x8(%rsi)
    32ec:	8b 44 24 40          	mov    0x40(%rsp),%eax
    32f0:	48 89 46 10          	mov    %rax,0x10(%rsi)
#undef XLAT_memory_map_HNDL_buffer

        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    32f4:	e8 00 00 00 00       	callq  32f9 <compat_arch_memory_op+0x559>
    32f9:	89 c3                	mov    %eax,%ebx

        break;
    32fb:	e9 f0 fa ff ff       	jmpq   2df0 <compat_arch_memory_op+0x50>
    3300:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    case XENMEM_get_pod_target:
    {
        struct compat_pod_target cmp;
        struct xen_pod_target *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
    3307:	4c 8d 64 24 38       	lea    0x38(%rsp),%r12
    330c:	ba 24 00 00 00       	mov    $0x24,%edx
    3311:	48 21 e0             	and    %rsp,%rax

    case XENMEM_set_pod_target:
    case XENMEM_get_pod_target:
    {
        struct compat_pod_target cmp;
        struct xen_pod_target *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    3314:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax

        if ( copy_from_guest(&cmp, arg, 1) )
    331b:	4c 89 e7             	mov    %r12,%rdi

    case XENMEM_set_pod_target:
    case XENMEM_get_pod_target:
    {
        struct compat_pod_target cmp;
        struct xen_pod_target *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    331e:	44 8b 28             	mov    (%rax),%r13d

        if ( copy_from_guest(&cmp, arg, 1) )
    3321:	48 8b 40 10          	mov    0x10(%rax),%rax
    3325:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    332c:	0f 85 be 01 00 00    	jne    34f0 <compat_arch_memory_op+0x750>
    3332:	e8 00 00 00 00       	callq  3337 <compat_arch_memory_op+0x597>
    3337:	48 85 c0             	test   %rax,%rax
            return -EFAULT;
    333a:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
    case XENMEM_get_pod_target:
    {
        struct compat_pod_target cmp;
        struct xen_pod_target *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
    333f:	0f 85 ab fa ff ff    	jne    2df0 <compat_arch_memory_op+0x50>

    case XENMEM_set_pod_target:
    case XENMEM_get_pod_target:
    {
        struct compat_pod_target cmp;
        struct xen_pod_target *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    3345:	41 c1 e5 0e          	shl    $0xe,%r13d
    3349:	48 b8 00 00 00 80 00 	movabs $0xffff820080000000,%rax
    3350:	82 ff ff 
        if ( copy_from_guest(&cmp, arg, 1) )
            return -EFAULT;

        XLAT_pod_target(nat, &cmp);

        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    3353:	44 89 f7             	mov    %r14d,%edi

    case XENMEM_set_pod_target:
    case XENMEM_get_pod_target:
    {
        struct compat_pod_target cmp;
        struct xen_pod_target *nat = COMPAT_ARG_XLAT_VIRT_BASE;
    3356:	4d 63 ed             	movslq %r13d,%r13
    3359:	49 01 c5             	add    %rax,%r13

        if ( copy_from_guest(&cmp, arg, 1) )
            return -EFAULT;

        XLAT_pod_target(nat, &cmp);
    335c:	48 8b 44 24 38       	mov    0x38(%rsp),%rax

        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    3361:	4c 89 ee             	mov    %r13,%rsi
        struct xen_pod_target *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
            return -EFAULT;

        XLAT_pod_target(nat, &cmp);
    3364:	49 89 45 00          	mov    %rax,0x0(%r13)
    3368:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
    336d:	49 89 45 08          	mov    %rax,0x8(%r13)
    3371:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
    3376:	49 89 45 10          	mov    %rax,0x10(%r13)
    337a:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
    337f:	49 89 45 18          	mov    %rax,0x18(%r13)
    3383:	0f b7 44 24 58       	movzwl 0x58(%rsp),%eax
    3388:	66 41 89 45 20       	mov    %ax,0x20(%r13)

        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    338d:	e8 00 00 00 00       	callq  3392 <compat_arch_memory_op+0x5f2>
        if ( rc < 0 )
    3392:	85 c0                	test   %eax,%eax
        if ( copy_from_guest(&cmp, arg, 1) )
            return -EFAULT;

        XLAT_pod_target(nat, &cmp);

        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
    3394:	89 c3                	mov    %eax,%ebx
        if ( rc < 0 )
    3396:	0f 88 54 fa ff ff    	js     2df0 <compat_arch_memory_op+0x50>
            break;

        if ( rc == __HYPERVISOR_memory_op )
    339c:	83 f8 0c             	cmp    $0xc,%eax
    339f:	0f 84 47 02 00 00    	je     35ec <compat_arch_memory_op+0x84c>
            hypercall_xlat_continuation(NULL, 0x2, nat, arg);

        XLAT_pod_target(&cmp, nat);
    33a5:	49 8b 45 00          	mov    0x0(%r13),%rax

        if ( __copy_to_guest(arg, &cmp, 1) )
    33a9:	ba 24 00 00 00       	mov    $0x24,%edx
    33ae:	4c 89 e6             	mov    %r12,%rsi
    33b1:	48 89 ef             	mov    %rbp,%rdi
            break;

        if ( rc == __HYPERVISOR_memory_op )
            hypercall_xlat_continuation(NULL, 0x2, nat, arg);

        XLAT_pod_target(&cmp, nat);
    33b4:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
    33b9:	49 8b 45 08          	mov    0x8(%r13),%rax
    33bd:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
    33c2:	49 8b 45 10          	mov    0x10(%r13),%rax
    33c6:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
    33cb:	49 8b 45 18          	mov    0x18(%r13),%rax
    33cf:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
    33d4:	41 0f b7 45 20       	movzwl 0x20(%r13),%eax
    33d9:	66 89 44 24 58       	mov    %ax,0x58(%rsp)
    33de:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    33e5:	48 21 e0             	and    %rsp,%rax

        if ( __copy_to_guest(arg, &cmp, 1) )
    33e8:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    33ef:	48 8b 40 10          	mov    0x10(%rax),%rax
    33f3:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    33fa:	0f 84 b0 01 00 00    	je     35b0 <compat_arch_memory_op+0x810>
    3400:	e8 00 00 00 00       	callq  3405 <compat_arch_memory_op+0x665>
    3405:	48 85 c0             	test   %rax,%rax
    3408:	0f 84 e2 f9 ff ff    	je     2df0 <compat_arch_memory_op+0x50>
        {
            if ( rc == __HYPERVISOR_memory_op )
    340e:	83 fb 0c             	cmp    $0xc,%ebx
    3411:	0f 84 fe 01 00 00    	je     3615 <compat_arch_memory_op+0x875>
                mfn = l2e_get_pfn(l2e);
            else
                mfn = last_mfn;
            ASSERT(mfn);
            if ( copy_to_compat_offset(xmml.extent_start, i, &mfn, 1) )
                return -EFAULT;
    3417:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
    341c:	e9 cf f9 ff ff       	jmpq   2df0 <compat_arch_memory_op+0x50>
    3421:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

        break;
    }

    case XENMEM_get_sharing_freed_pages:
        return mem_sharing_get_nr_saved_mfns();
    3428:	e8 00 00 00 00       	callq  342d <compat_arch_memory_op+0x68d>
    342d:	89 c3                	mov    %eax,%ebx
    342f:	e9 bc f9 ff ff       	jmpq   2df0 <compat_arch_memory_op+0x50>
    3434:	0f 1f 40 00          	nopl   0x0(%rax)

    case XENMEM_get_sharing_shared_pages:
        return mem_sharing_get_nr_shared_mfns();
    3438:	e8 00 00 00 00       	callq  343d <compat_arch_memory_op+0x69d>
    343d:	89 c3                	mov    %eax,%ebx
    343f:	90                   	nop
    3440:	e9 ab f9 ff ff       	jmpq   2df0 <compat_arch_memory_op+0x50>
    3445:	0f 1f 00             	nopl   (%rax)
    3448:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax

    case XENMEM_paging_op:
    case XENMEM_access_op:
    {
        xen_mem_event_op_t meo;
        if ( copy_from_guest(&meo, arg, 1) )
    344f:	4c 8d 64 24 38       	lea    0x38(%rsp),%r12
    3454:	ba 18 00 00 00       	mov    $0x18,%edx
    3459:	48 21 e0             	and    %rsp,%rax
    345c:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    3463:	4c 89 e7             	mov    %r12,%rdi
    3466:	48 8b 40 10          	mov    0x10(%rax),%rax
    346a:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    3471:	75 75                	jne    34e8 <compat_arch_memory_op+0x748>
    3473:	e8 00 00 00 00       	callq  3478 <compat_arch_memory_op+0x6d8>
    3478:	48 85 c0             	test   %rax,%rax
            return -EFAULT;
    347b:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx

    case XENMEM_paging_op:
    case XENMEM_access_op:
    {
        xen_mem_event_op_t meo;
        if ( copy_from_guest(&meo, arg, 1) )
    3480:	0f 85 6a f9 ff ff    	jne    2df0 <compat_arch_memory_op+0x50>
            return -EFAULT;
        rc = do_mem_event_op(op, meo.domain, (void *) &meo);
    3486:	0f b7 74 24 3a       	movzwl 0x3a(%rsp),%esi
    348b:	4c 89 e2             	mov    %r12,%rdx
    348e:	44 89 f7             	mov    %r14d,%edi
    3491:	e8 00 00 00 00       	callq  3496 <compat_arch_memory_op+0x6f6>
        if ( !rc && __copy_to_guest(arg, &meo, 1) )
    3496:	85 c0                	test   %eax,%eax
    case XENMEM_access_op:
    {
        xen_mem_event_op_t meo;
        if ( copy_from_guest(&meo, arg, 1) )
            return -EFAULT;
        rc = do_mem_event_op(op, meo.domain, (void *) &meo);
    3498:	89 c3                	mov    %eax,%ebx
        if ( !rc && __copy_to_guest(arg, &meo, 1) )
    349a:	0f 85 50 f9 ff ff    	jne    2df0 <compat_arch_memory_op+0x50>
    34a0:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    34a7:	ba 18 00 00 00       	mov    $0x18,%edx
    34ac:	4c 89 e6             	mov    %r12,%rsi
    34af:	48 21 e0             	and    %rsp,%rax
    34b2:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    34b9:	48 89 ef             	mov    %rbp,%rdi
    34bc:	48 8b 40 10          	mov    0x10(%rax),%rax
    34c0:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    34c7:	0f 84 09 fa ff ff    	je     2ed6 <compat_arch_memory_op+0x136>
        if ( copy_from_guest(&mso, arg, 1) )
            return -EFAULT;
        if ( mso.op == XENMEM_sharing_op_audit )
            return mem_sharing_audit(); 
        rc = do_mem_event_op(op, mso.domain, (void *) &mso);
        if ( !rc && __copy_to_guest(arg, &mso, 1) )
    34cd:	e8 00 00 00 00       	callq  34d2 <compat_arch_memory_op+0x732>
            return -EFAULT;
    34d2:	48 85 c0             	test   %rax,%rax
    34d5:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
    34da:	0f 45 d8             	cmovne %eax,%ebx
    34dd:	e9 0e f9 ff ff       	jmpq   2df0 <compat_arch_memory_op+0x50>
    34e2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

    case XENMEM_paging_op:
    case XENMEM_access_op:
    {
        xen_mem_event_op_t meo;
        if ( copy_from_guest(&meo, arg, 1) )
    34e8:	e8 00 00 00 00       	callq  34ed <compat_arch_memory_op+0x74d>
    34ed:	eb 89                	jmp    3478 <compat_arch_memory_op+0x6d8>
    34ef:	90                   	nop
    case XENMEM_get_pod_target:
    {
        struct compat_pod_target cmp;
        struct xen_pod_target *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
    34f0:	e8 00 00 00 00       	callq  34f5 <compat_arch_memory_op+0x755>
    34f5:	e9 3d fe ff ff       	jmpq   3337 <compat_arch_memory_op+0x597>
    34fa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
            .v_start = MACH2PHYS_COMPAT_VIRT_START(d),
            .v_end   = MACH2PHYS_COMPAT_VIRT_END,
            .max_mfn = MACH2PHYS_COMPAT_NR_ENTRIES(d) - 1
        };

        if ( copy_to_guest(arg, &mapping, 1) )
    3500:	e8 00 00 00 00       	callq  3505 <compat_arch_memory_op+0x765>
    3505:	e9 60 fd ff ff       	jmpq   326a <compat_arch_memory_op+0x4ca>
    350a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    case XENMEM_set_memory_map:
    {
        struct compat_foreign_memory_map cmp;
        struct xen_foreign_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
    3510:	e8 00 00 00 00       	callq  3515 <compat_arch_memory_op+0x775>
    3515:	e9 9a fd ff ff       	jmpq   32b4 <compat_arch_memory_op+0x514>
    351a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    case XENMEM_machine_memory_map:
    {
        struct compat_memory_map cmp;
        struct xen_memory_map *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
    3520:	e8 00 00 00 00       	callq  3525 <compat_arch_memory_op+0x785>
    3525:	49 89 c7             	mov    %rax,%r15
    3528:	e9 4d fc ff ff       	jmpq   317a <compat_arch_memory_op+0x3da>
    352d:	0f 1f 00             	nopl   (%rax)
    case XENMEM_add_to_physmap:
    {
        struct compat_add_to_physmap cmp;
        struct xen_add_to_physmap *nat = COMPAT_ARG_XLAT_VIRT_BASE;

        if ( copy_from_guest(&cmp, arg, 1) )
    3530:	e8 00 00 00 00       	callq  3535 <compat_arch_memory_op+0x795>
    3535:	e9 05 fb ff ff       	jmpq   303f <compat_arch_memory_op+0x29f>
    353a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    case XENMEM_machphys_mfn_list:
    {
        unsigned long limit;
        compat_pfn_t last_mfn;

        if ( copy_from_guest(&xmml, arg, 1) )
    3540:	e8 00 00 00 00       	callq  3545 <compat_arch_memory_op+0x7a5>
    3545:	e9 ca f9 ff ff       	jmpq   2f14 <compat_arch_memory_op+0x174>
    354a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
        break;
    }
    case XENMEM_sharing_op:
    {
        xen_mem_sharing_op_t mso;
        if ( copy_from_guest(&mso, arg, 1) )
    3550:	e8 00 00 00 00       	callq  3555 <compat_arch_memory_op+0x7b5>
    3555:	e9 1a f9 ff ff       	jmpq   2e74 <compat_arch_memory_op+0xd4>
    355a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
            if ( l2e_get_flags(l2e) & _PAGE_PRESENT )
                mfn = l2e_get_pfn(l2e);
            else
                mfn = last_mfn;
            ASSERT(mfn);
            if ( copy_to_compat_offset(xmml.extent_start, i, &mfn, 1) )
    3560:	e8 00 00 00 00       	callq  3565 <compat_arch_memory_op+0x7c5>
    3565:	e9 4c fa ff ff       	jmpq   2fb6 <compat_arch_memory_op+0x216>
            return -EFAULT;

        limit = (unsigned long)(compat_machine_to_phys_mapping + max_page);
        if ( limit > RDWR_COMPAT_MPT_VIRT_END )
            limit = RDWR_COMPAT_MPT_VIRT_END;
        for ( i = 0, v = RDWR_COMPAT_MPT_VIRT_START, last_mfn = 0;
    356a:	31 db                	xor    %ebx,%ebx
    356c:	0f 1f 40 00          	nopl   0x0(%rax)
    3570:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
            if ( copy_to_compat_offset(xmml.extent_start, i, &mfn, 1) )
                return -EFAULT;
            last_mfn = mfn;
        }

        xmml.nr_extents = i;
    3577:	89 5c 24 68          	mov    %ebx,0x68(%rsp)
        if ( __copy_to_guest(arg, &xmml, 1) )
    357b:	ba 0c 00 00 00       	mov    $0xc,%edx
    3580:	48 21 e0             	and    %rsp,%rax
    3583:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
    358a:	4c 89 fe             	mov    %r15,%rsi
    358d:	48 89 ef             	mov    %rbp,%rdi
    3590:	48 8b 40 10          	mov    0x10(%rax),%rax
    3594:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    359b:	0f 85 c4 fc ff ff    	jne    3265 <compat_arch_memory_op+0x4c5>
            return ret;
        }
    }
    return __copy_to_user_ll(to, from, n);
    35a1:	e8 00 00 00 00       	callq  35a6 <compat_arch_memory_op+0x806>
    35a6:	e9 bf fc ff ff       	jmpq   326a <compat_arch_memory_op+0x4ca>
    35ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    35b0:	e8 00 00 00 00       	callq  35b5 <compat_arch_memory_op+0x815>
    35b5:	e9 4b fe ff ff       	jmpq   3405 <compat_arch_memory_op+0x665>
    35ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
            break;

#define XLAT_memory_map_HNDL_buffer(_d_, _s_) ((void)0)
        XLAT_memory_map(&cmp, nat);
#undef XLAT_memory_map_HNDL_buffer
        if ( __copy_to_guest(arg, &cmp, 1) )
    35c0:	ba 08 00 00 00       	mov    $0x8,%edx
    35c5:	4c 89 e6             	mov    %r12,%rsi
    35c8:	48 89 ef             	mov    %rbp,%rdi
    35cb:	e8 00 00 00 00       	callq  35d0 <compat_arch_memory_op+0x830>
    35d0:	49 89 c7             	mov    %rax,%r15
    35d3:	e9 1c fc ff ff       	jmpq   31f4 <compat_arch_memory_op+0x454>
    35d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    35df:	00 
    {
        xen_mem_sharing_op_t mso;
        if ( copy_from_guest(&mso, arg, 1) )
            return -EFAULT;
        if ( mso.op == XENMEM_sharing_op_audit )
            return mem_sharing_audit(); 
    35e0:	e8 00 00 00 00       	callq  35e5 <compat_arch_memory_op+0x845>
    35e5:	89 c3                	mov    %eax,%ebx
    35e7:	e9 04 f8 ff ff       	jmpq   2df0 <compat_arch_memory_op+0x50>
        rc = arch_memory_op(op, guest_handle_from_ptr(nat, void));
        if ( rc < 0 )
            break;

        if ( rc == __HYPERVISOR_memory_op )
            hypercall_xlat_continuation(NULL, 0x2, nat, arg);
    35ec:	48 89 e9             	mov    %rbp,%rcx
    35ef:	4c 89 ea             	mov    %r13,%rdx
    35f2:	be 02 00 00 00       	mov    $0x2,%esi
    35f7:	31 ff                	xor    %edi,%edi
    35f9:	31 c0                	xor    %eax,%eax
    35fb:	e8 00 00 00 00       	callq  3600 <compat_arch_memory_op+0x860>
    3600:	e9 a0 fd ff ff       	jmpq   33a5 <compat_arch_memory_op+0x605>
    3605:	e8 00 00 00 00       	callq  360a <compat_arch_memory_op+0x86a>
    360a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    3610:	e9 f8 fa ff ff       	jmpq   310d <compat_arch_memory_op+0x36d>
        XLAT_pod_target(&cmp, nat);

        if ( __copy_to_guest(arg, &cmp, 1) )
        {
            if ( rc == __HYPERVISOR_memory_op )
                hypercall_cancel_continuation();
    3615:	e8 00 00 00 00       	callq  361a <compat_arch_memory_op+0x87a>
            rc = -EFAULT;
    361a:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
    361f:	90                   	nop
    3620:	e9 cb f7 ff ff       	jmpq   2df0 <compat_arch_memory_op+0x50>
    3625:	66 66 2e 0f 1f 84 00 	data32 nopw %cs:0x0(%rax,%rax,1)
    362c:	00 00 00 00 

0000000000003630 <compat_update_va_mapping>:
    return rc;
}

int compat_update_va_mapping(unsigned int va, u32 lo, u32 hi,
                             unsigned int flags)
{
    3630:	89 f0                	mov    %esi,%eax
    3632:	89 d6                	mov    %edx,%esi
    3634:	48 83 ec 08          	sub    $0x8,%rsp
    return do_update_va_mapping(va, lo | ((u64)hi << 32), flags);
    3638:	48 c1 e6 20          	shl    $0x20,%rsi
    363c:	89 ca                	mov    %ecx,%edx
    363e:	89 ff                	mov    %edi,%edi
    3640:	48 09 c6             	or     %rax,%rsi
    3643:	e8 00 00 00 00       	callq  3648 <compat_update_va_mapping+0x18>
}
    3648:	48 83 c4 08          	add    $0x8,%rsp
    364c:	c3                   	retq   
    364d:	0f 1f 00             	nopl   (%rax)

0000000000003650 <compat_update_va_mapping_otherdomain>:

int compat_update_va_mapping_otherdomain(unsigned long va, u32 lo, u32 hi,
                                         unsigned long flags,
                                         domid_t domid)
{
    3650:	89 f0                	mov    %esi,%eax
    return do_update_va_mapping_otherdomain(va, lo | ((u64)hi << 32), flags, domid);
    3652:	48 89 d6             	mov    %rdx,%rsi
}

int compat_update_va_mapping_otherdomain(unsigned long va, u32 lo, u32 hi,
                                         unsigned long flags,
                                         domid_t domid)
{
    3655:	49 89 c9             	mov    %rcx,%r9
    return do_update_va_mapping_otherdomain(va, lo | ((u64)hi << 32), flags, domid);
    3658:	48 c1 e6 20          	shl    $0x20,%rsi
}

int compat_update_va_mapping_otherdomain(unsigned long va, u32 lo, u32 hi,
                                         unsigned long flags,
                                         domid_t domid)
{
    365c:	48 83 ec 08          	sub    $0x8,%rsp
    return do_update_va_mapping_otherdomain(va, lo | ((u64)hi << 32), flags, domid);
    3660:	41 0f b7 c8          	movzwl %r8w,%ecx
    3664:	48 09 c6             	or     %rax,%rsi
    3667:	4c 89 ca             	mov    %r9,%rdx
    366a:	e8 00 00 00 00       	callq  366f <compat_update_va_mapping_otherdomain+0x1f>
}
    366f:	48 83 c4 08          	add    $0x8,%rsp
    3673:	c3                   	retq   
    3674:	66 66 66 2e 0f 1f 84 	data32 data32 nopw %cs:0x0(%rax,%rax,1)
    367b:	00 00 00 00 00 

0000000000003680 <compat_mmuext_op>:

int compat_mmuext_op(XEN_GUEST_HANDLE_PARAM(mmuext_op_compat_t) cmp_uops,
                     unsigned int count,
                     XEN_GUEST_HANDLE_PARAM(uint) pdone,
                     unsigned int foreigndom)
{
    3680:	41 57                	push   %r15
    3682:	41 56                	push   %r14
    3684:	41 55                	push   %r13
    3686:	41 54                	push   %r12
    3688:	55                   	push   %rbp
    3689:	53                   	push   %rbx
    368a:	48 83 ec 48          	sub    $0x48,%rsp
    unsigned int i, preempt_mask;
    int rc = 0;
    XEN_GUEST_HANDLE_PARAM(mmuext_op_t) nat_ops;

    if ( unlikely(count == MMU_UPDATE_PREEMPTED) &&
    368e:	81 fe 00 00 00 80    	cmp    $0x80000000,%esi

int compat_mmuext_op(XEN_GUEST_HANDLE_PARAM(mmuext_op_compat_t) cmp_uops,
                     unsigned int count,
                     XEN_GUEST_HANDLE_PARAM(uint) pdone,
                     unsigned int foreigndom)
{
    3694:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
    3699:	89 4c 24 24          	mov    %ecx,0x24(%rsp)
    unsigned int i, preempt_mask;
    int rc = 0;
    XEN_GUEST_HANDLE_PARAM(mmuext_op_t) nat_ops;

    if ( unlikely(count == MMU_UPDATE_PREEMPTED) &&
    369d:	0f 84 26 04 00 00    	je     3ac9 <compat_mmuext_op+0x449>
    {
        set_xen_guest_handle(nat_ops, NULL);
        return do_mmuext_op(nat_ops, count, pdone, foreigndom);
    }

    preempt_mask = count & MMU_UPDATE_PREEMPTED;
    36a3:	89 f0                	mov    %esi,%eax
    36a5:	25 00 00 00 80       	and    $0x80000000,%eax
    count ^= preempt_mask;
    36aa:	31 c6                	xor    %eax,%esi
    {
        set_xen_guest_handle(nat_ops, NULL);
        return do_mmuext_op(nat_ops, count, pdone, foreigndom);
    }

    preempt_mask = count & MMU_UPDATE_PREEMPTED;
    36ac:	89 44 24 20          	mov    %eax,0x20(%rsp)
    36b0:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    36b7:	48 21 e0             	and    %rsp,%rax
    count ^= preempt_mask;

    if ( unlikely(!guest_handle_okay(cmp_uops, count)) )
    36ba:	48 8b 80 e8 7f 00 00 	mov    0x7fe8(%rax),%rax
        set_xen_guest_handle(nat_ops, NULL);
        return do_mmuext_op(nat_ops, count, pdone, foreigndom);
    }

    preempt_mask = count & MMU_UPDATE_PREEMPTED;
    count ^= preempt_mask;
    36c1:	89 74 24 04          	mov    %esi,0x4(%rsp)

    if ( unlikely(!guest_handle_okay(cmp_uops, count)) )
    36c5:	48 8b 50 10          	mov    0x10(%rax),%rdx
    36c9:	f6 82 d1 0a 00 00 40 	testb  $0x40,0xad1(%rdx)
    36d0:	0f 84 8f 03 00 00    	je     3a65 <compat_mmuext_op+0x3e5>
    36d6:	49 c7 c6 00 80 ff ff 	mov    $0xffffffffffff8000,%r14
        return -EFAULT;

    set_xen_guest_handle(nat_ops, COMPAT_ARG_XLAT_VIRT_BASE);

    for ( ; count; count -= i )
    36dd:	8b 74 24 04          	mov    0x4(%rsp),%esi
                     unsigned int count,
                     XEN_GUEST_HANDLE_PARAM(uint) pdone,
                     unsigned int foreigndom)
{
    unsigned int i, preempt_mask;
    int rc = 0;
    36e1:	31 db                	xor    %ebx,%ebx
    36e3:	49 21 e6             	and    %rsp,%r14
    count ^= preempt_mask;

    if ( unlikely(!guest_handle_okay(cmp_uops, count)) )
        return -EFAULT;

    set_xen_guest_handle(nat_ops, COMPAT_ARG_XLAT_VIRT_BASE);
    36e6:	49 8b 86 e8 7f 00 00 	mov    0x7fe8(%r14),%rax

    for ( ; count; count -= i )
    36ed:	48 89 fd             	mov    %rdi,%rbp
    count ^= preempt_mask;

    if ( unlikely(!guest_handle_okay(cmp_uops, count)) )
        return -EFAULT;

    set_xen_guest_handle(nat_ops, COMPAT_ARG_XLAT_VIRT_BASE);
    36f0:	8b 00                	mov    (%rax),%eax
    36f2:	c1 e0 0e             	shl    $0xe,%eax
    36f5:	48 98                	cltq   
    36f7:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
    36fc:	48 b8 00 00 00 80 00 	movabs $0xffff820080000000,%rax
    3703:	82 ff ff 
    3706:	48 03 44 24 10       	add    0x10(%rsp),%rax
    370b:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
    return do_update_va_mapping_otherdomain(va, lo | ((u64)hi << 32), flags, domid);
}

DEFINE_XEN_GUEST_HANDLE(mmuext_op_compat_t);

int compat_mmuext_op(XEN_GUEST_HANDLE_PARAM(mmuext_op_compat_t) cmp_uops,
    3710:	48 b8 18 00 00 80 00 	movabs $0xffff820080000018,%rax
    3717:	82 ff ff 
    371a:	48 03 44 24 10       	add    0x10(%rsp),%rax
    if ( unlikely(!guest_handle_okay(cmp_uops, count)) )
        return -EFAULT;

    set_xen_guest_handle(nat_ops, COMPAT_ARG_XLAT_VIRT_BASE);

    for ( ; count; count -= i )
    371f:	85 f6                	test   %esi,%esi
    return do_update_va_mapping_otherdomain(va, lo | ((u64)hi << 32), flags, domid);
}

DEFINE_XEN_GUEST_HANDLE(mmuext_op_compat_t);

int compat_mmuext_op(XEN_GUEST_HANDLE_PARAM(mmuext_op_compat_t) cmp_uops,
    3721:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
    if ( unlikely(!guest_handle_okay(cmp_uops, count)) )
        return -EFAULT;

    set_xen_guest_handle(nat_ops, COMPAT_ARG_XLAT_VIRT_BASE);

    for ( ; count; count -= i )
    3726:	0f 84 6c 01 00 00    	je     3898 <compat_mmuext_op+0x218>
    372c:	0f 1f 40 00          	nopl   0x0(%rax)
    {
        mmuext_op_t *nat_op = nat_ops.p;
        unsigned int limit = COMPAT_ARG_XLAT_SIZE / sizeof(*nat_op);
        int err;

        for ( i = 0; i < min(limit, count); ++i )
    3730:	81 7c 24 04 55 01 00 	cmpl   $0x155,0x4(%rsp)
    3737:	00 
    3738:	b8 55 01 00 00       	mov    $0x155,%eax
    373d:	0f 46 44 24 04       	cmovbe 0x4(%rsp),%eax
    3742:	45 31 e4             	xor    %r12d,%r12d
    3745:	31 db                	xor    %ebx,%ebx
    3747:	85 c0                	test   %eax,%eax
    3749:	0f 84 11 01 00 00    	je     3860 <compat_mmuext_op+0x1e0>
    return do_update_va_mapping_otherdomain(va, lo | ((u64)hi << 32), flags, domid);
}

DEFINE_XEN_GUEST_HANDLE(mmuext_op_compat_t);

int compat_mmuext_op(XEN_GUEST_HANDLE_PARAM(mmuext_op_compat_t) cmp_uops,
    374f:	83 e8 01             	sub    $0x1,%eax
    3752:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
    3757:	49 bd f8 1f 00 80 00 	movabs $0xffff820080001ff8,%r13
    375e:	82 ff ff 
    3761:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
    3765:	4c 03 6c 24 10       	add    0x10(%rsp),%r13
    376a:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
    376f:	4c 8d 3c c2          	lea    (%rdx,%rax,8),%r15
    3773:	e9 85 00 00 00       	jmpq   37fd <compat_mmuext_op+0x17d>
    3778:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    377f:	00 
        {
            mmuext_op_compat_t cmp_op;
            enum XLAT_mmuext_op_arg1 arg1;
            enum XLAT_mmuext_op_arg2 arg2;

            if ( unlikely(__copy_from_guest(&cmp_op, cmp_uops, 1) != 0) )
    3780:	e8 00 00 00 00       	callq  3785 <compat_mmuext_op+0x105>
    3785:	48 85 c0             	test   %rax,%rax
    3788:	0f 85 92 02 00 00    	jne    3a20 <compat_mmuext_op+0x3a0>
            {
                rc = -EFAULT;
                break;
            }

            switch ( cmp_op.cmd )
    378e:	8b 4c 24 30          	mov    0x30(%rsp),%ecx
    3792:	83 f9 11             	cmp    $0x11,%ecx
    3795:	0f 86 95 00 00 00    	jbe    3830 <compat_mmuext_op+0x1b0>
            case MMUEXT_CLEAR_PAGE:
            case MMUEXT_COPY_PAGE:
                arg1 = XLAT_mmuext_op_arg1_mfn;
                break;
            default:
                arg1 = XLAT_mmuext_op_arg1_linear_addr;
    379b:	ba 01 00 00 00       	mov    $0x1,%edx
                break;
    37a0:	8d 71 f8             	lea    -0x8(%rcx),%esi
                rc = -EINVAL;
            case MMUEXT_TLB_FLUSH_LOCAL:
            case MMUEXT_TLB_FLUSH_MULTI:
            case MMUEXT_TLB_FLUSH_ALL:
            case MMUEXT_FLUSH_CACHE:
                arg1 = -1;
    37a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            case MMUEXT_COPY_PAGE:
                arg1 = XLAT_mmuext_op_arg1_mfn;
                break;
            default:
                arg1 = XLAT_mmuext_op_arg1_linear_addr;
                break;
    37a8:	83 fe 09             	cmp    $0x9,%esi
    37ab:	77 0a                	ja     37b7 <compat_mmuext_op+0x137>
    37ad:	48 8d 05 00 00 00 00 	lea    0x0(%rip),%rax        # 37b4 <compat_mmuext_op+0x134>
    37b4:	8b 04 b0             	mov    (%rax,%rsi,4),%eax
                break;
            }

#define XLAT_mmuext_op_HNDL_arg2_vcpumask(_d_, _s_) \
        guest_from_compat_handle((_d_)->arg2.vcpumask, (_s_)->arg2.vcpumask)
            XLAT_mmuext_op(nat_op, &cmp_op);
    37b7:	85 d2                	test   %edx,%edx
    37b9:	89 0b                	mov    %ecx,(%rbx)
    37bb:	0f 85 ef 00 00 00    	jne    38b0 <compat_mmuext_op+0x230>
    37c1:	8b 54 24 34          	mov    0x34(%rsp),%edx
    37c5:	48 89 53 08          	mov    %rdx,0x8(%rbx)
    37c9:	83 f8 01             	cmp    $0x1,%eax
    37cc:	0f 84 f8 00 00 00    	je     38ca <compat_mmuext_op+0x24a>
    37d2:	0f 83 18 01 00 00    	jae    38f0 <compat_mmuext_op+0x270>
    37d8:	8b 44 24 38          	mov    0x38(%rsp),%eax
    37dc:	89 43 10             	mov    %eax,0x10(%rbx)
#undef XLAT_mmuext_op_HNDL_arg2_vcpumask

            if ( rc || i >= limit )
    37df:	4c 39 eb             	cmp    %r13,%rbx
    37e2:	0f 84 f8 00 00 00    	je     38e0 <compat_mmuext_op+0x260>
                break;

            guest_handle_add_offset(cmp_uops, 1);
            ++nat_op;
    37e8:	48 83 c3 18          	add    $0x18,%rbx
#undef XLAT_mmuext_op_HNDL_arg2_vcpumask

            if ( rc || i >= limit )
                break;

            guest_handle_add_offset(cmp_uops, 1);
    37ec:	48 83 c5 0c          	add    $0xc,%rbp
    {
        mmuext_op_t *nat_op = nat_ops.p;
        unsigned int limit = COMPAT_ARG_XLAT_SIZE / sizeof(*nat_op);
        int err;

        for ( i = 0; i < min(limit, count); ++i )
    37f0:	41 83 c4 01          	add    $0x1,%r12d
    37f4:	4c 39 fb             	cmp    %r15,%rbx
    37f7:	0f 84 e3 00 00 00    	je     38e0 <compat_mmuext_op+0x260>
        {
            mmuext_op_compat_t cmp_op;
            enum XLAT_mmuext_op_arg1 arg1;
            enum XLAT_mmuext_op_arg2 arg2;

            if ( unlikely(__copy_from_guest(&cmp_op, cmp_uops, 1) != 0) )
    37fd:	49 8b 86 e8 7f 00 00 	mov    0x7fe8(%r14),%rax
    3804:	ba 0c 00 00 00       	mov    $0xc,%edx
    3809:	48 89 ee             	mov    %rbp,%rsi
    380c:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
    3811:	48 8b 40 10          	mov    0x10(%rax),%rax
    3815:	80 b8 e0 01 00 00 00 	cmpb   $0x0,0x1e0(%rax)
    381c:	0f 85 5e ff ff ff    	jne    3780 <compat_mmuext_op+0x100>
        case 8:
            __get_user_size(*(u64*)to, from, 8, ret, 8);
            return ret;
        }
    }
    return __copy_from_user_ll(to, from, n);
    3822:	e8 00 00 00 00       	callq  3827 <compat_mmuext_op+0x1a7>
    3827:	e9 59 ff ff ff       	jmpq   3785 <compat_mmuext_op+0x105>
    382c:	0f 1f 40 00          	nopl   0x0(%rax)
            {
                rc = -EFAULT;
                break;
            }

            switch ( cmp_op.cmd )
    3830:	b0 01                	mov    $0x1,%al
                rc = -EINVAL;
            case MMUEXT_TLB_FLUSH_LOCAL:
            case MMUEXT_TLB_FLUSH_MULTI:
            case MMUEXT_TLB_FLUSH_ALL:
            case MMUEXT_FLUSH_CACHE:
                arg1 = -1;
    3832:	ba ff ff ff ff       	mov    $0xffffffff,%edx
            {
                rc = -EFAULT;
                break;
            }

            switch ( cmp_op.cmd )
    3837:	48 d3 e0             	shl    %cl,%rax
    383a:	a9 40 15 00 00       	test   $0x1540,%eax
    383f:	0f 85 5b ff ff ff    	jne    37a0 <compat_mmuext_op+0x120>
            case MMUEXT_PIN_L4_TABLE:
            case MMUEXT_UNPIN_TABLE:
            case MMUEXT_NEW_BASEPTR:
            case MMUEXT_CLEAR_PAGE:
            case MMUEXT_COPY_PAGE:
                arg1 = XLAT_mmuext_op_arg1_mfn;
    3845:	31 d2                	xor    %edx,%edx
            {
                rc = -EFAULT;
                break;
            }

            switch ( cmp_op.cmd )
    3847:	a9 3f 00 03 00       	test   $0x3003f,%eax
    384c:	0f 85 4e ff ff ff    	jne    37a0 <compat_mmuext_op+0x120>
    3852:	f6 c4 80             	test   $0x80,%ah
    3855:	0f 84 40 ff ff ff    	je     379b <compat_mmuext_op+0x11b>
                break;
            default:
                arg1 = XLAT_mmuext_op_arg1_linear_addr;
                break;
            case MMUEXT_NEW_USER_BASEPTR:
                rc = -EINVAL;
    385b:	bb ea ff ff ff       	mov    $0xffffffea,%ebx

            guest_handle_add_offset(cmp_uops, 1);
            ++nat_op;
        }

        err = do_mmuext_op(nat_ops, i | preempt_mask, pdone, foreigndom);
    3860:	8b 74 24 20          	mov    0x20(%rsp),%esi
    3864:	8b 4c 24 24          	mov    0x24(%rsp),%ecx
    3868:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
    386d:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
    3872:	44 09 e6             	or     %r12d,%esi
    3875:	e8 00 00 00 00       	callq  387a <compat_mmuext_op+0x1fa>

        if ( err )
    387a:	85 c0                	test   %eax,%eax
    387c:	0f 84 8e 00 00 00    	je     3910 <compat_mmuext_op+0x290>
        {
            BUILD_BUG_ON(__HYPERVISOR_mmuext_op <= 0);
            if ( err == __HYPERVISOR_mmuext_op )
    3882:	83 f8 1a             	cmp    $0x1a,%eax
    3885:	0f 84 a1 00 00 00    	je     392c <compat_mmuext_op+0x2ac>
                else
                    BUG_ON(hypercall_xlat_continuation(&left, 0));
                BUG_ON(left != arg1);
            }
            else
                BUG_ON(err > 0);
    388b:	85 c0                	test   %eax,%eax
    388d:	0f 1f 00             	nopl   (%rax)
    3890:	0f 8f 94 01 00 00    	jg     3a2a <compat_mmuext_op+0x3aa>
    3896:	89 c3                	mov    %eax,%ebx
        /* Force do_mmuext_op() to not start counting from zero again. */
        preempt_mask = MMU_UPDATE_PREEMPTED;
    }

    return rc;
}
    3898:	48 83 c4 48          	add    $0x48,%rsp
    389c:	89 d8                	mov    %ebx,%eax
    389e:	5b                   	pop    %rbx
    389f:	5d                   	pop    %rbp
    38a0:	41 5c                	pop    %r12
    38a2:	41 5d                	pop    %r13
    38a4:	41 5e                	pop    %r14
    38a6:	41 5f                	pop    %r15
    38a8:	c3                   	retq   
    38a9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
                break;
            }

#define XLAT_mmuext_op_HNDL_arg2_vcpumask(_d_, _s_) \
        guest_from_compat_handle((_d_)->arg2.vcpumask, (_s_)->arg2.vcpumask)
            XLAT_mmuext_op(nat_op, &cmp_op);
    38b0:	83 fa 01             	cmp    $0x1,%edx
    38b3:	0f 85 10 ff ff ff    	jne    37c9 <compat_mmuext_op+0x149>
    38b9:	8b 4c 24 34          	mov    0x34(%rsp),%ecx
    38bd:	83 f8 01             	cmp    $0x1,%eax
    38c0:	48 89 4b 08          	mov    %rcx,0x8(%rbx)
    38c4:	0f 85 08 ff ff ff    	jne    37d2 <compat_mmuext_op+0x152>
    38ca:	8b 44 24 38          	mov    0x38(%rsp),%eax
#undef XLAT_mmuext_op_HNDL_arg2_vcpumask

            if ( rc || i >= limit )
    38ce:	4c 39 eb             	cmp    %r13,%rbx
                break;
            }

#define XLAT_mmuext_op_HNDL_arg2_vcpumask(_d_, _s_) \
        guest_from_compat_handle((_d_)->arg2.vcpumask, (_s_)->arg2.vcpumask)
            XLAT_mmuext_op(nat_op, &cmp_op);
    38d1:	48 89 43 10          	mov    %rax,0x10(%rbx)
#undef XLAT_mmuext_op_HNDL_arg2_vcpumask

            if ( rc || i >= limit )
    38d5:	0f 85 0d ff ff ff    	jne    37e8 <compat_mmuext_op+0x168>
    38db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    38e0:	31 db                	xor    %ebx,%ebx
    38e2:	e9 79 ff ff ff       	jmpq   3860 <compat_mmuext_op+0x1e0>
    38e7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    38ee:	00 00 
                break;
            }

#define XLAT_mmuext_op_HNDL_arg2_vcpumask(_d_, _s_) \
        guest_from_compat_handle((_d_)->arg2.vcpumask, (_s_)->arg2.vcpumask)
            XLAT_mmuext_op(nat_op, &cmp_op);
    38f0:	83 f8 02             	cmp    $0x2,%eax
    38f3:	0f 85 e6 fe ff ff    	jne    37df <compat_mmuext_op+0x15f>
    38f9:	8b 54 24 38          	mov    0x38(%rsp),%edx
    38fd:	48 89 53 10          	mov    %rdx,0x10(%rbx)
    3901:	e9 d9 fe ff ff       	jmpq   37df <compat_mmuext_op+0x15f>
    3906:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    390d:	00 00 00 
            else
                BUG_ON(err > 0);
            rc = err;
        }

        if ( rc )
    3910:	85 db                	test   %ebx,%ebx
    3912:	75 84                	jne    3898 <compat_mmuext_op+0x218>
    if ( unlikely(!guest_handle_okay(cmp_uops, count)) )
        return -EFAULT;

    set_xen_guest_handle(nat_ops, COMPAT_ARG_XLAT_VIRT_BASE);

    for ( ; count; count -= i )
    3914:	44 29 64 24 04       	sub    %r12d,0x4(%rsp)
    3919:	0f 84 79 ff ff ff    	je     3898 <compat_mmuext_op+0x218>

        if ( rc )
            break;

        /* Force do_mmuext_op() to not start counting from zero again. */
        preempt_mask = MMU_UPDATE_PREEMPTED;
    391f:	c7 44 24 20 00 00 00 	movl   $0x80000000,0x20(%rsp)
    3926:	80 
    3927:	e9 04 fe ff ff       	jmpq   3730 <compat_mmuext_op+0xb0>
    392c:	48 c7 c0 00 80 ff ff 	mov    $0xffffffffffff8000,%rax
    3933:	48 21 e0             	and    %rsp,%rax
        {
            BUILD_BUG_ON(__HYPERVISOR_mmuext_op <= 0);
            if ( err == __HYPERVISOR_mmuext_op )
            {
                struct cpu_user_regs *regs = guest_cpu_user_regs();
                struct mc_state *mcs = &current->mc_state;
    3936:	48 8b 98 e8 7f 00 00 	mov    0x7fe8(%rax),%rbx
    return (struct cpu_info *)(tos + STACK_SIZE) - 1;
    393d:	4c 8d b0 18 7f 00 00 	lea    0x7f18(%rax),%r14
})

static inline int constant_test_bit(int nr, const volatile void *addr)
{
    return ((1U << (nr & 31)) &
            (((const volatile unsigned int *)addr)[nr >> 5])) != 0;
    3944:	8b 83 a8 01 00 00    	mov    0x1a8(%rbx),%eax
                unsigned int arg1 = !test_bit(_MCSF_in_multicall, &mcs->flags)
    394a:	a8 01                	test   $0x1,%al
    394c:	0f 85 93 00 00 00    	jne    39e5 <compat_mmuext_op+0x365>
    3952:	45 8b 6e 58          	mov    0x58(%r14),%r13d
                                    ? regs->ecx
                                    : mcs->call.args[1];
                unsigned int left = arg1 & ~MMU_UPDATE_PREEMPTED;
    3956:	44 89 e8             	mov    %r13d,%eax
    3959:	25 ff ff ff 7f       	and    $0x7fffffff,%eax

                BUG_ON(left == arg1 && left != i);
    395e:	41 39 c4             	cmp    %eax,%r12d
    3961:	0f 85 e3 00 00 00    	jne    3a4a <compat_mmuext_op+0x3ca>
                BUG_ON(left > count);
    3967:	39 44 24 04          	cmp    %eax,0x4(%rsp)
    396b:	0f 82 ca 00 00 00    	jb     3a3b <compat_mmuext_op+0x3bb>
                guest_handle_add_offset(nat_ops, i - left);
                guest_handle_subtract_offset(cmp_uops, left);
                left = 1;
                if ( arg1 != MMU_UPDATE_PREEMPTED )
    3971:	41 81 fd 00 00 00 80 	cmp    $0x80000000,%r13d

                BUG_ON(left == arg1 && left != i);
                BUG_ON(left > count);
                guest_handle_add_offset(nat_ops, i - left);
                guest_handle_subtract_offset(cmp_uops, left);
                left = 1;
    3978:	c7 44 24 3c 01 00 00 	movl   $0x1,0x3c(%rsp)
    397f:	00 
                if ( arg1 != MMU_UPDATE_PREEMPTED )
    3980:	74 7a                	je     39fc <compat_mmuext_op+0x37c>
                                    : mcs->call.args[1];
                unsigned int left = arg1 & ~MMU_UPDATE_PREEMPTED;

                BUG_ON(left == arg1 && left != i);
                BUG_ON(left > count);
                guest_handle_add_offset(nat_ops, i - left);
    3982:	44 89 e2             	mov    %r12d,%edx
    3985:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
                guest_handle_subtract_offset(cmp_uops, left);
                left = 1;
                if ( arg1 != MMU_UPDATE_PREEMPTED )
                {
                    BUG_ON(!hypercall_xlat_continuation(&left, 0x01, nat_ops,
    398a:	48 8d 7c 24 3c       	lea    0x3c(%rsp),%rdi
                                    : mcs->call.args[1];
                unsigned int left = arg1 & ~MMU_UPDATE_PREEMPTED;

                BUG_ON(left == arg1 && left != i);
                BUG_ON(left > count);
                guest_handle_add_offset(nat_ops, i - left);
    398f:	29 c2                	sub    %eax,%edx
                guest_handle_subtract_offset(cmp_uops, left);
    3991:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
                left = 1;
                if ( arg1 != MMU_UPDATE_PREEMPTED )
                {
                    BUG_ON(!hypercall_xlat_continuation(&left, 0x01, nat_ops,
    3995:	be 01 00 00 00       	mov    $0x1,%esi
                                    : mcs->call.args[1];
                unsigned int left = arg1 & ~MMU_UPDATE_PREEMPTED;

                BUG_ON(left == arg1 && left != i);
                BUG_ON(left > count);
                guest_handle_add_offset(nat_ops, i - left);
    399a:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
                guest_handle_subtract_offset(cmp_uops, left);
    399e:	48 c1 e0 02          	shl    $0x2,%rax
                                    : mcs->call.args[1];
                unsigned int left = arg1 & ~MMU_UPDATE_PREEMPTED;

                BUG_ON(left == arg1 && left != i);
                BUG_ON(left > count);
                guest_handle_add_offset(nat_ops, i - left);
    39a2:	48 8d 14 d1          	lea    (%rcx,%rdx,8),%rdx
                guest_handle_subtract_offset(cmp_uops, left);
    39a6:	48 89 e9             	mov    %rbp,%rcx
    39a9:	48 29 c1             	sub    %rax,%rcx
                left = 1;
                if ( arg1 != MMU_UPDATE_PREEMPTED )
                {
                    BUG_ON(!hypercall_xlat_continuation(&left, 0x01, nat_ops,
    39ac:	31 c0                	xor    %eax,%eax
    39ae:	e8 00 00 00 00       	callq  39b3 <compat_mmuext_op+0x333>
    39b3:	85 c0                	test   %eax,%eax
    39b5:	0f 84 37 01 00 00    	je     3af2 <compat_mmuext_op+0x472>
    39bb:	8b 83 a8 01 00 00    	mov    0x1a8(%rbx),%eax
                                                        cmp_uops));
                    if ( !test_bit(_MCSF_in_multicall, &mcs->flags) )
    39c1:	a8 01                	test   $0x1,%al
                        regs->_ecx += count - i;
    39c3:	8b 44 24 04          	mov    0x4(%rsp),%eax
                left = 1;
                if ( arg1 != MMU_UPDATE_PREEMPTED )
                {
                    BUG_ON(!hypercall_xlat_continuation(&left, 0x01, nat_ops,
                                                        cmp_uops));
                    if ( !test_bit(_MCSF_in_multicall, &mcs->flags) )
    39c7:	75 28                	jne    39f1 <compat_mmuext_op+0x371>
                        regs->_ecx += count - i;
    39c9:	44 29 e0             	sub    %r12d,%eax
    39cc:	41 01 46 58          	add    %eax,0x58(%r14)
                    else
                        mcs->compat_call.args[1] += count - i;
                }
                else
                    BUG_ON(hypercall_xlat_continuation(&left, 0));
                BUG_ON(left != arg1);
    39d0:	44 3b 6c 24 3c       	cmp    0x3c(%rsp),%r13d
    39d5:	0f 85 03 01 00 00    	jne    3ade <compat_mmuext_op+0x45e>
    39db:	bb 1a 00 00 00       	mov    $0x1a,%ebx
    39e0:	e9 b3 fe ff ff       	jmpq   3898 <compat_mmuext_op+0x218>
            BUILD_BUG_ON(__HYPERVISOR_mmuext_op <= 0);
            if ( err == __HYPERVISOR_mmuext_op )
            {
                struct cpu_user_regs *regs = guest_cpu_user_regs();
                struct mc_state *mcs = &current->mc_state;
                unsigned int arg1 = !test_bit(_MCSF_in_multicall, &mcs->flags)
    39e5:	44 8b ab c8 01 00 00 	mov    0x1c8(%rbx),%r13d
    39ec:	e9 65 ff ff ff       	jmpq   3956 <compat_mmuext_op+0x2d6>
                    BUG_ON(!hypercall_xlat_continuation(&left, 0x01, nat_ops,
                                                        cmp_uops));
                    if ( !test_bit(_MCSF_in_multicall, &mcs->flags) )
                        regs->_ecx += count - i;
                    else
                        mcs->compat_call.args[1] += count - i;
    39f1:	44 29 e0             	sub    %r12d,%eax
    39f4:	01 83 bc 01 00 00    	add    %eax,0x1bc(%rbx)
    39fa:	eb d4                	jmp    39d0 <compat_mmuext_op+0x350>
                }
                else
                    BUG_ON(hypercall_xlat_continuation(&left, 0));
    39fc:	48 8d 7c 24 3c       	lea    0x3c(%rsp),%rdi
    3a01:	31 f6                	xor    %esi,%esi
    3a03:	31 c0                	xor    %eax,%eax
    3a05:	e8 00 00 00 00       	callq  3a0a <compat_mmuext_op+0x38a>
    3a0a:	85 c0                	test   %eax,%eax
    3a0c:	74 c2                	je     39d0 <compat_mmuext_op+0x350>
    3a0e:	0f 0b                	ud2    
    3a10:	c2 1a 06             	retq   $0x61a
    3a13:	bc 00 00 00 00       	mov    $0x0,%esp
    3a18:	eb b6                	jmp    39d0 <compat_mmuext_op+0x350>
    3a1a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
            enum XLAT_mmuext_op_arg1 arg1;
            enum XLAT_mmuext_op_arg2 arg2;

            if ( unlikely(__copy_from_guest(&cmp_op, cmp_uops, 1) != 0) )
            {
                rc = -EFAULT;
    3a20:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
    3a25:	e9 36 fe ff ff       	jmpq   3860 <compat_mmuext_op+0x1e0>
                else
                    BUG_ON(hypercall_xlat_continuation(&left, 0));
                BUG_ON(left != arg1);
            }
            else
                BUG_ON(err > 0);
    3a2a:	0f 0b                	ud2    
    3a2c:	c2 2a 06             	retq   $0x62a
    3a2f:	bc 00 00 00 00       	mov    $0x0,%esp
    3a34:	89 c3                	mov    %eax,%ebx
    3a36:	e9 5d fe ff ff       	jmpq   3898 <compat_mmuext_op+0x218>
                                    ? regs->ecx
                                    : mcs->call.args[1];
                unsigned int left = arg1 & ~MMU_UPDATE_PREEMPTED;

                BUG_ON(left == arg1 && left != i);
                BUG_ON(left > count);
    3a3b:	0f 0b                	ud2    
    3a3d:	c2 e2 05             	retq   $0x5e2
    3a40:	bc 00 00 00 00       	mov    $0x0,%esp
    3a45:	e9 27 ff ff ff       	jmpq   3971 <compat_mmuext_op+0x2f1>
                unsigned int arg1 = !test_bit(_MCSF_in_multicall, &mcs->flags)
                                    ? regs->ecx
                                    : mcs->call.args[1];
                unsigned int left = arg1 & ~MMU_UPDATE_PREEMPTED;

                BUG_ON(left == arg1 && left != i);
    3a4a:	41 39 c5             	cmp    %eax,%r13d
    3a4d:	0f 1f 00             	nopl   (%rax)
    3a50:	0f 85 11 ff ff ff    	jne    3967 <compat_mmuext_op+0x2e7>
    3a56:	0f 0b                	ud2    
    3a58:	c2 de 05             	retq   $0x5de
    3a5b:	bc 00 00 00 00       	mov    $0x0,%esp
    3a60:	e9 02 ff ff ff       	jmpq   3967 <compat_mmuext_op+0x2e7>
    }

    preempt_mask = count & MMU_UPDATE_PREEMPTED;
    count ^= preempt_mask;

    if ( unlikely(!guest_handle_okay(cmp_uops, count)) )
    3a65:	48 b9 00 00 00 00 00 	movabs $0xffff800000000000,%rcx
    3a6c:	80 ff ff 
    3a6f:	48 ba ff ff ff ff ff 	movabs $0xffff07ffffffffff,%rdx
    3a76:	07 ff ff 
    3a79:	48 01 f9             	add    %rdi,%rcx
    3a7c:	48 39 d1             	cmp    %rdx,%rcx
    3a7f:	0f 87 51 fc ff ff    	ja     36d6 <compat_mmuext_op+0x56>
    3a85:	8b 00                	mov    (%rax),%eax
    3a87:	48 ba 00 00 00 80 ff 	movabs $0x7dff80000000,%rdx
    3a8e:	7d 00 00 
        return -EFAULT;
    3a91:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
    }

    preempt_mask = count & MMU_UPDATE_PREEMPTED;
    count ^= preempt_mask;

    if ( unlikely(!guest_handle_okay(cmp_uops, count)) )
    3a96:	48 01 fa             	add    %rdi,%rdx
    3a99:	c1 e0 0e             	shl    $0xe,%eax
    3a9c:	48 98                	cltq   
    3a9e:	48 29 c2             	sub    %rax,%rdx
    3aa1:	48 81 fa ff 1f 00 00 	cmp    $0x1fff,%rdx
    3aa8:	0f 87 ea fd ff ff    	ja     3898 <compat_mmuext_op+0x218>
    3aae:	89 f0                	mov    %esi,%eax
    3ab0:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
    3ab4:	48 8d 04 82          	lea    (%rdx,%rax,4),%rax
    3ab8:	48 3d 00 20 00 00    	cmp    $0x2000,%rax
    3abe:	0f 87 d4 fd ff ff    	ja     3898 <compat_mmuext_op+0x218>
    3ac4:	e9 0d fc ff ff       	jmpq   36d6 <compat_mmuext_op+0x56>
{
    unsigned int i, preempt_mask;
    int rc = 0;
    XEN_GUEST_HANDLE_PARAM(mmuext_op_t) nat_ops;

    if ( unlikely(count == MMU_UPDATE_PREEMPTED) &&
    3ac9:	48 85 ff             	test   %rdi,%rdi
    3acc:	0f 85 d1 fb ff ff    	jne    36a3 <compat_mmuext_op+0x23>
         likely(guest_handle_is_null(cmp_uops)) )
    {
        set_xen_guest_handle(nat_ops, NULL);
        return do_mmuext_op(nat_ops, count, pdone, foreigndom);
    3ad2:	e8 00 00 00 00       	callq  3ad7 <compat_mmuext_op+0x457>
    3ad7:	89 c3                	mov    %eax,%ebx
    3ad9:	e9 ba fd ff ff       	jmpq   3898 <compat_mmuext_op+0x218>
                    else
                        mcs->compat_call.args[1] += count - i;
                }
                else
                    BUG_ON(hypercall_xlat_continuation(&left, 0));
                BUG_ON(left != arg1);
    3ade:	0f 0b                	ud2    
    3ae0:	c2 1e 06             	retq   $0x61e
    3ae3:	bc 00 00 00 00       	mov    $0x0,%esp
    3ae8:	bb 1a 00 00 00       	mov    $0x1a,%ebx
    3aed:	e9 a6 fd ff ff       	jmpq   3898 <compat_mmuext_op+0x218>
                guest_handle_add_offset(nat_ops, i - left);
                guest_handle_subtract_offset(cmp_uops, left);
                left = 1;
                if ( arg1 != MMU_UPDATE_PREEMPTED )
                {
                    BUG_ON(!hypercall_xlat_continuation(&left, 0x01, nat_ops,
    3af2:	0f 0b                	ud2    
    3af4:	c2 fe 05             	retq   $0x5fe
    3af7:	bc 00 00 00 00       	mov    $0x0,%esp
    3afc:	0f 1f 40 00          	nopl   0x0(%rax)
    3b00:	e9 b6 fe ff ff       	jmpq   39bb <compat_mmuext_op+0x33b>

Disassembly of section .init.text:

0000000000000000 <pfn_pdx_hole_setup>:
 ret:
    return map_domain_page(mfn) + (addr & ~PAGE_MASK);
}

void __init pfn_pdx_hole_setup(unsigned long mask)
{
   0:	55                   	push   %rbp
     * We skip the first MAX_ORDER bits, as we never want to compress them.
     * This guarantees that page-pointer arithmetic remains valid within
     * contiguous aligned ranges of 2^MAX_ORDER pages. Among others, our
     * buddy allocator relies on this assumption.
     */
    for ( j = MAX_ORDER-1; ; )
   1:	ba 11 00 00 00       	mov    $0x11,%edx
    return map_domain_page(mfn) + (addr & ~PAGE_MASK);
}

void __init pfn_pdx_hole_setup(unsigned long mask)
{
    unsigned int i, j, bottom_shift = 0, hole_shift = 0;
   6:	31 ed                	xor    %ebp,%ebp
extern unsigned int __find_next_zero_bit(
    const unsigned long *addr, unsigned int size, unsigned int offset);

static inline unsigned int __scanbit(unsigned long val, unsigned long max)
{
    asm ( "bsf %1,%0 ; cmovz %2,%0" : "=&r" (val) : "r" (val), "r" (max) );
   8:	b8 40 00 00 00       	mov    $0x40,%eax
 ret:
    return map_domain_page(mfn) + (addr & ~PAGE_MASK);
}

void __init pfn_pdx_hole_setup(unsigned long mask)
{
   d:	53                   	push   %rbx
    unsigned int i, j, bottom_shift = 0, hole_shift = 0;
   e:	31 db                	xor    %ebx,%ebx
 ret:
    return map_domain_page(mfn) + (addr & ~PAGE_MASK);
}

void __init pfn_pdx_hole_setup(unsigned long mask)
{
  10:	48 83 ec 08          	sub    $0x8,%rsp
  14:	0f 1f 40 00          	nopl   0x0(%rax)
     * contiguous aligned ranges of 2^MAX_ORDER pages. Among others, our
     * buddy allocator relies on this assumption.
     */
    for ( j = MAX_ORDER-1; ; )
    {
        i = find_next_zero_bit(&mask, BITS_PER_LONG, j);
  18:	89 d1                	mov    %edx,%ecx
  1a:	48 89 fe             	mov    %rdi,%rsi
  1d:	48 d3 ee             	shr    %cl,%rsi
  20:	48 f7 d6             	not    %rsi
  23:	48 0f bc ce          	bsf    %rsi,%rcx
  27:	48 0f 44 c8          	cmove  %rax,%rcx
  2b:	01 d1                	add    %edx,%ecx
        j = find_next_bit(&mask, BITS_PER_LONG, i);
  2d:	48 89 fa             	mov    %rdi,%rdx
  30:	48 d3 ea             	shr    %cl,%rdx
  33:	4c 0f bc c2          	bsf    %rdx,%r8
  37:	4c 0f 44 c0          	cmove  %rax,%r8
    return (unsigned int)val;
  3b:	44 89 c6             	mov    %r8d,%esi
  3e:	8d 14 31             	lea    (%rcx,%rsi,1),%edx
        if ( j >= BITS_PER_LONG )
  41:	83 fa 3f             	cmp    $0x3f,%edx
  44:	77 12                	ja     58 <pfn_pdx_hole_setup+0x58>
            break;
        if ( j - i > hole_shift )
  46:	44 39 c3             	cmp    %r8d,%ebx
  49:	73 cd                	jae    18 <pfn_pdx_hole_setup+0x18>
  4b:	44 89 c3             	mov    %r8d,%ebx
        {
            hole_shift = j - i;
            bottom_shift = i;
  4e:	89 cd                	mov    %ecx,%ebp
  50:	eb c6                	jmp    18 <pfn_pdx_hole_setup+0x18>
  52:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
        }
    }
    if ( !hole_shift )
  58:	85 db                	test   %ebx,%ebx
  5a:	74 75                	je     d1 <pfn_pdx_hole_setup+0xd1>
        return;

    printk(KERN_INFO "PFN compression on bits %u...%u\n",
  5c:	8d 54 1d ff          	lea    -0x1(%rbp,%rbx,1),%edx
  60:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 67 <pfn_pdx_hole_setup+0x67>
  67:	89 ee                	mov    %ebp,%esi
  69:	31 c0                	xor    %eax,%eax
  6b:	e8 00 00 00 00       	callq  70 <pfn_pdx_hole_setup+0x70>
           bottom_shift, bottom_shift + hole_shift - 1);

    pfn_pdx_hole_shift  = hole_shift;
    pfn_pdx_bottom_mask = (1UL << bottom_shift) - 1;
  70:	be 01 00 00 00       	mov    $0x1,%esi
  75:	89 e9                	mov    %ebp,%ecx
    ma_va_bottom_mask   = (PAGE_SIZE << bottom_shift) - 1;
  77:	b8 00 10 00 00       	mov    $0x1000,%eax

    printk(KERN_INFO "PFN compression on bits %u...%u\n",
           bottom_shift, bottom_shift + hole_shift - 1);

    pfn_pdx_hole_shift  = hole_shift;
    pfn_pdx_bottom_mask = (1UL << bottom_shift) - 1;
  7c:	48 89 f2             	mov    %rsi,%rdx
    ma_va_bottom_mask   = (PAGE_SIZE << bottom_shift) - 1;
  7f:	48 d3 e0             	shl    %cl,%rax
        return;

    printk(KERN_INFO "PFN compression on bits %u...%u\n",
           bottom_shift, bottom_shift + hole_shift - 1);

    pfn_pdx_hole_shift  = hole_shift;
  82:	89 1d 00 00 00 00    	mov    %ebx,0x0(%rip)        # 88 <pfn_pdx_hole_setup+0x88>
    pfn_pdx_bottom_mask = (1UL << bottom_shift) - 1;
  88:	48 d3 e2             	shl    %cl,%rdx
    ma_va_bottom_mask   = (PAGE_SIZE << bottom_shift) - 1;
    pfn_hole_mask       = ((1UL << hole_shift) - 1) << bottom_shift;
  8b:	89 d9                	mov    %ebx,%ecx
    printk(KERN_INFO "PFN compression on bits %u...%u\n",
           bottom_shift, bottom_shift + hole_shift - 1);

    pfn_pdx_hole_shift  = hole_shift;
    pfn_pdx_bottom_mask = (1UL << bottom_shift) - 1;
    ma_va_bottom_mask   = (PAGE_SIZE << bottom_shift) - 1;
  8d:	48 83 e8 01          	sub    $0x1,%rax
    pfn_hole_mask       = ((1UL << hole_shift) - 1) << bottom_shift;
  91:	48 d3 e6             	shl    %cl,%rsi
  94:	89 e9                	mov    %ebp,%ecx

    printk(KERN_INFO "PFN compression on bits %u...%u\n",
           bottom_shift, bottom_shift + hole_shift - 1);

    pfn_pdx_hole_shift  = hole_shift;
    pfn_pdx_bottom_mask = (1UL << bottom_shift) - 1;
  96:	48 83 ea 01          	sub    $0x1,%rdx
    ma_va_bottom_mask   = (PAGE_SIZE << bottom_shift) - 1;
    pfn_hole_mask       = ((1UL << hole_shift) - 1) << bottom_shift;
  9a:	48 89 f3             	mov    %rsi,%rbx

    printk(KERN_INFO "PFN compression on bits %u...%u\n",
           bottom_shift, bottom_shift + hole_shift - 1);

    pfn_pdx_hole_shift  = hole_shift;
    pfn_pdx_bottom_mask = (1UL << bottom_shift) - 1;
  9d:	48 89 15 00 00 00 00 	mov    %rdx,0x0(%rip)        # a4 <pfn_pdx_hole_setup+0xa4>
    ma_va_bottom_mask   = (PAGE_SIZE << bottom_shift) - 1;
  a4:	48 89 05 00 00 00 00 	mov    %rax,0x0(%rip)        # ab <pfn_pdx_hole_setup+0xab>
    pfn_hole_mask       = ((1UL << hole_shift) - 1) << bottom_shift;
  ab:	48 83 eb 01          	sub    $0x1,%rbx
  af:	48 d3 e3             	shl    %cl,%rbx
  b2:	48 89 1d 00 00 00 00 	mov    %rbx,0x0(%rip)        # b9 <pfn_pdx_hole_setup+0xb9>
    pfn_top_mask        = ~(pfn_pdx_bottom_mask | pfn_hole_mask);
  b9:	48 09 d3             	or     %rdx,%rbx
  bc:	48 f7 d3             	not    %rbx
  bf:	48 89 1d 00 00 00 00 	mov    %rbx,0x0(%rip)        # c6 <pfn_pdx_hole_setup+0xc6>
    ma_top_mask         = pfn_top_mask << PAGE_SHIFT;
  c6:	48 c1 e3 0c          	shl    $0xc,%rbx
  ca:	48 89 1d 00 00 00 00 	mov    %rbx,0x0(%rip)        # d1 <pfn_pdx_hole_setup+0xd1>
}
  d1:	48 83 c4 08          	add    $0x8,%rsp
  d5:	5b                   	pop    %rbx
  d6:	5d                   	pop    %rbp
  d7:	c3                   	retq   
  d8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  df:	00 

00000000000000e0 <paging_init>:
error:
    return ret;
}

void __init paging_init(void)
{
  e0:	41 57                	push   %r15
  e2:	41 56                	push   %r14
  e4:	41 55                	push   %r13
  e6:	41 54                	push   %r12
  e8:	55                   	push   %rbp
  e9:	53                   	push   %rbx
  ea:	48 83 ec 58          	sub    $0x58,%rsp

    /*
     * We setup the L3s for 1:1 mapping if host support memory hotplug
     * to avoid sync the 1:1 mapping on page fault handler
     */
    if ( mem_hotplug )
  ee:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # f5 <paging_init+0x15>
  f5:	0f 84 c5 00 00 00    	je     1c0 <paging_init+0xe0>
  fb:	4c 8d 25 00 00 00 00 	lea    0x0(%rip),%r12        # 102 <paging_init+0x22>
 102:	48 bd 00 00 00 00 00 	movabs $0xffff830000000000,%rbp
 109:	83 ff ff 
     * power of two (otherwise there would be a right shift followed by a
     * left shift, which the compiler can't know it can fold into one).
     */
    return (void *)(DIRECTMAP_VIRT_START +
                    ((unsigned long)pg - FRAMETABLE_VIRT_START) /
                    (sizeof(*pg) / (sizeof(*pg) & -sizeof(*pg))) *
 10c:	49 bf 00 00 00 00 20 	movabs $0x7d2000000000,%r15
 113:	7d 00 00 
    {
        unsigned long va;

        for ( va = DIRECTMAP_VIRT_START;
              va < DIRECTMAP_VIRT_END;
              va += (1UL << L4_PAGETABLE_SHIFT) )
 116:	49 bd 00 00 00 00 80 	movabs $0x8000000000,%r13
 11d:	00 00 00 
        {
            if ( !(l4e_get_flags(idle_pg_table[l4_table_offset(va)]) &
 120:	4d 89 e6             	mov    %r12,%r14
 123:	eb 19                	jmp    13e <paging_init+0x5e>
 125:	0f 1f 00             	nopl   (%rax)
    {
        unsigned long va;

        for ( va = DIRECTMAP_VIRT_START;
              va < DIRECTMAP_VIRT_END;
              va += (1UL << L4_PAGETABLE_SHIFT) )
 128:	4c 01 ed             	add    %r13,%rbp
     */
    if ( mem_hotplug )
    {
        unsigned long va;

        for ( va = DIRECTMAP_VIRT_START;
 12b:	48 b8 00 00 00 00 80 	movabs $0xffffff8000000000,%rax
 132:	ff ff ff 
 135:	48 39 c5             	cmp    %rax,%rbp
 138:	0f 84 82 00 00 00    	je     1c0 <paging_init+0xe0>
              va < DIRECTMAP_VIRT_END;
              va += (1UL << L4_PAGETABLE_SHIFT) )
        {
            if ( !(l4e_get_flags(idle_pg_table[l4_table_offset(va)]) &
 13e:	48 89 eb             	mov    %rbp,%rbx
 141:	48 c1 eb 27          	shr    $0x27,%rbx
 145:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
 14b:	41 f6 04 dc 01       	testb  $0x1,(%r12,%rbx,8)
 150:	75 d6                	jne    128 <paging_init+0x48>
                  _PAGE_PRESENT) )
            {
                l3_pg = alloc_domheap_page(NULL, 0);
 152:	31 d2                	xor    %edx,%edx
 154:	31 f6                	xor    %esi,%esi
 156:	31 ff                	xor    %edi,%edi
 158:	e8 00 00 00 00       	callq  15d <paging_init+0x7d>
                if ( !l3_pg )
 15d:	48 85 c0             	test   %rax,%rax
 160:	74 6e                	je     1d0 <paging_init+0xf0>
 162:	4c 01 f8             	add    %r15,%rax
     * (sizeof(*pg) & -sizeof(*pg)) selects the LS bit of sizeof(*pg). The
     * division and re-multiplication avoids one shift when sizeof(*pg) is a
     * power of two (otherwise there would be a right shift followed by a
     * left shift, which the compiler can't know it can fold into one).
     */
    return (void *)(DIRECTMAP_VIRT_START +
 165:	48 ba 00 00 00 00 00 	movabs $0xffff830000000000,%rdx
 16c:	83 ff ff 
                    ((unsigned long)pg - FRAMETABLE_VIRT_START) /
                    (sizeof(*pg) / (sizeof(*pg) & -sizeof(*pg))) *
 16f:	48 89 c7             	mov    %rax,%rdi
                    goto nomem;
                l3_ro_mpt = page_to_virt(l3_pg);
                clear_page(l3_ro_mpt);
 172:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
 177:	48 c1 e7 07          	shl    $0x7,%rdi
     * (sizeof(*pg) & -sizeof(*pg)) selects the LS bit of sizeof(*pg). The
     * division and re-multiplication avoids one shift when sizeof(*pg) is a
     * power of two (otherwise there would be a right shift followed by a
     * left shift, which the compiler can't know it can fold into one).
     */
    return (void *)(DIRECTMAP_VIRT_START +
 17b:	48 01 d7             	add    %rdx,%rdi
 17e:	e8 00 00 00 00       	callq  183 <paging_init+0xa3>
                l4e_write(&idle_pg_table[l4_table_offset(va)],
 183:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 188:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 18e <paging_init+0xae>
 18e:	48 c1 f8 05          	sar    $0x5,%rax
 192:	48 89 c2             	mov    %rax,%rdx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 195:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 19c <paging_init+0xbc>
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 19c:	48 d3 e2             	shl    %cl,%rdx
 19f:	48 89 d1             	mov    %rdx,%rcx
 1a2:	48 23 0d 00 00 00 00 	and    0x0(%rip),%rcx        # 1a9 <paging_init+0xc9>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 1a9:	48 09 c1             	or     %rax,%rcx
 1ac:	49 8d 04 de          	lea    (%r14,%rbx,8),%rax
 1b0:	48 c1 e1 0c          	shl    $0xc,%rcx
 1b4:	48 83 c9 63          	or     $0x63,%rcx
 1b8:	48 89 08             	mov    %rcx,(%rax)
 1bb:	e9 68 ff ff ff       	jmpq   128 <paging_init+0x48>
            }
        }
    }

    /* Create user-accessible L2 directory to map the MPT for guests. */
    if ( (l3_pg = alloc_domheap_page(NULL, 0)) == NULL )
 1c0:	31 d2                	xor    %edx,%edx
 1c2:	31 f6                	xor    %esi,%esi
 1c4:	31 ff                	xor    %edi,%edi
 1c6:	e8 00 00 00 00       	callq  1cb <paging_init+0xeb>
 1cb:	48 85 c0             	test   %rax,%rax
 1ce:	75 1c                	jne    1ec <paging_init+0x10c>
              l4e_from_paddr(__pa(idle_pg_table), __PAGE_HYPERVISOR));
    return;

 nomem:
    panic("Not enough memory for m2p table\n");    
}
 1d0:	48 83 c4 58          	add    $0x58,%rsp
    l4e_write(&idle_pg_table[l4_table_offset(LINEAR_PT_VIRT_START)],
              l4e_from_paddr(__pa(idle_pg_table), __PAGE_HYPERVISOR));
    return;

 nomem:
    panic("Not enough memory for m2p table\n");    
 1d4:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 1db <paging_init+0xfb>
 1db:	31 c0                	xor    %eax,%eax
}
 1dd:	5b                   	pop    %rbx
 1de:	5d                   	pop    %rbp
 1df:	41 5c                	pop    %r12
 1e1:	41 5d                	pop    %r13
 1e3:	41 5e                	pop    %r14
 1e5:	41 5f                	pop    %r15
    l4e_write(&idle_pg_table[l4_table_offset(LINEAR_PT_VIRT_START)],
              l4e_from_paddr(__pa(idle_pg_table), __PAGE_HYPERVISOR));
    return;

 nomem:
    panic("Not enough memory for m2p table\n");    
 1e7:	e9 00 00 00 00       	jmpq   1ec <paging_init+0x10c>
                    ((unsigned long)pg - FRAMETABLE_VIRT_START) /
                    (sizeof(*pg) / (sizeof(*pg) & -sizeof(*pg))) *
 1ec:	49 be 00 00 00 00 20 	movabs $0x7d2000000000,%r14
 1f3:	7d 00 00 
     * (sizeof(*pg) & -sizeof(*pg)) selects the LS bit of sizeof(*pg). The
     * division and re-multiplication avoids one shift when sizeof(*pg) is a
     * power of two (otherwise there would be a right shift followed by a
     * left shift, which the compiler can't know it can fold into one).
     */
    return (void *)(DIRECTMAP_VIRT_START +
 1f6:	49 bc 00 00 00 00 00 	movabs $0xffff830000000000,%r12
 1fd:	83 ff ff 
                    ((unsigned long)pg - FRAMETABLE_VIRT_START) /
                    (sizeof(*pg) / (sizeof(*pg) & -sizeof(*pg))) *
 200:	4a 8d 1c 30          	lea    (%rax,%r14,1),%rbx
 204:	48 89 d8             	mov    %rbx,%rax
 207:	48 c1 e0 07          	shl    $0x7,%rax
     * (sizeof(*pg) & -sizeof(*pg)) selects the LS bit of sizeof(*pg). The
     * division and re-multiplication avoids one shift when sizeof(*pg) is a
     * power of two (otherwise there would be a right shift followed by a
     * left shift, which the compiler can't know it can fold into one).
     */
    return (void *)(DIRECTMAP_VIRT_START +
 20b:	4c 01 e0             	add    %r12,%rax

    /* Create user-accessible L2 directory to map the MPT for guests. */
    if ( (l3_pg = alloc_domheap_page(NULL, 0)) == NULL )
        goto nomem;
    l3_ro_mpt = page_to_virt(l3_pg);
    clear_page(l3_ro_mpt);
 20e:	48 89 c7             	mov    %rax,%rdi
 211:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
 216:	e8 00 00 00 00       	callq  21b <paging_init+0x13b>
    l4e_write(&idle_pg_table[l4_table_offset(RO_MPT_VIRT_START)],
 21b:	48 89 d8             	mov    %rbx,%rax
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 21e:	8b 1d 00 00 00 00    	mov    0x0(%rip),%ebx        # 224 <paging_init+0x144>
 224:	48 c1 f8 05          	sar    $0x5,%rax
 228:	48 89 c2             	mov    %rax,%rdx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 22b:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 232 <paging_init+0x152>
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 232:	89 d9                	mov    %ebx,%ecx
 234:	48 d3 e2             	shl    %cl,%rdx
 237:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 23e <paging_init+0x15e>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 23e:	48 09 c2             	or     %rax,%rdx
 241:	48 c1 e2 0c          	shl    $0xc,%rdx
 245:	48 83 ca 67          	or     $0x67,%rdx
 249:	48 89 15 00 00 00 00 	mov    %rdx,0x0(%rip)        # 250 <paging_init+0x170>

    /*
     * Allocate and map the machine-to-phys table.
     * This also ensures L3 is present for fixmaps.
     */
    mpt_size  = (max_page * BYTES_PER_LONG) + (1UL << L2_PAGETABLE_SHIFT) - 1;
 250:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 257 <paging_init+0x177>
 257:	48 8d 04 c5 ff ff 1f 	lea    0x1fffff(,%rax,8),%rax
 25e:	00 
    mpt_size &= ~((1UL << L2_PAGETABLE_SHIFT) - 1UL);
 25f:	48 25 00 00 e0 ff    	and    $0xffffffffffe00000,%rax
 265:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
#define MFN(x) (((x) << L2_PAGETABLE_SHIFT) / sizeof(unsigned long))
#define CNT ((sizeof(*frame_table) & -sizeof(*frame_table)) / \
             sizeof(*machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++ )
 26a:	48 c1 e8 15          	shr    $0x15,%rax
 26e:	48 85 c0             	test   %rax,%rax
 271:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
 276:	0f 84 a2 03 00 00    	je     61e <paging_init+0x53e>
        memflags = MEMF_node(phys_to_nid(i <<
            (L2_PAGETABLE_SHIFT - 3 + PAGE_SHIFT)));

        if ( cpu_has_page1gb &&
             !((unsigned long)l2_ro_mpt & ~PAGE_MASK) &&
             (mpt_size >> L3_PAGETABLE_SHIFT) > (i >> PAGETABLE_ORDER) )
 27c:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
#define MFN(x) (((x) << L2_PAGETABLE_SHIFT) / sizeof(unsigned long))
#define CNT ((sizeof(*frame_table) & -sizeof(*frame_table)) / \
             sizeof(*machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++ )
 281:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 288 <paging_init+0x1a8>
 288:	89 d9                	mov    %ebx,%ecx
 28a:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 291 <paging_init+0x1b1>
 291:	8b 35 00 00 00 00    	mov    0x0(%rip),%esi        # 297 <paging_init+0x1b7>
void __init paging_init(void)
{
    unsigned long i, mpt_size, va;
    unsigned int n, memflags;
    l3_pgentry_t *l3_ro_mpt;
    l2_pgentry_t *l2_ro_mpt = NULL;
 297:	31 ed                	xor    %ebp,%ebp
#define MFN(x) (((x) << L2_PAGETABLE_SHIFT) / sizeof(unsigned long))
#define CNT ((sizeof(*frame_table) & -sizeof(*frame_table)) / \
             sizeof(*machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++ )
 299:	31 db                	xor    %ebx,%ebx
        memflags = MEMF_node(phys_to_nid(i <<
            (L2_PAGETABLE_SHIFT - 3 + PAGE_SHIFT)));

        if ( cpu_has_page1gb &&
             !((unsigned long)l2_ro_mpt & ~PAGE_MASK) &&
             (mpt_size >> L3_PAGETABLE_SHIFT) > (i >> PAGETABLE_ORDER) )
 29b:	48 c1 ea 1e          	shr    $0x1e,%rdx
 29f:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
 2a4:	0f 1f 40 00          	nopl   0x0(%rax)
                 sizeof(*machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++ )
    {
        BUILD_BUG_ON(RO_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        va = RO_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT);
        memflags = MEMF_node(phys_to_nid(i <<
 2a8:	48 89 da             	mov    %rbx,%rdx
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++ )
    {
        BUILD_BUG_ON(RO_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        va = RO_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT);
 2ab:	49 89 dc             	mov    %rbx,%r12
 2ae:	49 bf 00 00 00 00 00 	movabs $0xffff800000000000,%r15
 2b5:	80 ff ff 
        memflags = MEMF_node(phys_to_nid(i <<
 2b8:	48 c1 e2 1e          	shl    $0x1e,%rdx
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++ )
    {
        BUILD_BUG_ON(RO_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
        va = RO_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT);
 2bc:	49 c1 e4 15          	shl    $0x15,%r12

static inline __attribute__((pure)) int phys_to_nid(paddr_t addr) 
{ 
	unsigned nid;
	VIRTUAL_BUG_ON((paddr_to_pdx(addr) >> memnode_shift) >= memnodemapsize);
	nid = memnodemap[paddr_to_pdx(addr) >> memnode_shift]; 
 2c0:	48 c1 ea 0c          	shr    $0xc,%rdx
 2c4:	4d 01 e7             	add    %r12,%r15
extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
 2c7:	48 21 d0             	and    %rdx,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
 2ca:	48 21 fa             	and    %rdi,%rdx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
 2cd:	48 d3 e8             	shr    %cl,%rax
 2d0:	89 f1                	mov    %esi,%ecx

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
 2d2:	48 09 d0             	or     %rdx,%rax
 2d5:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 2dc <paging_init+0x1fc>
 2dc:	48 d3 e8             	shr    %cl,%rax
 2df:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
        memflags = MEMF_node(phys_to_nid(i <<
 2e3:	83 c0 01             	add    $0x1,%eax
 2e6:	c1 e0 08             	shl    $0x8,%eax
 2e9:	25 ff ff 00 00       	and    $0xffff,%eax
 2ee:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
})

static inline int constant_test_bit(int nr, const volatile void *addr)
{
    return ((1U << (nr & 31)) &
            (((const volatile unsigned int *)addr)[nr >> 5])) != 0;
 2f2:	8b 05 00 00 00 00    	mov    0x0(%rip),%eax        # 2f8 <paging_init+0x218>
            (L2_PAGETABLE_SHIFT - 3 + PAGE_SHIFT)));

        if ( cpu_has_page1gb &&
 2f8:	a9 00 00 00 04       	test   $0x4000000,%eax
 2fd:	0f 84 ad 00 00 00    	je     3b0 <paging_init+0x2d0>
 303:	f7 c5 ff 0f 00 00    	test   $0xfff,%ebp
 309:	0f 85 a1 00 00 00    	jne    3b0 <paging_init+0x2d0>
             !((unsigned long)l2_ro_mpt & ~PAGE_MASK) &&
             (mpt_size >> L3_PAGETABLE_SHIFT) > (i >> PAGETABLE_ORDER) )
 30f:	48 89 d8             	mov    %rbx,%rax
        va = RO_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT);
        memflags = MEMF_node(phys_to_nid(i <<
            (L2_PAGETABLE_SHIFT - 3 + PAGE_SHIFT)));

        if ( cpu_has_page1gb &&
             !((unsigned long)l2_ro_mpt & ~PAGE_MASK) &&
 312:	31 c9                	xor    %ecx,%ecx
 314:	31 d2                	xor    %edx,%edx
             (mpt_size >> L3_PAGETABLE_SHIFT) > (i >> PAGETABLE_ORDER) )
 316:	48 c1 e8 09          	shr    $0x9,%rax
        va = RO_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT);
        memflags = MEMF_node(phys_to_nid(i <<
            (L2_PAGETABLE_SHIFT - 3 + PAGE_SHIFT)));

        if ( cpu_has_page1gb &&
             !((unsigned long)l2_ro_mpt & ~PAGE_MASK) &&
 31a:	48 39 44 24 38       	cmp    %rax,0x38(%rsp)
 31f:	0f 86 8b 00 00 00    	jbe    3b0 <paging_init+0x2d0>
 325:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
 32a:	4c 89 64 24 40       	mov    %r12,0x40(%rsp)
 32f:	48 89 cd             	mov    %rcx,%rbp
 332:	4c 89 7c 24 48       	mov    %r15,0x48(%rsp)
 337:	41 89 d4             	mov    %edx,%r12d
 33a:	49 89 df             	mov    %rbx,%r15
 33d:	0f 1f 00             	nopl   (%rax)
             (mpt_size >> L3_PAGETABLE_SHIFT) > (i >> PAGETABLE_ORDER) )
        {
            unsigned int k, holes;

            for ( holes = k = 0; k < 1 << PAGETABLE_ORDER; ++k)
 340:	4a 8d 5c 3d 00       	lea    0x0(%rbp,%r15,1),%rbx
#define MFN(x) (((x) << L2_PAGETABLE_SHIFT) / sizeof(unsigned long))
#define CNT ((sizeof(*frame_table) & -sizeof(*frame_table)) / \
             sizeof(*machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++ )
 345:	45 31 ed             	xor    %r13d,%r13d
             !((unsigned long)l2_ro_mpt & ~PAGE_MASK) &&
             (mpt_size >> L3_PAGETABLE_SHIFT) > (i >> PAGETABLE_ORDER) )
        {
            unsigned int k, holes;

            for ( holes = k = 0; k < 1 << PAGETABLE_ORDER; ++k)
 348:	48 c1 e3 15          	shl    $0x15,%rbx
 34c:	48 c1 eb 03          	shr    $0x3,%rbx
            {
                for ( n = 0; n < CNT; ++n)
                    if ( mfn_valid(MFN(i + k) + n * PDX_GROUP_COUNT) )
 350:	49 8d 7c 1d 00       	lea    0x0(%r13,%rbx,1),%rdi
 355:	e8 00 00 00 00       	callq  35a <paging_init+0x27a>
 35a:	85 c0                	test   %eax,%eax
 35c:	75 14                	jne    372 <paging_init+0x292>
 35e:	49 81 c5 00 00 01 00 	add    $0x10000,%r13
        {
            unsigned int k, holes;

            for ( holes = k = 0; k < 1 << PAGETABLE_ORDER; ++k)
            {
                for ( n = 0; n < CNT; ++n)
 365:	49 81 fd 00 00 04 00 	cmp    $0x40000,%r13
 36c:	75 e2                	jne    350 <paging_init+0x270>
                    if ( mfn_valid(MFN(i + k) + n * PDX_GROUP_COUNT) )
                        break;
                if ( n == CNT )
                    ++holes;
 36e:	41 83 c4 01          	add    $0x1,%r12d
        {
            unsigned int k, holes;

            for ( holes = k = 0; k < 1 << PAGETABLE_ORDER; ++k)
            {
                for ( n = 0; n < CNT; ++n)
 372:	48 83 c5 01          	add    $0x1,%rbp
             !((unsigned long)l2_ro_mpt & ~PAGE_MASK) &&
             (mpt_size >> L3_PAGETABLE_SHIFT) > (i >> PAGETABLE_ORDER) )
        {
            unsigned int k, holes;

            for ( holes = k = 0; k < 1 << PAGETABLE_ORDER; ++k)
 376:	48 81 fd 00 02 00 00 	cmp    $0x200,%rbp
 37d:	75 c1                	jne    340 <paging_init+0x260>
 37f:	44 89 e2             	mov    %r12d,%edx
 382:	4c 89 fb             	mov    %r15,%rbx
 385:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
                    if ( mfn_valid(MFN(i + k) + n * PDX_GROUP_COUNT) )
                        break;
                if ( n == CNT )
                    ++holes;
            }
            if ( k == holes )
 38a:	81 fa 00 02 00 00    	cmp    $0x200,%edx
 390:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
 395:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
 39a:	0f 84 62 02 00 00    	je     602 <paging_init+0x522>
            {
                i += (1UL << PAGETABLE_ORDER) - 1;
                continue;
            }
            if ( holes == 0 &&
 3a0:	85 d2                	test   %edx,%edx
 3a2:	0f 84 ad 01 00 00    	je     555 <paging_init+0x475>
 3a8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 3af:	00 
        va = RO_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT);
        memflags = MEMF_node(phys_to_nid(i <<
            (L2_PAGETABLE_SHIFT - 3 + PAGE_SHIFT)));

        if ( cpu_has_page1gb &&
             !((unsigned long)l2_ro_mpt & ~PAGE_MASK) &&
 3b0:	4c 89 e0             	mov    %r12,%rax
 3b3:	48 89 5c 24 10       	mov    %rbx,0x10(%rsp)
 3b8:	45 31 ed             	xor    %r13d,%r13d
 3bb:	48 c1 e8 03          	shr    $0x3,%rax
 3bf:	4c 89 e3             	mov    %r12,%rbx
 3c2:	49 89 c4             	mov    %rax,%r12
                continue;
            }
        }

        for ( n = 0; n < CNT; ++n)
            if ( mfn_valid(MFN(i) + n * PDX_GROUP_COUNT) )
 3c5:	4b 8d 7c 25 00       	lea    0x0(%r13,%r12,1),%rdi
 3ca:	e8 00 00 00 00       	callq  3cf <paging_init+0x2ef>
 3cf:	85 c0                	test   %eax,%eax
 3d1:	0f 85 ff 00 00 00    	jne    4d6 <paging_init+0x3f6>
 3d7:	49 81 c5 00 00 01 00 	add    $0x10000,%r13
                i += (1UL << PAGETABLE_ORDER) - 1;
                continue;
            }
        }

        for ( n = 0; n < CNT; ++n)
 3de:	49 81 fd 00 00 04 00 	cmp    $0x40000,%r13
 3e5:	75 de                	jne    3c5 <paging_init+0x2e5>
 3e7:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
            if ( mfn_valid(MFN(i) + n * PDX_GROUP_COUNT) )
                break;
        if ( n == CNT )
            l1_pg = NULL;
 3ec:	45 31 ed             	xor    %r13d,%r13d
                PAGE_HYPERVISOR);
            /* Fill with INVALID_M2P_ENTRY. */
            memset((void *)(RDWR_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT)),
                   0xFF, 1UL << L2_PAGETABLE_SHIFT);
        }
        if ( !((unsigned long)l2_ro_mpt & ~PAGE_MASK) )
 3ef:	f7 c5 ff 0f 00 00    	test   $0xfff,%ebp
 3f5:	74 65                	je     45c <paging_init+0x37c>
            l3e_write(&l3_ro_mpt[l3_table_offset(va)],
                      l3e_from_page(l2_pg, __PAGE_HYPERVISOR | _PAGE_USER));
            ASSERT(!l2_table_offset(va));
        }
        /* NB. Cannot be GLOBAL as shadow_mode_translate reuses this area. */
        if ( l1_pg )
 3f7:	4d 85 ed             	test   %r13,%r13
 3fa:	74 2e                	je     42a <paging_init+0x34a>
            l2e_write(l2_ro_mpt, l2e_from_page(
 3fc:	4d 01 f5             	add    %r14,%r13
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 3ff:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 405 <paging_init+0x325>
 405:	49 c1 fd 05          	sar    $0x5,%r13
 409:	4c 89 e8             	mov    %r13,%rax
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 40c:	4c 23 2d 00 00 00 00 	and    0x0(%rip),%r13        # 413 <paging_init+0x333>
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 413:	48 d3 e0             	shl    %cl,%rax
 416:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 41d <paging_init+0x33d>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 41d:	4c 09 e8             	or     %r13,%rax
 420:	48 c1 e0 0c          	shl    $0xc,%rax
 424:	0c 85                	or     $0x85,%al
 426:	48 89 45 00          	mov    %rax,0x0(%rbp)
                l1_pg, /*_PAGE_GLOBAL|*/_PAGE_PSE|_PAGE_USER|_PAGE_PRESENT));
        l2_ro_mpt++;
 42a:	48 83 c5 08          	add    $0x8,%rbp
#define MFN(x) (((x) << L2_PAGETABLE_SHIFT) / sizeof(unsigned long))
#define CNT ((sizeof(*frame_table) & -sizeof(*frame_table)) / \
             sizeof(*machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++ )
 42e:	48 83 c3 01          	add    $0x1,%rbx
 432:	48 39 5c 24 20       	cmp    %rbx,0x20(%rsp)
 437:	0f 86 db 01 00 00    	jbe    618 <paging_init+0x538>
 43d:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 444 <paging_init+0x364>
 444:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 44b <paging_init+0x36b>
 44b:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 451 <paging_init+0x371>
 451:	8b 35 00 00 00 00    	mov    0x0(%rip),%esi        # 457 <paging_init+0x377>
 457:	e9 4c fe ff ff       	jmpq   2a8 <paging_init+0x1c8>
            memset((void *)(RDWR_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT)),
                   0xFF, 1UL << L2_PAGETABLE_SHIFT);
        }
        if ( !((unsigned long)l2_ro_mpt & ~PAGE_MASK) )
        {
            if ( (l2_pg = alloc_domheap_page(NULL, memflags)) == NULL )
 45c:	8b 54 24 1c          	mov    0x1c(%rsp),%edx
 460:	31 f6                	xor    %esi,%esi
 462:	31 ff                	xor    %edi,%edi
 464:	e8 00 00 00 00       	callq  469 <paging_init+0x389>
 469:	48 85 c0             	test   %rax,%rax
 46c:	0f 84 5e fd ff ff    	je     1d0 <paging_init+0xf0>
                    ((unsigned long)pg - FRAMETABLE_VIRT_START) /
                    (sizeof(*pg) / (sizeof(*pg) & -sizeof(*pg))) *
 472:	4e 8d 24 30          	lea    (%rax,%r14,1),%r12
     * (sizeof(*pg) & -sizeof(*pg)) selects the LS bit of sizeof(*pg). The
     * division and re-multiplication avoids one shift when sizeof(*pg) is a
     * power of two (otherwise there would be a right shift followed by a
     * left shift, which the compiler can't know it can fold into one).
     */
    return (void *)(DIRECTMAP_VIRT_START +
 476:	48 b8 00 00 00 00 00 	movabs $0xffff830000000000,%rax
 47d:	83 ff ff 
                goto nomem;
            l2_ro_mpt = page_to_virt(l2_pg);
            clear_page(l2_ro_mpt);
            l3e_write(&l3_ro_mpt[l3_table_offset(va)],
 480:	49 c1 ef 1b          	shr    $0x1b,%r15
 484:	41 81 e7 f8 0f 00 00 	and    $0xff8,%r15d
                    ((unsigned long)pg - FRAMETABLE_VIRT_START) /
                    (sizeof(*pg) / (sizeof(*pg) & -sizeof(*pg))) *
 48b:	4c 89 e5             	mov    %r12,%rbp
 48e:	48 c1 e5 07          	shl    $0x7,%rbp
     * (sizeof(*pg) & -sizeof(*pg)) selects the LS bit of sizeof(*pg). The
     * division and re-multiplication avoids one shift when sizeof(*pg) is a
     * power of two (otherwise there would be a right shift followed by a
     * left shift, which the compiler can't know it can fold into one).
     */
    return (void *)(DIRECTMAP_VIRT_START +
 492:	48 01 c5             	add    %rax,%rbp
        if ( !((unsigned long)l2_ro_mpt & ~PAGE_MASK) )
        {
            if ( (l2_pg = alloc_domheap_page(NULL, memflags)) == NULL )
                goto nomem;
            l2_ro_mpt = page_to_virt(l2_pg);
            clear_page(l2_ro_mpt);
 495:	48 89 ef             	mov    %rbp,%rdi
 498:	e8 00 00 00 00       	callq  49d <paging_init+0x3bd>
            l3e_write(&l3_ro_mpt[l3_table_offset(va)],
 49d:	4c 89 e0             	mov    %r12,%rax
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 4a0:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 4a6 <paging_init+0x3c6>
 4a6:	4c 03 7c 24 28       	add    0x28(%rsp),%r15
 4ab:	48 c1 f8 05          	sar    $0x5,%rax
 4af:	48 89 c2             	mov    %rax,%rdx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 4b2:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 4b9 <paging_init+0x3d9>
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 4b9:	48 d3 e2             	shl    %cl,%rdx
 4bc:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 4c3 <paging_init+0x3e3>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 4c3:	48 09 c2             	or     %rax,%rdx
 4c6:	48 c1 e2 0c          	shl    $0xc,%rdx
 4ca:	48 83 ca 67          	or     $0x67,%rdx
 4ce:	49 89 17             	mov    %rdx,(%r15)
 4d1:	e9 21 ff ff ff       	jmpq   3f7 <paging_init+0x317>
        for ( n = 0; n < CNT; ++n)
            if ( mfn_valid(MFN(i) + n * PDX_GROUP_COUNT) )
                break;
        if ( n == CNT )
            l1_pg = NULL;
        else if ( (l1_pg = alloc_domheap_pages(NULL, PAGETABLE_ORDER,
 4d6:	8b 54 24 1c          	mov    0x1c(%rsp),%edx
 4da:	31 ff                	xor    %edi,%edi
 4dc:	be 09 00 00 00       	mov    $0x9,%esi
 4e1:	49 89 dc             	mov    %rbx,%r12
 4e4:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
 4e9:	e8 00 00 00 00       	callq  4ee <paging_init+0x40e>
 4ee:	48 85 c0             	test   %rax,%rax
 4f1:	49 89 c5             	mov    %rax,%r13
 4f4:	0f 84 d6 fc ff ff    	je     1d0 <paging_init+0xf0>
            goto nomem;
        else
        {
            map_pages_to_xen(
                RDWR_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT),
                page_to_mfn(l1_pg),
 4fa:	4a 8d 04 30          	lea    (%rax,%r14,1),%rax
        else if ( (l1_pg = alloc_domheap_pages(NULL, PAGETABLE_ORDER,
                                               memflags)) == NULL )
            goto nomem;
        else
        {
            map_pages_to_xen(
 4fe:	48 b9 00 00 00 00 80 	movabs $0xffff828000000000,%rcx
 505:	82 ff ff 
 508:	ba 00 02 00 00       	mov    $0x200,%edx
 50d:	49 01 cc             	add    %rcx,%r12
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 510:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 516 <paging_init+0x436>
                RDWR_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT),
                page_to_mfn(l1_pg),
 516:	48 c1 f8 05          	sar    $0x5,%rax
        else if ( (l1_pg = alloc_domheap_pages(NULL, PAGETABLE_ORDER,
                                               memflags)) == NULL )
            goto nomem;
        else
        {
            map_pages_to_xen(
 51a:	4c 89 e7             	mov    %r12,%rdi
 51d:	48 89 c6             	mov    %rax,%rsi
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 520:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 527 <paging_init+0x447>
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 527:	48 d3 e6             	shl    %cl,%rsi
 52a:	48 23 35 00 00 00 00 	and    0x0(%rip),%rsi        # 531 <paging_init+0x451>
 531:	b9 63 01 00 00       	mov    $0x163,%ecx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 536:	48 09 c6             	or     %rax,%rsi
 539:	e8 00 00 00 00       	callq  53e <paging_init+0x45e>
                RDWR_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT),
                page_to_mfn(l1_pg),
                1UL << PAGETABLE_ORDER,
                PAGE_HYPERVISOR);
            /* Fill with INVALID_M2P_ENTRY. */
            memset((void *)(RDWR_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT)),
 53e:	ba 00 00 20 00       	mov    $0x200000,%edx
 543:	be ff 00 00 00       	mov    $0xff,%esi
 548:	4c 89 e7             	mov    %r12,%rdi
 54b:	e8 00 00 00 00       	callq  550 <paging_init+0x470>
 550:	e9 9a fe ff ff       	jmpq   3ef <paging_init+0x30f>
            if ( k == holes )
            {
                i += (1UL << PAGETABLE_ORDER) - 1;
                continue;
            }
            if ( holes == 0 &&
 555:	8b 54 24 1c          	mov    0x1c(%rsp),%edx
 559:	31 ff                	xor    %edi,%edi
 55b:	be 12 00 00 00       	mov    $0x12,%esi
 560:	e8 00 00 00 00       	callq  565 <paging_init+0x485>
 565:	48 85 c0             	test   %rax,%rax
 568:	0f 84 42 fe ff ff    	je     3b0 <paging_init+0x2d0>
                 (l1_pg = alloc_domheap_pages(NULL, 2 * PAGETABLE_ORDER,
                                              memflags)) != NULL )
            {
                map_pages_to_xen(
                    RDWR_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT),
                    page_to_mfn(l1_pg),
 56e:	4e 8d 2c 30          	lea    (%rax,%r14,1),%r13
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 572:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 578 <paging_init+0x498>
            }
            if ( holes == 0 &&
                 (l1_pg = alloc_domheap_pages(NULL, 2 * PAGETABLE_ORDER,
                                              memflags)) != NULL )
            {
                map_pages_to_xen(
 578:	48 b8 00 00 00 00 80 	movabs $0xffff828000000000,%rax
 57f:	82 ff ff 
 582:	49 01 c4             	add    %rax,%r12
 585:	ba 00 00 04 00       	mov    $0x40000,%edx
                memset((void *)(RDWR_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT)),
                       0x77, 1UL << L3_PAGETABLE_SHIFT);

                ASSERT(!l2_table_offset(va));
                /* NB. Cannot be GLOBAL as shadow_mode_translate reuses this area. */
                l3e_write(&l3_ro_mpt[l3_table_offset(va)],
 58a:	49 c1 ef 1b          	shr    $0x1b,%r15
                 (l1_pg = alloc_domheap_pages(NULL, 2 * PAGETABLE_ORDER,
                                              memflags)) != NULL )
            {
                map_pages_to_xen(
                    RDWR_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT),
                    page_to_mfn(l1_pg),
 58e:	49 c1 fd 05          	sar    $0x5,%r13
            }
            if ( holes == 0 &&
                 (l1_pg = alloc_domheap_pages(NULL, 2 * PAGETABLE_ORDER,
                                              memflags)) != NULL )
            {
                map_pages_to_xen(
 592:	4c 89 e7             	mov    %r12,%rdi
                memset((void *)(RDWR_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT)),
                       0x77, 1UL << L3_PAGETABLE_SHIFT);

                ASSERT(!l2_table_offset(va));
                /* NB. Cannot be GLOBAL as shadow_mode_translate reuses this area. */
                l3e_write(&l3_ro_mpt[l3_table_offset(va)],
 595:	41 81 e7 f8 0f 00 00 	and    $0xff8,%r15d
 59c:	4c 89 ee             	mov    %r13,%rsi
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 59f:	4c 89 e8             	mov    %r13,%rax
 5a2:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 5a9 <paging_init+0x4c9>
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 5a9:	48 d3 e6             	shl    %cl,%rsi
 5ac:	48 23 35 00 00 00 00 	and    0x0(%rip),%rsi        # 5b3 <paging_init+0x4d3>
            }
            if ( holes == 0 &&
                 (l1_pg = alloc_domheap_pages(NULL, 2 * PAGETABLE_ORDER,
                                              memflags)) != NULL )
            {
                map_pages_to_xen(
 5b3:	b9 63 01 00 00       	mov    $0x163,%ecx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 5b8:	48 09 c6             	or     %rax,%rsi
 5bb:	e8 00 00 00 00       	callq  5c0 <paging_init+0x4e0>
                    RDWR_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT),
                    page_to_mfn(l1_pg),
                    1UL << (2 * PAGETABLE_ORDER),
                    PAGE_HYPERVISOR);
                memset((void *)(RDWR_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT)),
 5c0:	ba 00 00 00 40       	mov    $0x40000000,%edx
 5c5:	be 77 00 00 00       	mov    $0x77,%esi
 5ca:	4c 89 e7             	mov    %r12,%rdi
 5cd:	e8 00 00 00 00       	callq  5d2 <paging_init+0x4f2>
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 5d2:	8b 05 00 00 00 00    	mov    0x0(%rip),%eax        # 5d8 <paging_init+0x4f8>
 5d8:	4c 89 ea             	mov    %r13,%rdx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 5db:	4c 23 2d 00 00 00 00 	and    0x0(%rip),%r13        # 5e2 <paging_init+0x502>
                       0x77, 1UL << L3_PAGETABLE_SHIFT);

                ASSERT(!l2_table_offset(va));
                /* NB. Cannot be GLOBAL as shadow_mode_translate reuses this area. */
                l3e_write(&l3_ro_mpt[l3_table_offset(va)],
 5e2:	4c 03 7c 24 28       	add    0x28(%rsp),%r15
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 5e7:	89 c1                	mov    %eax,%ecx
 5e9:	48 d3 e2             	shl    %cl,%rdx
 5ec:	48 89 d0             	mov    %rdx,%rax
 5ef:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 5f6 <paging_init+0x516>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 5f6:	4c 09 e8             	or     %r13,%rax
 5f9:	48 c1 e0 0c          	shl    $0xc,%rax
 5fd:	0c 85                	or     $0x85,%al
 5ff:	49 89 07             	mov    %rax,(%r15)
                    l3e_from_page(l1_pg,
                        /*_PAGE_GLOBAL|*/_PAGE_PSE|_PAGE_USER|_PAGE_PRESENT));
                i += (1UL << PAGETABLE_ORDER) - 1;
 602:	48 81 c3 ff 01 00 00 	add    $0x1ff,%rbx
#define MFN(x) (((x) << L2_PAGETABLE_SHIFT) / sizeof(unsigned long))
#define CNT ((sizeof(*frame_table) & -sizeof(*frame_table)) / \
             sizeof(*machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++ )
 609:	48 83 c3 01          	add    $0x1,%rbx
 60d:	48 39 5c 24 20       	cmp    %rbx,0x20(%rsp)
 612:	0f 87 25 fe ff ff    	ja     43d <paging_init+0x35d>
 618:	8b 1d 00 00 00 00    	mov    0x0(%rip),%ebx        # 61e <paging_init+0x53e>
#undef MFN

    /* Create user-accessible L2 directory to map the MPT for compat guests. */
    BUILD_BUG_ON(l4_table_offset(RDWR_MPT_VIRT_START) !=
                 l4_table_offset(HIRO_COMPAT_MPT_VIRT_START));
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(
 61e:	4c 8b 35 00 00 00 00 	mov    0x0(%rip),%r14        # 625 <paging_init+0x545>

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
 625:	4c 8b 25 00 00 00 00 	mov    0x0(%rip),%r12        # 62c <paging_init+0x54c>
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
 62c:	4c 8b 2d 00 00 00 00 	mov    0x0(%rip),%r13        # 633 <paging_init+0x553>
        HIRO_COMPAT_MPT_VIRT_START)]);
    if ( (l2_ro_mpt = alloc_xen_pagetable()) == NULL )
 633:	e8 00 00 00 00       	callq  638 <paging_init+0x558>
 638:	48 85 c0             	test   %rax,%rax
 63b:	48 89 c5             	mov    %rax,%rbp
 63e:	0f 84 8c fb ff ff    	je     1d0 <paging_init+0xf0>
        goto nomem;
    compat_idle_pg_table_l2 = l2_ro_mpt;
    clear_page(l2_ro_mpt);
 644:	48 89 c7             	mov    %rax,%rdi
                 l4_table_offset(HIRO_COMPAT_MPT_VIRT_START));
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(
        HIRO_COMPAT_MPT_VIRT_START)]);
    if ( (l2_ro_mpt = alloc_xen_pagetable()) == NULL )
        goto nomem;
    compat_idle_pg_table_l2 = l2_ro_mpt;
 647:	48 89 05 00 00 00 00 	mov    %rax,0x0(%rip)        # 64e <paging_init+0x56e>
    clear_page(l2_ro_mpt);
 64e:	e8 00 00 00 00       	callq  653 <paging_init+0x573>

static inline unsigned long __virt_to_maddr(unsigned long va)
{
    ASSERT(va >= XEN_VIRT_START);
    ASSERT(va < DIRECTMAP_VIRT_END);
    if ( va >= DIRECTMAP_VIRT_START )
 653:	48 b8 ff ff ff ff ff 	movabs $0xffff82ffffffffff,%rax
 65a:	82 ff ff 
        va -= DIRECTMAP_VIRT_START;
 65d:	48 ba 00 00 00 00 00 	movabs $0x7d0000000000,%rdx
 664:	7d 00 00 
 667:	48 01 ea             	add    %rbp,%rdx

static inline unsigned long __virt_to_maddr(unsigned long va)
{
    ASSERT(va >= XEN_VIRT_START);
    ASSERT(va < DIRECTMAP_VIRT_END);
    if ( va >= DIRECTMAP_VIRT_START )
 66a:	48 39 c5             	cmp    %rax,%rbp
 66d:	77 14                	ja     683 <paging_init+0x5a3>
        va -= DIRECTMAP_VIRT_START;
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
 66f:	48 ba 00 00 00 40 3b 	movabs $0x7d3b40000000,%rdx
 676:	7d 00 00 
 679:	48 03 15 00 00 00 00 	add    0x0(%rip),%rdx        # 680 <paging_init+0x5a0>
 680:	48 01 ea             	add    %rbp,%rdx
    }
    return (va & ma_va_bottom_mask) |
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
 683:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 689 <paging_init+0x5a9>
#undef MFN

    /* Create user-accessible L2 directory to map the MPT for compat guests. */
    BUILD_BUG_ON(l4_table_offset(RDWR_MPT_VIRT_START) !=
                 l4_table_offset(HIRO_COMPAT_MPT_VIRT_START));
    l3_ro_mpt = l4e_to_l3e(idle_pg_table[l4_table_offset(
 689:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
 690:	ff 0f 00 
 693:	49 21 c6             	and    %rax,%r14
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
 696:	48 89 d0             	mov    %rdx,%rax
 699:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 6a0 <paging_init+0x5c0>
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
 6a0:	4d 21 f5             	and    %r14,%r13

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
 6a3:	4d 21 f4             	and    %r14,%r12
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
 6a6:	48 d3 e2             	shl    %cl,%rdx
 6a9:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 6b0 <paging_init+0x5d0>
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
 6b0:	89 d9                	mov    %ebx,%ecx
 6b2:	49 d3 ed             	shr    %cl,%r13
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
 6b5:	48 83 c8 63          	or     $0x63,%rax

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
 6b9:	4d 09 e5             	or     %r12,%r13
 6bc:	48 09 d0             	or     %rdx,%rax
}

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
 6bf:	48 ba 00 00 00 00 00 	movabs $0xffff830000000000,%rdx
 6c6:	83 ff ff 
 6c9:	49 01 d5             	add    %rdx,%r13
 6cc:	49 89 85 90 08 00 00 	mov    %rax,0x890(%r13)
    clear_page(l2_ro_mpt);
    l3e_write(&l3_ro_mpt[l3_table_offset(HIRO_COMPAT_MPT_VIRT_START)],
              l3e_from_paddr(__pa(l2_ro_mpt), __PAGE_HYPERVISOR));
    l2_ro_mpt += l2_table_offset(HIRO_COMPAT_MPT_VIRT_START);
    /* Allocate and map the compatibility mode machine-to-phys table. */
    mpt_size = (mpt_size >> 1) + (1UL << (L2_PAGETABLE_SHIFT - 1));
 6d3:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
    if ( mpt_size > RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START )
        mpt_size = RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START;
    mpt_size &= ~((1UL << L2_PAGETABLE_SHIFT) - 1UL);
    if ( (m2p_compat_vstart + mpt_size) < MACH2PHYS_COMPAT_VIRT_END )
 6d8:	8b 15 00 00 00 00    	mov    0x0(%rip),%edx        # 6de <paging_init+0x5fe>
    clear_page(l2_ro_mpt);
    l3e_write(&l3_ro_mpt[l3_table_offset(HIRO_COMPAT_MPT_VIRT_START)],
              l3e_from_paddr(__pa(l2_ro_mpt), __PAGE_HYPERVISOR));
    l2_ro_mpt += l2_table_offset(HIRO_COMPAT_MPT_VIRT_START);
    /* Allocate and map the compatibility mode machine-to-phys table. */
    mpt_size = (mpt_size >> 1) + (1UL << (L2_PAGETABLE_SHIFT - 1));
 6de:	41 bd 00 00 00 40    	mov    $0x40000000,%r13d
 6e4:	48 d1 e8             	shr    %rax
 6e7:	48 05 00 00 10 00    	add    $0x100000,%rax
 6ed:	48 3d 00 00 00 40    	cmp    $0x40000000,%rax
 6f3:	4c 0f 46 e8          	cmovbe %rax,%r13
    if ( mpt_size > RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START )
        mpt_size = RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START;
    mpt_size &= ~((1UL << L2_PAGETABLE_SHIFT) - 1UL);
    if ( (m2p_compat_vstart + mpt_size) < MACH2PHYS_COMPAT_VIRT_END )
 6f7:	b8 ff ff df ff       	mov    $0xffdfffff,%eax
    l2_ro_mpt += l2_table_offset(HIRO_COMPAT_MPT_VIRT_START);
    /* Allocate and map the compatibility mode machine-to-phys table. */
    mpt_size = (mpt_size >> 1) + (1UL << (L2_PAGETABLE_SHIFT - 1));
    if ( mpt_size > RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START )
        mpt_size = RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START;
    mpt_size &= ~((1UL << L2_PAGETABLE_SHIFT) - 1UL);
 6fc:	49 81 e5 00 00 e0 ff 	and    $0xffffffffffe00000,%r13
    if ( (m2p_compat_vstart + mpt_size) < MACH2PHYS_COMPAT_VIRT_END )
 703:	4c 01 ea             	add    %r13,%rdx
 706:	48 39 c2             	cmp    %rax,%rdx
 709:	0f 86 db 01 00 00    	jbe    8ea <paging_init+0x80a>
#define MFN(x) (((x) << L2_PAGETABLE_SHIFT) / sizeof(unsigned int))
#define CNT ((sizeof(*frame_table) & -sizeof(*frame_table)) / \
             sizeof(*compat_machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*compat_machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++, l2_ro_mpt++ )
 70f:	49 c1 ed 15          	shr    $0x15,%r13
 713:	4d 85 ed             	test   %r13,%r13
 716:	0f 84 6d 01 00 00    	je     889 <paging_init+0x7a9>
 71c:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 723 <paging_init+0x643>
 723:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 72a <paging_init+0x64a>
 72a:	31 db                	xor    %ebx,%ebx
 72c:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 732 <paging_init+0x652>
 732:	8b 35 00 00 00 00    	mov    0x0(%rip),%esi        # 738 <paging_init+0x658>
        if ( (l1_pg = alloc_domheap_pages(NULL, PAGETABLE_ORDER,
                                               memflags)) == NULL )
            goto nomem;
        map_pages_to_xen(
            RDWR_COMPAT_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT),
            page_to_mfn(l1_pg),
 738:	49 bf 00 00 00 00 20 	movabs $0x7d2000000000,%r15
 73f:	7d 00 00 
             sizeof(*compat_machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*compat_machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++, l2_ro_mpt++ )
    {
        memflags = MEMF_node(phys_to_nid(i <<
 742:	48 89 da             	mov    %rbx,%rdx
 745:	49 89 de             	mov    %rbx,%r14
 748:	45 31 e4             	xor    %r12d,%r12d
 74b:	48 c1 e2 1f          	shl    $0x1f,%rdx
 74f:	49 c1 e6 15          	shl    $0x15,%r14
 753:	48 c1 ea 0c          	shr    $0xc,%rdx
extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
 757:	48 21 d0             	and    %rdx,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
 75a:	48 21 fa             	and    %rdi,%rdx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
 75d:	48 d3 e8             	shr    %cl,%rax
 760:	89 f1                	mov    %esi,%ecx

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
 762:	48 09 d0             	or     %rdx,%rax
 765:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 76c <paging_init+0x68c>
 76c:	48 d3 e8             	shr    %cl,%rax
 76f:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx
 773:	88 54 24 1c          	mov    %dl,0x1c(%rsp)
 777:	4c 89 f2             	mov    %r14,%rdx
 77a:	48 c1 ea 02          	shr    $0x2,%rdx
 77e:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
 783:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
            (L2_PAGETABLE_SHIFT - 2 + PAGE_SHIFT)));
        for ( n = 0; n < CNT; ++n)
            if ( mfn_valid(MFN(i) + n * PDX_GROUP_COUNT) )
 788:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
 78d:	4c 01 e7             	add    %r12,%rdi
 790:	e8 00 00 00 00       	callq  795 <paging_init+0x6b5>
 795:	85 c0                	test   %eax,%eax
 797:	75 40                	jne    7d9 <paging_init+0x6f9>
 799:	49 81 c4 00 00 01 00 	add    $0x10000,%r12
                 sizeof(*compat_machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++, l2_ro_mpt++ )
    {
        memflags = MEMF_node(phys_to_nid(i <<
            (L2_PAGETABLE_SHIFT - 2 + PAGE_SHIFT)));
        for ( n = 0; n < CNT; ++n)
 7a0:	49 81 fc 00 00 08 00 	cmp    $0x80000,%r12
 7a7:	75 df                	jne    788 <paging_init+0x6a8>
#define MFN(x) (((x) << L2_PAGETABLE_SHIFT) / sizeof(unsigned int))
#define CNT ((sizeof(*frame_table) & -sizeof(*frame_table)) / \
             sizeof(*compat_machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*compat_machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++, l2_ro_mpt++ )
 7a9:	48 83 c3 01          	add    $0x1,%rbx
 7ad:	4c 39 eb             	cmp    %r13,%rbx
 7b0:	0f 84 d3 00 00 00    	je     889 <paging_init+0x7a9>
 7b6:	48 83 c5 08          	add    $0x8,%rbp
 7ba:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 7c1 <paging_init+0x6e1>
 7c1:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 7c8 <paging_init+0x6e8>
 7c8:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 7ce <paging_init+0x6ee>
 7ce:	8b 35 00 00 00 00    	mov    0x0(%rip),%esi        # 7d4 <paging_init+0x6f4>
 7d4:	e9 69 ff ff ff       	jmpq   742 <paging_init+0x662>
 7d9:	0f b6 44 24 1c       	movzbl 0x1c(%rsp),%eax
        for ( n = 0; n < CNT; ++n)
            if ( mfn_valid(MFN(i) + n * PDX_GROUP_COUNT) )
                break;
        if ( n == CNT )
            continue;
        if ( (l1_pg = alloc_domheap_pages(NULL, PAGETABLE_ORDER,
 7de:	31 ff                	xor    %edi,%edi
 7e0:	be 09 00 00 00       	mov    $0x9,%esi
             sizeof(*compat_machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*compat_machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++, l2_ro_mpt++ )
    {
        memflags = MEMF_node(phys_to_nid(i <<
 7e5:	83 c0 01             	add    $0x1,%eax
 7e8:	c1 e0 08             	shl    $0x8,%eax
 7eb:	0f b7 d0             	movzwl %ax,%edx
        for ( n = 0; n < CNT; ++n)
            if ( mfn_valid(MFN(i) + n * PDX_GROUP_COUNT) )
                break;
        if ( n == CNT )
            continue;
        if ( (l1_pg = alloc_domheap_pages(NULL, PAGETABLE_ORDER,
 7ee:	e8 00 00 00 00       	callq  7f3 <paging_init+0x713>
 7f3:	48 85 c0             	test   %rax,%rax
 7f6:	0f 84 d4 f9 ff ff    	je     1d0 <paging_init+0xf0>
                                               memflags)) == NULL )
            goto nomem;
        map_pages_to_xen(
            RDWR_COMPAT_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT),
            page_to_mfn(l1_pg),
 7fc:	4e 8d 24 38          	lea    (%rax,%r15,1),%r12
        if ( n == CNT )
            continue;
        if ( (l1_pg = alloc_domheap_pages(NULL, PAGETABLE_ORDER,
                                               memflags)) == NULL )
            goto nomem;
        map_pages_to_xen(
 800:	48 b9 00 00 00 40 c4 	movabs $0xffff82c440000000,%rcx
 807:	82 ff ff 
 80a:	ba 00 02 00 00       	mov    $0x200,%edx
 80f:	49 01 ce             	add    %rcx,%r14
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 812:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 818 <paging_init+0x738>
            RDWR_COMPAT_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT),
            page_to_mfn(l1_pg),
 818:	49 c1 fc 05          	sar    $0x5,%r12
        if ( n == CNT )
            continue;
        if ( (l1_pg = alloc_domheap_pages(NULL, PAGETABLE_ORDER,
                                               memflags)) == NULL )
            goto nomem;
        map_pages_to_xen(
 81c:	4c 89 f7             	mov    %r14,%rdi
 81f:	4c 89 e6             	mov    %r12,%rsi
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 822:	4c 89 e0             	mov    %r12,%rax
 825:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 82c <paging_init+0x74c>
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 82c:	48 d3 e6             	shl    %cl,%rsi
 82f:	48 23 35 00 00 00 00 	and    0x0(%rip),%rsi        # 836 <paging_init+0x756>
 836:	b9 63 01 00 00       	mov    $0x163,%ecx
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 83b:	48 09 c6             	or     %rax,%rsi
 83e:	e8 00 00 00 00       	callq  843 <paging_init+0x763>
            RDWR_COMPAT_MPT_VIRT_START + (i << L2_PAGETABLE_SHIFT),
            page_to_mfn(l1_pg),
            1UL << PAGETABLE_ORDER,
            PAGE_HYPERVISOR);
        memset((void *)(RDWR_COMPAT_MPT_VIRT_START +
 843:	ba 00 00 20 00       	mov    $0x200000,%edx
 848:	be 55 00 00 00       	mov    $0x55,%esi
 84d:	4c 89 f7             	mov    %r14,%rdi
 850:	e8 00 00 00 00       	callq  855 <paging_init+0x775>
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 855:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 85b <paging_init+0x77b>
 85b:	4c 89 e0             	mov    %r12,%rax
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 85e:	4c 23 25 00 00 00 00 	and    0x0(%rip),%r12        # 865 <paging_init+0x785>
           ((pdx << pfn_pdx_hole_shift) & pfn_top_mask);
 865:	48 d3 e0             	shl    %cl,%rax
 868:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 86f <paging_init+0x78f>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
}

static inline unsigned long pdx_to_pfn(unsigned long pdx)
{
    return (pdx & pfn_pdx_bottom_mask) |
 86f:	4c 09 e0             	or     %r12,%rax
                        (i << L2_PAGETABLE_SHIFT)),
               0x55,
               1UL << L2_PAGETABLE_SHIFT);
        /* NB. Cannot be GLOBAL as the ptes get copied into per-VM space. */
        l2e_write(l2_ro_mpt, l2e_from_page(l1_pg, _PAGE_PSE|_PAGE_PRESENT));
 872:	48 c1 e0 0c          	shl    $0xc,%rax
 876:	0c 81                	or     $0x81,%al
 878:	48 89 45 00          	mov    %rax,0x0(%rbp)
#define MFN(x) (((x) << L2_PAGETABLE_SHIFT) / sizeof(unsigned int))
#define CNT ((sizeof(*frame_table) & -sizeof(*frame_table)) / \
             sizeof(*compat_machine_to_phys_mapping))
    BUILD_BUG_ON((sizeof(*frame_table) & ~sizeof(*frame_table)) % \
                 sizeof(*compat_machine_to_phys_mapping));
    for ( i = 0; i < (mpt_size >> L2_PAGETABLE_SHIFT); i++, l2_ro_mpt++ )
 87c:	48 83 c3 01          	add    $0x1,%rbx
 880:	4c 39 eb             	cmp    %r13,%rbx
 883:	0f 85 2d ff ff ff    	jne    7b6 <paging_init+0x6d6>
#undef MFN

    machine_to_phys_mapping_valid = 1;

    /* Set up linear page table mapping. */
    l4e_write(&idle_pg_table[l4_table_offset(LINEAR_PT_VIRT_START)],
 889:	48 8d 05 00 00 00 00 	lea    0x0(%rip),%rax        # 890 <paging_init+0x7b0>

static inline unsigned long __virt_to_maddr(unsigned long va)
{
    ASSERT(va >= XEN_VIRT_START);
    ASSERT(va < DIRECTMAP_VIRT_END);
    if ( va >= DIRECTMAP_VIRT_START )
 890:	48 ba ff ff ff ff ff 	movabs $0xffff82ffffffffff,%rdx
 897:	82 ff ff 
        l2e_write(l2_ro_mpt, l2e_from_page(l1_pg, _PAGE_PSE|_PAGE_PRESENT));
    }
#undef CNT
#undef MFN

    machine_to_phys_mapping_valid = 1;
 89a:	c6 05 00 00 00 00 01 	movb   $0x1,0x0(%rip)        # 8a1 <paging_init+0x7c1>
 8a1:	48 39 d0             	cmp    %rdx,%rax
 8a4:	76 57                	jbe    8fd <paging_init+0x81d>
        va -= DIRECTMAP_VIRT_START;
 8a6:	48 ba 00 00 00 00 00 	movabs $0x7d0000000000,%rdx
 8ad:	7d 00 00 
 8b0:	48 01 c2             	add    %rax,%rdx
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
 8b3:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 8b9 <paging_init+0x7d9>
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
 8b9:	48 89 d0             	mov    %rdx,%rax
 8bc:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # 8c3 <paging_init+0x7e3>
           ((va << pfn_pdx_hole_shift) & ma_top_mask);
 8c3:	48 d3 e2             	shl    %cl,%rdx
 8c6:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # 8cd <paging_init+0x7ed>
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
    }
    return (va & ma_va_bottom_mask) |
 8cd:	48 83 c8 63          	or     $0x63,%rax
}
static inline l4_pgentry_t l4e_from_paddr(paddr_t pa, unsigned int flags)
{
    ASSERT((pa & ~(PADDR_MASK & PAGE_MASK)) == 0);
    return (l4_pgentry_t) { pa | put_pte_flags(flags) };
 8d1:	48 09 d0             	or     %rdx,%rax
 8d4:	48 89 05 00 00 00 00 	mov    %rax,0x0(%rip)        # 8db <paging_init+0x7fb>
              l4e_from_paddr(__pa(idle_pg_table), __PAGE_HYPERVISOR));
    return;

 nomem:
    panic("Not enough memory for m2p table\n");    
}
 8db:	48 83 c4 58          	add    $0x58,%rsp
 8df:	5b                   	pop    %rbx
 8e0:	5d                   	pop    %rbp
 8e1:	41 5c                	pop    %r12
 8e3:	41 5d                	pop    %r13
 8e5:	41 5e                	pop    %r14
 8e7:	41 5f                	pop    %r15
 8e9:	c3                   	retq   
    mpt_size = (mpt_size >> 1) + (1UL << (L2_PAGETABLE_SHIFT - 1));
    if ( mpt_size > RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START )
        mpt_size = RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START;
    mpt_size &= ~((1UL << L2_PAGETABLE_SHIFT) - 1UL);
    if ( (m2p_compat_vstart + mpt_size) < MACH2PHYS_COMPAT_VIRT_END )
        m2p_compat_vstart = MACH2PHYS_COMPAT_VIRT_END - mpt_size;
 8ea:	b8 00 00 e0 ff       	mov    $0xffe00000,%eax
 8ef:	44 29 e8             	sub    %r13d,%eax
 8f2:	89 05 00 00 00 00    	mov    %eax,0x0(%rip)        # 8f8 <paging_init+0x818>
 8f8:	e9 12 fe ff ff       	jmpq   70f <paging_init+0x62f>
    if ( va >= DIRECTMAP_VIRT_START )
        va -= DIRECTMAP_VIRT_START;
    else
    {
        ASSERT(va < XEN_VIRT_END);
        va += xen_phys_start - XEN_VIRT_START;
 8fd:	48 03 05 00 00 00 00 	add    0x0(%rip),%rax        # 904 <paging_init+0x824>
 904:	48 ba 00 00 00 40 3b 	movabs $0x7d3b40000000,%rdx
 90b:	7d 00 00 
 90e:	48 01 c2             	add    %rax,%rdx
 911:	eb a0                	jmp    8b3 <paging_init+0x7d3>
 913:	66 66 66 66 2e 0f 1f 	data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)
 91a:	84 00 00 00 00 00 

0000000000000920 <zap_low_mappings>:
 nomem:
    panic("Not enough memory for m2p table\n");    
}

void __init zap_low_mappings(void)
{
 920:	48 83 ec 08          	sub    $0x8,%rsp
		return __bitmap_full(src, nbits);
}

static inline int bitmap_weight(const unsigned long *src, int nbits)
{
	return __bitmap_weight(src, nbits);
 924:	8b 35 00 00 00 00    	mov    0x0(%rip),%esi        # 92a <zap_low_mappings+0xa>
 92a:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # 931 <zap_low_mappings+0x11>
 931:	e8 00 00 00 00       	callq  936 <zap_low_mappings+0x16>
    BUG_ON(num_online_cpus() != 1);
 936:	83 f8 01             	cmp    $0x1,%eax
 939:	75 46                	jne    981 <zap_low_mappings+0x61>
 93b:	31 c0                	xor    %eax,%eax
 93d:	48 89 05 00 00 00 00 	mov    %rax,0x0(%rip)        # 944 <zap_low_mappings+0x24>

    /* Remove aliased mapping of first 1:1 PML4 entry. */
    l4e_write(&idle_pg_table[0], l4e_empty());
    flush_local(FLUSH_TLB_GLOBAL);
 944:	be 00 02 00 00       	mov    $0x200,%esi
 949:	31 ff                	xor    %edi,%edi
 94b:	e8 00 00 00 00       	callq  950 <zap_low_mappings+0x30>

    /* Replace with mapping of the boot trampoline only. */
    map_pages_to_xen(trampoline_phys, trampoline_phys >> PAGE_SHIFT,
 950:	48 8b 3d 00 00 00 00 	mov    0x0(%rip),%rdi        # 957 <zap_low_mappings+0x37>
                     PFN_UP(trampoline_end - trampoline_start),
 957:	48 8d 15 00 00 00 00 	lea    0x0(%rip),%rdx        # 95e <zap_low_mappings+0x3e>
 95e:	48 8d 05 00 00 00 00 	lea    0x0(%rip),%rax        # 965 <zap_low_mappings+0x45>
    /* Remove aliased mapping of first 1:1 PML4 entry. */
    l4e_write(&idle_pg_table[0], l4e_empty());
    flush_local(FLUSH_TLB_GLOBAL);

    /* Replace with mapping of the boot trampoline only. */
    map_pages_to_xen(trampoline_phys, trampoline_phys >> PAGE_SHIFT,
 965:	b9 63 00 00 00       	mov    $0x63,%ecx
                     PFN_UP(trampoline_end - trampoline_start),
                     __PAGE_HYPERVISOR);
}
 96a:	48 83 c4 08          	add    $0x8,%rsp
    l4e_write(&idle_pg_table[0], l4e_empty());
    flush_local(FLUSH_TLB_GLOBAL);

    /* Replace with mapping of the boot trampoline only. */
    map_pages_to_xen(trampoline_phys, trampoline_phys >> PAGE_SHIFT,
                     PFN_UP(trampoline_end - trampoline_start),
 96e:	48 29 c2             	sub    %rax,%rdx
    /* Remove aliased mapping of first 1:1 PML4 entry. */
    l4e_write(&idle_pg_table[0], l4e_empty());
    flush_local(FLUSH_TLB_GLOBAL);

    /* Replace with mapping of the boot trampoline only. */
    map_pages_to_xen(trampoline_phys, trampoline_phys >> PAGE_SHIFT,
 971:	48 89 fe             	mov    %rdi,%rsi
                     PFN_UP(trampoline_end - trampoline_start),
 974:	48 c1 fa 0c          	sar    $0xc,%rdx
    /* Remove aliased mapping of first 1:1 PML4 entry. */
    l4e_write(&idle_pg_table[0], l4e_empty());
    flush_local(FLUSH_TLB_GLOBAL);

    /* Replace with mapping of the boot trampoline only. */
    map_pages_to_xen(trampoline_phys, trampoline_phys >> PAGE_SHIFT,
 978:	48 c1 ee 0c          	shr    $0xc,%rsi
 97c:	e9 00 00 00 00       	jmpq   981 <zap_low_mappings+0x61>
    panic("Not enough memory for m2p table\n");    
}

void __init zap_low_mappings(void)
{
    BUG_ON(num_online_cpus() != 1);
 981:	0f 0b                	ud2    
 983:	c2 ce 0c             	retq   $0xcce
 986:	bc 00 00 00 00       	mov    $0x0,%esp
 98b:	eb ae                	jmp    93b <zap_low_mappings+0x1b>
 98d:	0f 1f 00             	nopl   (%rax)

0000000000000990 <subarch_init_memory>:
           (unsigned long)mfn_to_page(epfn) - (unsigned long)mfn_to_page(spfn));
    return 0;
}

void __init subarch_init_memory(void)
{
 990:	41 57                	push   %r15
 992:	41 56                	push   %r14
            m2p_start_mfn = l3e_get_pfn(l3e);
        }

        for ( i = 0; i < n; i++ )
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
 994:	49 be 00 00 00 00 e0 	movabs $0xffff82e000000000,%r14
 99b:	82 ff ff 
           (unsigned long)mfn_to_page(epfn) - (unsigned long)mfn_to_page(spfn));
    return 0;
}

void __init subarch_init_memory(void)
{
 99e:	41 55                	push   %r13
 9a0:	41 54                	push   %r12
 9a2:	55                   	push   %rbp
    l2_pgentry_t l2e;

    BUILD_BUG_ON(RDWR_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
    BUILD_BUG_ON(RDWR_MPT_VIRT_END   & ((1UL << L3_PAGETABLE_SHIFT) - 1));
    /* M2P table is mappable read-only by privileged domains. */
    for ( v  = RDWR_MPT_VIRT_START;
 9a3:	48 bd 00 00 00 00 80 	movabs $0xffff828000000000,%rbp
 9aa:	82 ff ff 
           (unsigned long)mfn_to_page(epfn) - (unsigned long)mfn_to_page(spfn));
    return 0;
}

void __init subarch_init_memory(void)
{
 9ad:	53                   	push   %rbx
 9ae:	48 83 ec 18          	sub    $0x18,%rsp
        l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
        if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
 9b2:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 9b9 <subarch_init_memory+0x29>
 9b9:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # 9c0 <subarch_init_memory+0x30>
 9c0:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # 9c6 <subarch_init_memory+0x36>
    for ( v  = RDWR_MPT_VIRT_START;
          v != RDWR_MPT_VIRT_END;
          v += n << PAGE_SHIFT )
    {
        n = L2_PAGETABLE_ENTRIES * L1_PAGETABLE_ENTRIES;
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
 9c6:	48 89 ee             	mov    %rbp,%rsi
 9c9:	4c 8d 05 00 00 00 00 	lea    0x0(%rip),%r8        # 9d0 <subarch_init_memory+0x40>
 9d0:	48 bf 00 f0 ff ff ff 	movabs $0xffffffffff000,%rdi
 9d7:	ff 0f 00 
 9da:	48 c1 ee 27          	shr    $0x27,%rsi
            l3_table_offset(v)];
        if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
 9de:	41 bf 00 00 00 40    	mov    $0x40000000,%r15d
    for ( v  = RDWR_MPT_VIRT_START;
          v != RDWR_MPT_VIRT_END;
          v += n << PAGE_SHIFT )
    {
        n = L2_PAGETABLE_ENTRIES * L1_PAGETABLE_ENTRIES;
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
 9e4:	81 e6 ff 01 00 00    	and    $0x1ff,%esi
 9ea:	49 23 3c f0          	and    (%r8,%rsi,8),%rdi
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
 9ee:	48 89 d6             	mov    %rdx,%rsi
 9f1:	49 b8 00 00 00 00 00 	movabs $0xffff830000000000,%r8
 9f8:	83 ff ff 
 9fb:	48 21 fe             	and    %rdi,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
 9fe:	48 21 c7             	and    %rax,%rdi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
 a01:	48 d3 ee             	shr    %cl,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
 a04:	48 09 fe             	or     %rdi,%rsi
            l3_table_offset(v)];
 a07:	48 89 ef             	mov    %rbp,%rdi
 a0a:	48 c1 ef 1b          	shr    $0x1b,%rdi
    for ( v  = RDWR_MPT_VIRT_START;
          v != RDWR_MPT_VIRT_END;
          v += n << PAGE_SHIFT )
    {
        n = L2_PAGETABLE_ENTRIES * L1_PAGETABLE_ENTRIES;
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
 a0e:	81 e7 f8 0f 00 00    	and    $0xff8,%edi
 a14:	48 01 fe             	add    %rdi,%rsi
 a17:	4a 8b 3c 06          	mov    (%rsi,%r8,1),%rdi
            l3_table_offset(v)];
        if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
 a1b:	48 89 fe             	mov    %rdi,%rsi
 a1e:	41 89 f8             	mov    %edi,%r8d
 a21:	48 c1 ee 28          	shr    $0x28,%rsi
 a25:	41 81 e0 ff 0f 00 00 	and    $0xfff,%r8d
 a2c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
 a32:	44 09 c6             	or     %r8d,%esi
 a35:	40 f6 c6 01          	test   $0x1,%sil
 a39:	0f 84 c1 00 00 00    	je     b00 <subarch_init_memory+0x170>
            continue;
        if ( !(l3e_get_flags(l3e) & _PAGE_PSE) )
 a3f:	81 e6 80 00 00 00    	and    $0x80,%esi
 a45:	0f 85 cd 01 00 00    	jne    c18 <subarch_init_memory+0x288>
        {
            n = L1_PAGETABLE_ENTRIES;
            l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
 a4b:	48 be 00 f0 ff ff ff 	movabs $0xffffffffff000,%rsi
 a52:	ff 0f 00 
            if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
 a55:	41 bf 00 00 20 00    	mov    $0x200000,%r15d
        if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
            continue;
        if ( !(l3e_get_flags(l3e) & _PAGE_PSE) )
        {
            n = L1_PAGETABLE_ENTRIES;
            l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
 a5b:	48 21 f7             	and    %rsi,%rdi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
 a5e:	48 89 d6             	mov    %rdx,%rsi
 a61:	48 21 fe             	and    %rdi,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
 a64:	48 21 c7             	and    %rax,%rdi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
 a67:	48 d3 ee             	shr    %cl,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
 a6a:	48 09 fe             	or     %rdi,%rsi
 a6d:	48 89 ef             	mov    %rbp,%rdi
 a70:	48 c1 ef 12          	shr    $0x12,%rdi
 a74:	81 e7 f8 0f 00 00    	and    $0xff8,%edi
 a7a:	48 01 fe             	add    %rdi,%rsi
 a7d:	48 bf 00 00 00 00 00 	movabs $0xffff830000000000,%rdi
 a84:	83 ff ff 
 a87:	4c 8b 24 3e          	mov    (%rsi,%rdi,1),%r12
            if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
 a8b:	41 f6 c4 01          	test   $0x1,%r12b
 a8f:	74 6f                	je     b00 <subarch_init_memory+0x170>
                continue;
            m2p_start_mfn = l2e_get_pfn(l2e);
 a91:	49 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%r8
 a98:	ff 0f 00 
            l3_table_offset(v)];
        if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
            continue;
        if ( !(l3e_get_flags(l3e) & _PAGE_PSE) )
        {
            n = L1_PAGETABLE_ENTRIES;
 a9b:	41 bd 00 02 00 00    	mov    $0x200,%r13d
            l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
            if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
                continue;
            m2p_start_mfn = l2e_get_pfn(l2e);
 aa1:	4d 21 c4             	and    %r8,%r12
 aa4:	49 c1 ec 0c          	shr    $0xc,%r12
        else
        {
            m2p_start_mfn = l3e_get_pfn(l3e);
        }

        for ( i = 0; i < n; i++ )
 aa8:	31 db                	xor    %ebx,%ebx
 aaa:	eb 0a                	jmp    ab6 <subarch_init_memory+0x126>
 aac:	0f 1f 40 00          	nopl   0x0(%rax)
 ab0:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # ab6 <subarch_init_memory+0x126>
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
 ab6:	4a 8d 14 23          	lea    (%rbx,%r12,1),%rdx
            share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
 aba:	be 01 00 00 00       	mov    $0x1,%esi
        else
        {
            m2p_start_mfn = l3e_get_pfn(l3e);
        }

        for ( i = 0; i < n; i++ )
 abf:	48 83 c3 01          	add    $0x1,%rbx
extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
 ac3:	48 89 d0             	mov    %rdx,%rax
 ac6:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # acd <subarch_init_memory+0x13d>

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
 acd:	48 23 15 00 00 00 00 	and    0x0(%rip),%rdx        # ad4 <subarch_init_memory+0x144>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
 ad4:	48 d3 e8             	shr    %cl,%rax

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
 ad7:	48 09 d0             	or     %rdx,%rax
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
 ada:	48 c1 e0 05          	shl    $0x5,%rax
 ade:	4a 8d 3c 30          	lea    (%rax,%r14,1),%rdi
            share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
 ae2:	e8 00 00 00 00       	callq  ae7 <subarch_init_memory+0x157>
        else
        {
            m2p_start_mfn = l3e_get_pfn(l3e);
        }

        for ( i = 0; i < n; i++ )
 ae7:	49 39 dd             	cmp    %rbx,%r13
 aea:	77 c4                	ja     ab0 <subarch_init_memory+0x120>
 aec:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # af3 <subarch_init_memory+0x163>
 af3:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # afa <subarch_init_memory+0x16a>
 afa:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # b00 <subarch_init_memory+0x170>
    BUILD_BUG_ON(RDWR_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
    BUILD_BUG_ON(RDWR_MPT_VIRT_END   & ((1UL << L3_PAGETABLE_SHIFT) - 1));
    /* M2P table is mappable read-only by privileged domains. */
    for ( v  = RDWR_MPT_VIRT_START;
          v != RDWR_MPT_VIRT_END;
          v += n << PAGE_SHIFT )
 b00:	4c 01 fd             	add    %r15,%rbp
    l2_pgentry_t l2e;

    BUILD_BUG_ON(RDWR_MPT_VIRT_START & ((1UL << L3_PAGETABLE_SHIFT) - 1));
    BUILD_BUG_ON(RDWR_MPT_VIRT_END   & ((1UL << L3_PAGETABLE_SHIFT) - 1));
    /* M2P table is mappable read-only by privileged domains. */
    for ( v  = RDWR_MPT_VIRT_START;
 b03:	48 be 00 00 00 00 c0 	movabs $0xffff82c000000000,%rsi
 b0a:	82 ff ff 
 b0d:	48 39 f5             	cmp    %rsi,%rbp
 b10:	0f 85 b0 fe ff ff    	jne    9c6 <subarch_init_memory+0x36>
 b16:	49 bc 00 00 00 40 c4 	movabs $0xffff82c440000000,%r12
 b1d:	82 ff ff 

    for ( v  = RDWR_COMPAT_MPT_VIRT_START;
          v != RDWR_COMPAT_MPT_VIRT_END;
          v += 1 << L2_PAGETABLE_SHIFT )
    {
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
 b20:	49 bd 00 f0 ff ff ff 	movabs $0xffffffffff000,%r13
 b27:	ff 0f 00 
 b2a:	49 be 00 00 00 00 00 	movabs $0xffff830000000000,%r14
 b31:	83 ff ff 
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
 b34:	48 bd 00 00 00 00 e0 	movabs $0xffff82e000000000,%rbp
 b3b:	82 ff ff 
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
            share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
        }
    }

    for ( v  = RDWR_COMPAT_MPT_VIRT_START;
 b3e:	49 bf 00 00 00 80 c4 	movabs $0xffff82c480000000,%r15
 b45:	82 ff ff 
 b48:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 b4f:	00 
          v != RDWR_COMPAT_MPT_VIRT_END;
          v += 1 << L2_PAGETABLE_SHIFT )
    {
        l3e = l4e_to_l3e(idle_pg_table[l4_table_offset(v)])[
 b50:	4c 89 ef             	mov    %r13,%rdi
 b53:	48 23 3d 00 00 00 00 	and    0x0(%rip),%rdi        # b5a <subarch_init_memory+0x1ca>
static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
 b5a:	48 89 d6             	mov    %rdx,%rsi
 b5d:	48 21 fe             	and    %rdi,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
 b60:	48 21 c7             	and    %rax,%rdi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
 b63:	48 d3 ee             	shr    %cl,%rsi

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
 b66:	48 09 fe             	or     %rdi,%rsi
 b69:	4a 8b b4 36 88 08 00 	mov    0x888(%rsi,%r14,1),%rsi
 b70:	00 
            l3_table_offset(v)];
        if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
 b71:	40 f6 c6 01          	test   $0x1,%sil
 b75:	74 7c                	je     bf3 <subarch_init_memory+0x263>
            continue;
        l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
 b77:	4c 21 ee             	and    %r13,%rsi
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
 b7a:	48 21 f2             	and    %rsi,%rdx

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
 b7d:	48 21 f0             	and    %rsi,%rax
                     ((ma & ma_top_mask) >> pfn_pdx_hole_shift)));
 b80:	48 d3 ea             	shr    %cl,%rdx

static inline void *__maddr_to_virt(unsigned long ma)
{
    ASSERT(pfn_to_pdx(ma >> PAGE_SHIFT) < (DIRECTMAP_SIZE >> PAGE_SHIFT));
    return (void *)(DIRECTMAP_VIRT_START +
                    ((ma & ma_va_bottom_mask) |
 b83:	48 09 c2             	or     %rax,%rdx
 b86:	4c 89 e0             	mov    %r12,%rax
 b89:	48 c1 e8 12          	shr    $0x12,%rax
 b8d:	25 f8 0f 00 00       	and    $0xff8,%eax
 b92:	48 01 c2             	add    %rax,%rdx
 b95:	4a 8b 04 32          	mov    (%rdx,%r14,1),%rax
        if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
 b99:	a8 01                	test   $0x1,%al
 b9b:	74 56                	je     bf3 <subarch_init_memory+0x263>
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);
 b9d:	4c 21 e8             	and    %r13,%rax

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
 ba0:	31 db                	xor    %ebx,%ebx
        if ( !(l3e_get_flags(l3e) & _PAGE_PRESENT) )
            continue;
        l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
        if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);
 ba2:	48 c1 e8 0c          	shr    $0xc,%rax
 ba6:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
 bab:	eb 09                	jmp    bb6 <subarch_init_memory+0x226>
 bad:	0f 1f 00             	nopl   (%rax)

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
 bb0:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # bb6 <subarch_init_memory+0x226>
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
 bb6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
            share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
 bbb:	be 01 00 00 00       	mov    $0x1,%esi
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
 bc0:	48 01 d8             	add    %rbx,%rax
        l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
        if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
 bc3:	48 83 c3 01          	add    $0x1,%rbx
extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
 bc7:	48 89 c7             	mov    %rax,%rdi
 bca:	48 23 3d 00 00 00 00 	and    0x0(%rip),%rdi        # bd1 <subarch_init_memory+0x241>

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
 bd1:	48 23 05 00 00 00 00 	and    0x0(%rip),%rax        # bd8 <subarch_init_memory+0x248>
           ((pfn & pfn_top_mask) >> pfn_pdx_hole_shift);
 bd8:	48 d3 ef             	shr    %cl,%rdi

extern int __mfn_valid(unsigned long mfn);

static inline unsigned long pfn_to_pdx(unsigned long pfn)
{
    return (pfn & pfn_pdx_bottom_mask) |
 bdb:	48 09 c7             	or     %rax,%rdi
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
 bde:	48 c1 e7 05          	shl    $0x5,%rdi
 be2:	48 01 ef             	add    %rbp,%rdi
            share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
 be5:	e8 00 00 00 00       	callq  bea <subarch_init_memory+0x25a>
        l2e = l3e_to_l2e(l3e)[l2_table_offset(v)];
        if ( !(l2e_get_flags(l2e) & _PAGE_PRESENT) )
            continue;
        m2p_start_mfn = l2e_get_pfn(l2e);

        for ( i = 0; i < L1_PAGETABLE_ENTRIES; i++ )
 bea:	48 81 fb 00 02 00 00 	cmp    $0x200,%rbx
 bf1:	75 bd                	jne    bb0 <subarch_init_memory+0x220>
        }
    }

    for ( v  = RDWR_COMPAT_MPT_VIRT_START;
          v != RDWR_COMPAT_MPT_VIRT_END;
          v += 1 << L2_PAGETABLE_SHIFT )
 bf3:	49 81 c4 00 00 20 00 	add    $0x200000,%r12
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
            share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
        }
    }

    for ( v  = RDWR_COMPAT_MPT_VIRT_START;
 bfa:	4d 39 fc             	cmp    %r15,%r12
 bfd:	74 35                	je     c34 <subarch_init_memory+0x2a4>
 bff:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # c06 <subarch_init_memory+0x276>
 c06:	48 8b 15 00 00 00 00 	mov    0x0(%rip),%rdx        # c0d <subarch_init_memory+0x27d>
 c0d:	8b 0d 00 00 00 00    	mov    0x0(%rip),%ecx        # c13 <subarch_init_memory+0x283>
 c13:	e9 38 ff ff ff       	jmpq   b50 <subarch_init_memory+0x1c0>
                continue;
            m2p_start_mfn = l2e_get_pfn(l2e);
        }
        else
        {
            m2p_start_mfn = l3e_get_pfn(l3e);
 c18:	49 bc 00 f0 ff ff ff 	movabs $0xffffffffff000,%r12
 c1f:	ff 0f 00 
    /* M2P table is mappable read-only by privileged domains. */
    for ( v  = RDWR_MPT_VIRT_START;
          v != RDWR_MPT_VIRT_END;
          v += n << PAGE_SHIFT )
    {
        n = L2_PAGETABLE_ENTRIES * L1_PAGETABLE_ENTRIES;
 c22:	41 bd 00 00 04 00    	mov    $0x40000,%r13d
                continue;
            m2p_start_mfn = l2e_get_pfn(l2e);
        }
        else
        {
            m2p_start_mfn = l3e_get_pfn(l3e);
 c28:	49 21 fc             	and    %rdi,%r12
 c2b:	49 c1 ec 0c          	shr    $0xc,%r12
 c2f:	e9 74 fe ff ff       	jmpq   aa8 <subarch_init_memory+0x118>
        {
            struct page_info *page = mfn_to_page(m2p_start_mfn + i);
            share_xen_page_with_privileged_guests(page, XENSHARE_readonly);
        }
    }
}
 c34:	48 83 c4 18          	add    $0x18,%rsp
 c38:	5b                   	pop    %rbx
 c39:	5d                   	pop    %rbp
 c3a:	41 5c                	pop    %r12
 c3c:	41 5d                	pop    %r13
 c3e:	41 5e                	pop    %r14
 c40:	41 5f                	pop    %r15
 c42:	c3                   	retq   

Disassembly of section .fixup:

0000000000000000 <.fixup>:
   0:	bf f2 ff ff ff       	mov    $0xfffffff2,%edi
   5:	e9 00 00 00 00       	jmpq   a <.fixup+0xa>
   a:	31 f6                	xor    %esi,%esi
   c:	e9 00 00 00 00       	jmpq   11 <.fixup+0x11>
  11:	bf f2 ff ff ff       	mov    $0xfffffff2,%edi
  16:	e9 00 00 00 00       	jmpq   1b <.fixup+0x1b>
  1b:	bf f2 ff ff ff       	mov    $0xfffffff2,%edi
  20:	e9 00 00 00 00       	jmpq   25 <.fixup+0x25>
  25:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
  2c:	31 d2                	xor    %edx,%edx
  2e:	e9 00 00 00 00       	jmpq   33 <.fixup+0x33>
  33:	49 c7 c7 08 00 00 00 	mov    $0x8,%r15
  3a:	e9 00 00 00 00       	jmpq   3f <.LC11+0x4>
