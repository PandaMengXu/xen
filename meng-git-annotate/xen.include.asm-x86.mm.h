08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	1)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	2)#ifndef __ASM_X86_MM_H__
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	3)#define __ASM_X86_MM_H__
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	4)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	5)#include <xen/config.h>
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	6)#include <xen/list.h>
301493fb	(Tim Deegan	2011-06-02 13:16:52 +0100	7)#include <xen/spinlock.h>
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	8)#include <asm/io.h>
634be0ec	(mafetter@fleming.research	2005-04-05 08:49:46 +0000	9)#include <asm/uaccess.h>
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	10)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	11)/*
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	12) * Per-page-frame information.
f3b57d09	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 13:40:31 +0000	13) * 
f3b57d09	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 13:40:31 +0000	14) * Every architecture must ensure the following:
e44c9316	(Keir Fraser	2009-01-30 11:03:28 +0000	15) *  1. 'struct page_info' contains a 'struct page_list_entry list'.
f3b57d09	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 13:40:31 +0000	16) *  2. Provide a PFN_ORDER() macro for accessing the order of a free page.
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	17) */
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	18)#define PFN_ORDER(_pfn) ((_pfn)->v.free.order)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	19)
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	20)/*
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	21) * This definition is solely for the use in struct page_info (and
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	22) * struct page_list_head), intended to allow easy adjustment once x86-64
2090d390	(Keir Fraser	2009-01-30 11:33:27 +0000	23) * wants to support more than 16TB.
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	24) * 'unsigned long' should be used for MFNs everywhere else.
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	25) */
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	26)#define __pdx_t unsigned int
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	27)
2090d390	(Keir Fraser	2009-01-30 11:33:27 +0000	28)#undef page_list_entry
e44c9316	(Keir Fraser	2009-01-30 11:03:28 +0000	29)struct page_list_entry
e44c9316	(Keir Fraser	2009-01-30 11:03:28 +0000	30){
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	31)    __pdx_t next, prev;
e44c9316	(Keir Fraser	2009-01-30 11:03:28 +0000	32)};
e44c9316	(Keir Fraser	2009-01-30 11:03:28 +0000	33)
76dd1b02	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	34)struct page_sharing_info;
76dd1b02	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	35)
d8b61b1e	(kaf24@firebug.cl.cam.ac.uk	2006-02-01 16:28:50 +0100	36)struct page_info
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	37){
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	38)    union {
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	39)        /* Each frame can be threaded onto a doubly-linked list.
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	40)         *
09cae246	(Tim Deegan	2010-09-01 11:23:49 +0100	41)         * For unused shadow pages, a list of free shadow pages;
1c7493f1	(Tim Deegan	2010-09-01 11:23:48 +0100	42)         * for multi-page shadows, links to the other pages in this shadow;
1c7493f1	(Tim Deegan	2010-09-01 11:23:48 +0100	43)         * for pinnable shadows, if pinned, a list of all pinned shadows
1c7493f1	(Tim Deegan	2010-09-01 11:23:48 +0100	44)         * (see sh_type_is_pinnable() for the definition of "pinnable" 
1c7493f1	(Tim Deegan	2010-09-01 11:23:48 +0100	45)         * shadow types).  N.B. a shadow may be both pinnable and multi-page.
1c7493f1	(Tim Deegan	2010-09-01 11:23:48 +0100	46)         * In that case the pages are inserted in order in the list of
1c7493f1	(Tim Deegan	2010-09-01 11:23:48 +0100	47)         * pinned shadows and walkers of that list must be prepared 
1c7493f1	(Tim Deegan	2010-09-01 11:23:48 +0100	48)         * to keep them all together during updates. 
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	49)         */
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	50)        struct page_list_entry list;
1c7493f1	(Tim Deegan	2010-09-01 11:23:48 +0100	51)        /* For non-pinnable single-page shadows, a higher entry that points
1c7493f1	(Tim Deegan	2010-09-01 11:23:48 +0100	52)         * at us. */
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	53)        paddr_t up;
76dd1b02	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	54)        /* For shared/sharable pages, we use a doubly-linked list
76dd1b02	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	55)         * of all the {pfn,domain} pairs that map this page. We also include
76dd1b02	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	56)         * an opaque handle, which is effectively a version, so that clients
76dd1b02	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	57)         * of sharing share the version they expect to.
76dd1b02	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	58)         * This list is allocated and freed when a page is shared/unshared.
76dd1b02	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	59)         */
860b1474	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	60)        struct page_sharing_info *sharing;
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	61)    };
f3b57d09	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 13:40:31 +0000	62)
4f766bc8	(kaf24@labyrinth.cl.cam.ac.uk	2004-08-25 16:26:15 +0000	63)    /* Reference count and various PGC_xxx flags and fields. */
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	64)    unsigned long count_info;
4f766bc8	(kaf24@labyrinth.cl.cam.ac.uk	2004-08-25 16:26:15 +0000	65)
f3b57d09	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 13:40:31 +0000	66)    /* Context-dependent fields follow... */
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	67)    union {
f3b57d09	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 13:40:31 +0000	68)
4f766bc8	(kaf24@labyrinth.cl.cam.ac.uk	2004-08-25 16:26:15 +0000	69)        /* Page is in use: ((count_info & PGC_count_mask) != 0). */
f3b57d09	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 13:40:31 +0000	70)        struct {
f3b57d09	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 13:40:31 +0000	71)            /* Type reference count and various PGT_xxx flags and fields. */
a3ec773b	(kaf24@firebug.cl.cam.ac.uk	2005-08-08 08:18:06 +0000	72)            unsigned long type_info;
e6502656	(Keir Fraser	2009-01-27 11:45:59 +0000	73)        } inuse;
f3b57d09	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 13:40:31 +0000	74)
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	75)        /* Page is in use as a shadow: count_info == 0. */
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	76)        struct {
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	77)            unsigned long type:5;   /* What kind of shadow is this? */
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	78)            unsigned long pinned:1; /* Is the shadow pinned? */
c385d270	(Tim Deegan	2010-09-01 11:23:47 +0100	79)            unsigned long head:1;   /* Is this the first page of the shadow? */
c385d270	(Tim Deegan	2010-09-01 11:23:47 +0100	80)            unsigned long count:25; /* Reference count */
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	81)        } sh;
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	82)
6dec681b	(Keir Fraser	2009-02-05 12:09:10 +0000	83)        /* Page is on a free list: ((count_info & PGC_count_mask) == 0). */
6dec681b	(Keir Fraser	2009-02-05 12:09:10 +0000	84)        struct {
6dec681b	(Keir Fraser	2009-02-05 12:09:10 +0000	85)            /* Do TLBs need flushing for safety before next page use? */
6dec681b	(Keir Fraser	2009-02-05 12:09:10 +0000	86)            bool_t need_tlbflush;
6dec681b	(Keir Fraser	2009-02-05 12:09:10 +0000	87)        } free;
6dec681b	(Keir Fraser	2009-02-05 12:09:10 +0000	88)
e27fcf37	(kaf24@firebug.cl.cam.ac.uk	2005-07-02 08:41:48 +0000	89)    } u;
ec7c322c	(kaf24@firebug.cl.cam.ac.uk	2005-10-05 23:47:09 +0100	90)
49f7c736	(tdeegan@york.uk.xensource.com	2006-08-16 17:02:35 +0100	91)    union {
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	92)
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	93)        /* Page is in use, but not as a shadow. */
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	94)        struct {
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	95)            /* Owner of this page (zero if page is anonymous). */
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	96)            __pdx_t _domain;
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	97)        } inuse;
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	98)
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	99)        /* Page is in use as a shadow. */
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	100)        struct {
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	101)            /* GMFN of guest page we're a shadow of. */
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	102)            __pdx_t back;
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	103)        } sh;
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	104)
09cae246	(Tim Deegan	2010-09-01 11:23:49 +0100	105)        /* Page is on a free list. */
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	106)        struct {
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	107)            /* Order-size of the free chunk this page is the head of. */
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	108)            unsigned int order;
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	109)        } free;
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	110)
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	111)    } v;
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	112)
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	113)    union {
e158d6de	(kfraser@localhost.localdomain	2006-09-21 10:47:05 +0100	114)        /*
e158d6de	(kfraser@localhost.localdomain	2006-09-21 10:47:05 +0100	115)         * Timestamp from 'TLB clock', used to avoid extra safety flushes.
e158d6de	(kfraser@localhost.localdomain	2006-09-21 10:47:05 +0100	116)         * Only valid for: a) free pages, and b) pages with zero type count
e158d6de	(kfraser@localhost.localdomain	2006-09-21 10:47:05 +0100	117)         * (except page table pages when the guest is in shadow mode).
e158d6de	(kfraser@localhost.localdomain	2006-09-21 10:47:05 +0100	118)         */
49f7c736	(tdeegan@york.uk.xensource.com	2006-08-16 17:02:35 +0100	119)        u32 tlbflush_timestamp;
49f7c736	(tdeegan@york.uk.xensource.com	2006-08-16 17:02:35 +0100	120)
e158d6de	(kfraser@localhost.localdomain	2006-09-21 10:47:05 +0100	121)        /*
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	122)         * When PGT_partial is true then this field is valid and indicates
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	123)         * that PTEs in the range [0, @nr_validated_ptes) have been validated.
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	124)         * An extra page reference must be acquired (or not dropped) whenever
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	125)         * PGT_partial gets set, and it must be dropped when the flag gets
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	126)         * cleared. This is so that a get() leaving a page in partially
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	127)         * validated state (where the caller would drop the reference acquired
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	128)         * due to the getting of the type [apparently] failing [-EAGAIN])
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	129)         * would not accidentally result in a page left with zero general
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	130)         * reference count, but non-zero type reference count (possible when
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	131)         * the partial get() is followed immediately by domain destruction).
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	132)         * Likewise, the ownership of the single type reference for partially
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	133)         * (in-)validated pages is tied to this flag, i.e. the instance
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	134)         * setting the flag must not drop that reference, whereas the instance
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	135)         * clearing it will have to.
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	136)         *
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	137)         * If @partial_pte is positive then PTE at @nr_validated_ptes+1 has
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	138)         * been partially validated. This implies that the general reference
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	139)         * to the page (acquired from get_page_from_lNe()) would be dropped
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	140)         * (again due to the apparent failure) and hence must be re-acquired
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	141)         * when resuming the validation, but must not be dropped when picking
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	142)         * up the page for invalidation.
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	143)         *
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	144)         * If @partial_pte is negative then PTE at @nr_validated_ptes+1 has
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	145)         * been partially invalidated. This is basically the opposite case of
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	146)         * above, i.e. the general reference to the page was not dropped in
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	147)         * put_page_from_lNe() (due to the apparent failure), and hence it
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	148)         * must be dropped when the put operation is resumed (and completes),
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	149)         * but it must not be acquired if picking up the page for validation.
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	150)         */
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	151)        struct {
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	152)            u16 nr_validated_ptes;
85061a01	(Keir Fraser	2008-10-30 14:53:24 +0000	153)            s8 partial_pte;
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	154)        };
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	155)
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	156)        /*
63aa5155	(Tim Deegan	2006-11-23 17:40:28 +0000	157)         * Guest pages with a shadow.  This does not conflict with
e158d6de	(kfraser@localhost.localdomain	2006-09-21 10:47:05 +0100	158)         * tlbflush_timestamp since page table pages are explicitly not
e158d6de	(kfraser@localhost.localdomain	2006-09-21 10:47:05 +0100	159)         * tracked for TLB-flush avoidance when a guest runs in shadow mode.
e158d6de	(kfraser@localhost.localdomain	2006-09-21 10:47:05 +0100	160)         */
731718e4	(Keir Fraser	2008-06-12 17:57:03 +0100	161)        u32 shadow_flags;
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	162)
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	163)        /* When in use as a shadow, next shadow in this hash chain. */
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	164)        __pdx_t next_shadow;
49f7c736	(tdeegan@york.uk.xensource.com	2006-08-16 17:02:35 +0100	165)    };
e27fcf37	(kaf24@firebug.cl.cam.ac.uk	2005-07-02 08:41:48 +0000	166)};
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	167)
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	168)#undef __pdx_t
74ded61c	(Keir Fraser	2009-01-30 11:08:06 +0000	169)
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	170)#define PG_shift(idx)   (BITS_PER_LONG - (idx))
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	171)#define PG_mask(x, idx) (x ## UL << PG_shift(idx))
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	172)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	173) /* The following page types are MUTUALLY EXCLUSIVE. */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	174)#define PGT_none          PG_mask(0, 4)  /* no special uses of this page   */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	175)#define PGT_l1_page_table PG_mask(1, 4)  /* using as an L1 page table?     */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	176)#define PGT_l2_page_table PG_mask(2, 4)  /* using as an L2 page table?     */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	177)#define PGT_l3_page_table PG_mask(3, 4)  /* using as an L3 page table?     */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	178)#define PGT_l4_page_table PG_mask(4, 4)  /* using as an L4 page table?     */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	179)#define PGT_seg_desc_page PG_mask(5, 4)  /* using this page in a GDT/LDT?  */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	180)#define PGT_writable_page PG_mask(7, 4)  /* has writable mappings?         */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	181)#define PGT_shared_page   PG_mask(8, 4)  /* CoW sharable page              */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	182)#define PGT_type_mask     PG_mask(15, 4) /* Bits 28-31 or 60-63.           */
0150d071	(mafetter@fleming.research	2005-03-14 22:07:47 +0000	183)
5e2bad93	(kaf24@camelot.eng.3leafnetworks.com	2004-09-04 19:58:36 +0000	184) /* Owning guest has pinned this page to its current type? */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	185)#define _PGT_pinned       PG_shift(5)
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	186)#define PGT_pinned        PG_mask(1, 5)
49f7c736	(tdeegan@york.uk.xensource.com	2006-08-16 17:02:35 +0100	187) /* Has this page been validated for use as its current type? */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	188)#define _PGT_validated    PG_shift(6)
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	189)#define PGT_validated     PG_mask(1, 6)
4e828399	(kfraser@localhost.localdomain	2006-09-18 14:15:03 +0100	190) /* PAE only: is this an L2 page directory containing Xen-private mappings? */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	191)#define _PGT_pae_xen_l2   PG_shift(7)
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	192)#define PGT_pae_xen_l2    PG_mask(1, 7)
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	193)/* Has this page been *partially* validated for use as its current type? */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	194)#define _PGT_partial      PG_shift(8)
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	195)#define PGT_partial       PG_mask(1, 8)
2d0557c5	(Keir Fraser	2009-01-27 16:02:21 +0000	196) /* Page is locked? */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	197)#define _PGT_locked       PG_shift(9)
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	198)#define PGT_locked        PG_mask(1, 9)
a3ec773b	(kaf24@firebug.cl.cam.ac.uk	2005-08-08 08:18:06 +0000	199)
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	200) /* Count of uses of this frame as its current type. */
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	201)#define PGT_count_width   PG_shift(9)
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	202)#define PGT_count_mask    ((1UL<<PGT_count_width)-1)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	203)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	204) /* Cleared when the owning guest 'frees' this page. */
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	205)#define _PGC_allocated    PG_shift(1)
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	206)#define PGC_allocated     PG_mask(1, 1)
f4c0f33f	(Keir Fraser	2009-01-16 15:12:12 +0000	207) /* Page is Xen heap? */
2d0557c5	(Keir Fraser	2009-01-27 16:02:21 +0000	208)#define _PGC_xen_heap     PG_shift(2)
2d0557c5	(Keir Fraser	2009-01-27 16:02:21 +0000	209)#define PGC_xen_heap      PG_mask(1, 2)
49f7c736	(tdeegan@york.uk.xensource.com	2006-08-16 17:02:35 +0100	210) /* Set when is using a page as a page table */
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	211)#define _PGC_page_table   PG_shift(3)
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	212)#define PGC_page_table    PG_mask(1, 3)
55f97f49	(Keir Fraser	2007-11-07 11:44:05 +0000	213) /* 3-bit PAT/PCD/PWT cache-attribute hint. */
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	214)#define PGC_cacheattr_base PG_shift(6)
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	215)#define PGC_cacheattr_mask PG_mask(7, 6)
793c8368	(Keir Fraser	2009-03-12 15:31:36 +0000	216) /* Page is broken? */
4d5b3e46	(Keir Fraser	2009-07-08 16:47:58 +0100	217)#define _PGC_broken       PG_shift(7)
4d5b3e46	(Keir Fraser	2009-07-08 16:47:58 +0100	218)#define PGC_broken        PG_mask(1, 7)
4d5b3e46	(Keir Fraser	2009-07-08 16:47:58 +0100	219) /* Mutually-exclusive page states: { inuse, offlining, offlined, free }. */
4d5b3e46	(Keir Fraser	2009-07-08 16:47:58 +0100	220)#define PGC_state         PG_mask(3, 9)
4d5b3e46	(Keir Fraser	2009-07-08 16:47:58 +0100	221)#define PGC_state_inuse   PG_mask(0, 9)
4d5b3e46	(Keir Fraser	2009-07-08 16:47:58 +0100	222)#define PGC_state_offlining PG_mask(1, 9)
4d5b3e46	(Keir Fraser	2009-07-08 16:47:58 +0100	223)#define PGC_state_offlined PG_mask(2, 9)
4d5b3e46	(Keir Fraser	2009-07-08 16:47:58 +0100	224)#define PGC_state_free    PG_mask(3, 9)
4d5b3e46	(Keir Fraser	2009-07-08 16:47:58 +0100	225)#define page_state_is(pg, st) (((pg)->count_info&PGC_state) == PGC_state_##st)
e4865c23	(Keir Fraser	2009-03-06 19:18:39 +0000	226)
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	227) /* Count of references to this frame. */
e4865c23	(Keir Fraser	2009-03-06 19:18:39 +0000	228)#define PGC_count_width   PG_shift(9)
eb063a09	(Keir Fraser	2009-01-26 16:19:42 +0000	229)#define PGC_count_mask    ((1UL<<PGC_count_width)-1)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	230)
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	231)struct spage_info
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	232){
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	233)       unsigned long type_info;
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	234)};
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	235)
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	236) /* The following page types are MUTUALLY EXCLUSIVE. */
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	237)#define SGT_none          PG_mask(0, 2)  /* superpage not in use */
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	238)#define SGT_mark          PG_mask(1, 2)  /* Marked as a superpage */
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	239)#define SGT_dynamic       PG_mask(2, 2)  /* has been dynamically mapped as a superpage */
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	240)#define SGT_type_mask     PG_mask(3, 2)  /* Bits 30-31 or 62-63. */
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	241)
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	242) /* Count of uses of this superpage as its current type. */
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	243)#define SGT_count_width   PG_shift(3)
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	244)#define SGT_count_mask    ((1UL<<SGT_count_width)-1)
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	245)
f4c0f33f	(Keir Fraser	2009-01-16 15:12:12 +0000	246)#define is_xen_heap_page(page) ((page)->count_info & PGC_xen_heap)
3f441c6c	(Keir Fraser	2009-02-06 11:15:28 +0000	247)#define is_xen_heap_mfn(mfn) \
3f441c6c	(Keir Fraser	2009-02-06 11:15:28 +0000	248)    (__mfn_valid(mfn) && is_xen_heap_page(__mfn_to_page(mfn)))
0409e29e	(Keir Fraser	2009-07-08 22:08:31 +0100	249)#define is_xen_fixed_mfn(mfn)                     \
0409e29e	(Keir Fraser	2009-07-08 22:08:31 +0100	250)    ((((mfn) << PAGE_SHIFT) >= __pa(&_start)) &&  \
0409e29e	(Keir Fraser	2009-07-08 22:08:31 +0100	251)     (((mfn) << PAGE_SHIFT) <= __pa(&_end)))
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	252)
a3ec773b	(kaf24@firebug.cl.cam.ac.uk	2005-08-08 08:18:06 +0000	253)#define PRtype_info "016lx"/* should only be used for printk's */
ee9d4d38	(kaf24@scramble.cl.cam.ac.uk	2005-02-03 14:45:50 +0000	254)
3c7fba7f	(Keir Fraser	2008-06-20 18:39:45 +0100	255)/* The number of out-of-sync shadows we allow per vcpu (prime, please) */
7ee94692	(Keir Fraser	2008-06-20 18:40:32 +0100	256)#define SHADOW_OOS_PAGES 3
7ee94692	(Keir Fraser	2008-06-20 18:40:32 +0100	257)
50b74f55	(Keir Fraser	2008-07-05 14:01:27 +0100	258)/* OOS fixup entries */
50b74f55	(Keir Fraser	2008-07-05 14:01:27 +0100	259)#define SHADOW_OOS_FIXUPS 2
3c7fba7f	(Keir Fraser	2008-06-20 18:39:45 +0100	260)
1d0ec27f	(Keir Fraser	2009-01-28 17:40:01 +0000	261)#define page_get_owner(_p)                                              \
f1e6f665	(Keir Fraser	2009-01-30 11:10:43 +0000	262)    ((struct domain *)((_p)->v.inuse._domain ?                          \
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	263)                       pdx_to_virt((_p)->v.inuse._domain) : NULL))
1d0ec27f	(Keir Fraser	2009-01-28 17:40:01 +0000	264)#define page_set_owner(_p,_d)                                           \
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	265)    ((_p)->v.inuse._domain = (_d) ? virt_to_pdx(_d) : 0)
ee9d4d38	(kaf24@scramble.cl.cam.ac.uk	2005-02-03 14:45:50 +0000	266)
355b0469	(Keir Fraser	2008-07-04 16:27:44 +0100	267)#define maddr_get_owner(ma)   (page_get_owner(maddr_to_page((ma))))
355b0469	(Keir Fraser	2008-07-04 16:27:44 +0100	268)
97e26d34	(kaf24@firebug.cl.cam.ac.uk	2006-03-09 00:45:40 +0100	269)#define XENSHARE_writable 0
97e26d34	(kaf24@firebug.cl.cam.ac.uk	2006-03-09 00:45:40 +0100	270)#define XENSHARE_readonly 1
97e26d34	(kaf24@firebug.cl.cam.ac.uk	2006-03-09 00:45:40 +0100	271)extern void share_xen_page_with_guest(
97e26d34	(kaf24@firebug.cl.cam.ac.uk	2006-03-09 00:45:40 +0100	272)    struct page_info *page, struct domain *d, int readonly);
97e26d34	(kaf24@firebug.cl.cam.ac.uk	2006-03-09 00:45:40 +0100	273)extern void share_xen_page_with_privileged_guests(
97e26d34	(kaf24@firebug.cl.cam.ac.uk	2006-03-09 00:45:40 +0100	274)    struct page_info *page, int readonly);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	275)
494adf9a	(Keir Fraser	2009-09-07 08:41:00 +0100	276)#define frame_table ((struct page_info *)FRAMETABLE_VIRT_START)
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	277)#define spage_table ((struct spage_info *)SPAGETABLE_VIRT_START)
622c5d9e	(Keir Fraser	2010-06-15 13:20:43 +0100	278)int get_superpage(unsigned long mfn, struct domain *d);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	279)extern unsigned long max_page;
8101af54	(kaf24@firebug.cl.cam.ac.uk	2005-10-05 14:06:23 +0100	280)extern unsigned long total_pages;
49f6e16a	(kaf24@scramble.cl.cam.ac.uk	2004-12-30 18:27:27 +0000	281)void init_frametable(void);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	282)
73f01736	(Keir Fraser	2009-09-22 08:18:19 +0100	283)#define PDX_GROUP_COUNT ((1 << L2_PAGETABLE_SHIFT) / \
73f01736	(Keir Fraser	2009-09-22 08:18:19 +0100	284)                         (sizeof(*frame_table) & -sizeof(*frame_table)))
73f01736	(Keir Fraser	2009-09-22 08:18:19 +0100	285)extern unsigned long pdx_group_valid[];
73f01736	(Keir Fraser	2009-09-22 08:18:19 +0100	286)
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	287)/* Convert between Xen-heap virtual addresses and page-info structures. */
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	288)static inline struct page_info *__virt_to_page(const void *v)
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	289){
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	290)    unsigned long va = (unsigned long)v;
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	291)
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	292)    ASSERT(va >= XEN_VIRT_START);
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	293)    ASSERT(va < DIRECTMAP_VIRT_END);
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	294)    if ( va < XEN_VIRT_END )
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	295)        va += DIRECTMAP_VIRT_START - XEN_VIRT_START + xen_phys_start;
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	296)    else
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	297)        ASSERT(va >= DIRECTMAP_VIRT_START);
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	298)    return frame_table + ((va - DIRECTMAP_VIRT_START) >> PAGE_SHIFT);
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	299)}
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	300)
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	301)static inline void *__page_to_virt(const struct page_info *pg)
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	302){
23dbeb5a	(Jan Beulich	2012-12-11 13:47:53 +0100	303)    ASSERT((unsigned long)pg - FRAMETABLE_VIRT_START < FRAMETABLE_SIZE);
aa1c1f4c	(Jan Beulich	2012-09-03 08:17:50 +0200	304)    /*
aa1c1f4c	(Jan Beulich	2012-09-03 08:17:50 +0200	305)     * (sizeof(*pg) & -sizeof(*pg)) selects the LS bit of sizeof(*pg). The
aa1c1f4c	(Jan Beulich	2012-09-03 08:17:50 +0200	306)     * division and re-multiplication avoids one shift when sizeof(*pg) is a
aa1c1f4c	(Jan Beulich	2012-09-03 08:17:50 +0200	307)     * power of two (otherwise there would be a right shift followed by a
aa1c1f4c	(Jan Beulich	2012-09-03 08:17:50 +0200	308)     * left shift, which the compiler can't know it can fold into one).
aa1c1f4c	(Jan Beulich	2012-09-03 08:17:50 +0200	309)     */
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	310)    return (void *)(DIRECTMAP_VIRT_START +
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	311)                    ((unsigned long)pg - FRAMETABLE_VIRT_START) /
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	312)                    (sizeof(*pg) / (sizeof(*pg) & -sizeof(*pg))) *
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	313)                    (PAGE_SIZE / (sizeof(*pg) & -sizeof(*pg))));
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	314)}
bac20000	(Keir Fraser	2009-09-22 08:16:49 +0100	315)
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	316)int free_page_type(struct page_info *page, unsigned long type,
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	317)                   int preemptible);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	318)
02955ee2	(Jan Beulich	2013-01-23 14:09:41 +0100	319)void init_guest_l4_table(l4_pgentry_t[], const struct domain *);
02955ee2	(Jan Beulich	2013-01-23 14:09:41 +0100	320)
55f97f49	(Keir Fraser	2007-11-07 11:44:05 +0000	321)int is_iomem_page(unsigned long mfn);
057b33e4	(Keir Fraser	2007-10-04 10:26:21 +0100	322)
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	323)void clear_superpage_mark(struct page_info *page);
06ef4730	(Keir Fraser	2010-05-27 09:04:46 +0100	324)
db537fe3	(Xudong Hao	2013-03-26 14:22:07 +0100	325)const unsigned long *get_platform_badpages(unsigned int *array_size);
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	326)/* Per page locks:
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	327) * page_lock() is used for two purposes: pte serialization, and memory sharing.
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	328) *
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	329) * All users of page lock for pte serialization live in mm.c, use it
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	330) * to lock a page table page during pte updates, do not take other locks within
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	331) * the critical section delimited by page_lock/unlock, and perform no
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	332) * nesting. 
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	333) *
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	334) * All users of page lock for memory sharing live in mm/mem_sharing.c. Page_lock
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	335) * is used in memory sharing to protect addition (share) and removal (unshare) 
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	336) * of (gfn,domain) tupples to a list of gfn's that the shared page is currently 
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	337) * backing. Nesting may happen when sharing (and locking) two pages -- deadlock 
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	338) * is avoided by locking pages in increasing order.
6b719c3d	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	339) * All memory sharing code paths take the p2m lock of the affected gfn before
6b719c3d	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	340) * taking the lock for the underlying page. We enforce ordering between page_lock 
6b719c3d	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	341) * and p2m_lock using an mm-locks.h construct. 
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	342) *
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	343) * These two users (pte serialization and memory sharing) do not collide, since
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	344) * sharing is only supported for hvm guests, which do not perform pv pte updates.
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	345) * 
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	346) */
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	347)int page_lock(struct page_info *page);
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	348)void page_unlock(struct page_info *page);
6a11f31b	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	349)
ce870565	(Keir Fraser	2009-03-04 14:28:50 +0000	350)struct domain *page_get_owner_and_reference(struct page_info *page);
bc6eac95	(Keir Fraser	2007-12-04 09:56:10 +0000	351)void put_page(struct page_info *page);
bc6eac95	(Keir Fraser	2007-12-04 09:56:10 +0000	352)int  get_page(struct page_info *page, struct domain *domain);
d8b61b1e	(kaf24@firebug.cl.cam.ac.uk	2006-02-01 16:28:50 +0100	353)void put_page_type(struct page_info *page);
d8b61b1e	(kaf24@firebug.cl.cam.ac.uk	2006-02-01 16:28:50 +0100	354)int  get_page_type(struct page_info *page, unsigned long type);
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	355)int  put_page_type_preemptible(struct page_info *page);
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	356)int  get_page_type_preemptible(struct page_info *page, unsigned long type);
9b167bd2	(Jan Beulich	2013-06-26 15:32:58 +0200	357)int  put_old_guest_table(struct vcpu *);
d3c6a215	(Keir Fraser	2009-06-03 14:40:34 +0100	358)int  get_page_from_l1e(
d3c6a215	(Keir Fraser	2009-06-03 14:40:34 +0100	359)    l1_pgentry_t l1e, struct domain *l1e_owner, struct domain *pg_owner);
d3c6a215	(Keir Fraser	2009-06-03 14:40:34 +0100	360)void put_page_from_l1e(l1_pgentry_t l1e, struct domain *l1e_owner);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	361)
d8b61b1e	(kaf24@firebug.cl.cam.ac.uk	2006-02-01 16:28:50 +0100	362)static inline void put_page_and_type(struct page_info *page)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	363){
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	364)    put_page_type(page);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	365)    put_page(page);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	366)}
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	367)
b965b31a	(Jan Beulich	2013-05-02 17:04:14 +0200	368)static inline int put_page_and_type_preemptible(struct page_info *page)
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	369){
b965b31a	(Jan Beulich	2013-05-02 17:04:14 +0200	370)    int rc = put_page_type_preemptible(page);
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	371)
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	372)    if ( likely(rc == 0) )
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	373)        put_page(page);
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	374)    return rc;
76596d0d	(Keir Fraser	2008-09-01 10:52:05 +0100	375)}
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	376)
d8b61b1e	(kaf24@firebug.cl.cam.ac.uk	2006-02-01 16:28:50 +0100	377)static inline int get_page_and_type(struct page_info *page,
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	378)                                    struct domain *domain,
a3ec773b	(kaf24@firebug.cl.cam.ac.uk	2005-08-08 08:18:06 +0000	379)                                    unsigned long type)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	380){
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	381)    int rc = get_page(page, domain);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	382)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	383)    if ( likely(rc) && unlikely(!get_page_type(page, type)) )
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	384)    {
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	385)        put_page(page);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	386)        rc = 0;
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	387)    }
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	388)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	389)    return rc;
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	390)}
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	391)
2e4b001d	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 19:37:36 +0000	392)#define ASSERT_PAGE_IS_TYPE(_p, _t)                            \
2e4b001d	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 19:37:36 +0000	393)    ASSERT(((_p)->u.inuse.type_info & PGT_type_mask) == (_t)); \
f3b57d09	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 13:40:31 +0000	394)    ASSERT(((_p)->u.inuse.type_info & PGT_count_mask) != 0)
2e4b001d	(kaf24@scramble.cl.cam.ac.uk	2004-07-27 19:37:36 +0000	395)#define ASSERT_PAGE_IS_DOMAIN(_p, _d)                          \
4f766bc8	(kaf24@labyrinth.cl.cam.ac.uk	2004-08-25 16:26:15 +0000	396)    ASSERT(((_p)->count_info & PGC_count_mask) != 0);          \
ee9d4d38	(kaf24@scramble.cl.cam.ac.uk	2005-02-03 14:45:50 +0000	397)    ASSERT(page_get_owner(_p) == (_d))
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	398)
8f2348c0	(Emmanuel Ackaouy	2007-01-05 17:32:00 +0000	399)int check_descriptor(const struct domain *, struct desc_struct *d);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	400)
5814ca6b	(Keir Fraser	2010-12-24 10:10:45 +0000	401)extern bool_t opt_allow_superpage;
5814ca6b	(Keir Fraser	2010-12-24 10:10:45 +0000	402)extern bool_t mem_hotplug;
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	403)
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	404)/******************************************************************************
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	405) * With shadow pagetables, the different kinds of address start 
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	406) * to get get confusing.
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	407) * 
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	408) * Virtual addresses are what they usually are: the addresses that are used 
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	409) * to accessing memory while the guest is running.  The MMU translates from 
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	410) * virtual addresses to machine addresses. 
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	411) * 
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	412) * (Pseudo-)physical addresses are the abstraction of physical memory the
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	413) * guest uses for allocation and so forth.  For the purposes of this code, 
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	414) * we can largely ignore them.
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	415) *
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	416) * Guest frame numbers (gfns) are the entries that the guest puts in its
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	417) * pagetables.  For normal paravirtual guests, they are actual frame numbers,
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	418) * with the translation done by the guest.  
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	419) * 
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	420) * Machine frame numbers (mfns) are the entries that the hypervisor puts
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	421) * in the shadow page tables.
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	422) *
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	423) * Elsewhere in the xen code base, the name "gmfn" is generally used to refer
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	424) * to a "machine frame number, from the guest's perspective", or in other
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	425) * words, pseudo-physical frame numbers.  However, in the shadow code, the
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	426) * term "gmfn" means "the mfn of a guest page"; this combines naturally with
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	427) * other terms such as "smfn" (the mfn of a shadow page), gl2mfn (the mfn of a
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	428) * guest L2 page), etc...
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	429) */
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	430)
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	431)/* With this defined, we do some ugly things to force the compiler to
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	432) * give us type safety between mfns and gfns and other integers.
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	433) * TYPE_SAFE(int foo) defines a foo_t, and _foo() and foo_x() functions 
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	434) * that translate beween int and foo_t.
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	435) * 
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	436) * It does have some performance cost because the types now have 
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	437) * a different storage attribute, so may not want it on all the time. */
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	438)
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	439)#ifndef NDEBUG
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	440)#define TYPE_SAFETY 1
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	441)#endif
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	442)
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	443)#ifdef TYPE_SAFETY
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	444)#define TYPE_SAFE(_type,_name)                                  \
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	445)typedef struct { _type _name; } _name##_t;                      \
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	446)static inline _name##_t _##_name(_type n) { return (_name##_t) { n }; } \
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	447)static inline _type _name##_x(_name##_t n) { return n._name; }
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	448)#else
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	449)#define TYPE_SAFE(_type,_name)                                          \
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	450)typedef _type _name##_t;                                                \
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	451)static inline _name##_t _##_name(_type n) { return n; }                 \
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	452)static inline _type _name##_x(_name##_t n) { return n; }
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	453)#endif
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	454)
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	455)TYPE_SAFE(unsigned long,mfn);
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	456)
9f1cbc33	(Tim Deegan	2012-11-29 10:49:53 +0000	457)#ifndef mfn_t
9f1cbc33	(Tim Deegan	2012-11-29 10:49:53 +0000	458)#define mfn_t /* Grep fodder: mfn_t, _mfn() and mfn_x() are defined above */
9f1cbc33	(Tim Deegan	2012-11-29 10:49:53 +0000	459)#undef mfn_t
9f1cbc33	(Tim Deegan	2012-11-29 10:49:53 +0000	460)#endif
9f1cbc33	(Tim Deegan	2012-11-29 10:49:53 +0000	461)
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	462)/* Macro for printk formats: use as printk("%"PRI_mfn"\n", mfn_x(foo)); */
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	463)#define PRI_mfn "05lx"
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	464)
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	465)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	466)/*
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	467) * The MPT (machine->physical mapping table) is an array of word-sized
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	468) * values, indexed on machine frame number. It is expected that guest OSes
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	469) * will use it to store a "physical" frame number to give the appearance of
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	470) * contiguous (or near contiguous) physical memory.
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	471) */
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	472)#undef  machine_to_phys_mapping
d22c0aa8	(kaf24@firebug.cl.cam.ac.uk	2005-09-06 18:01:24 +0000	473)#define machine_to_phys_mapping  ((unsigned long *)RDWR_MPT_VIRT_START)
d22c0aa8	(kaf24@firebug.cl.cam.ac.uk	2005-09-06 18:01:24 +0000	474)#define INVALID_M2P_ENTRY        (~0UL)
d22c0aa8	(kaf24@firebug.cl.cam.ac.uk	2005-09-06 18:01:24 +0000	475)#define VALID_M2P(_e)            (!((_e) & (1UL<<(BITS_PER_LONG-1))))
af909e7e	(Keir Fraser	2009-12-17 06:27:56 +0000	476)#define SHARED_M2P_ENTRY         (~0UL - 1UL)
af909e7e	(Keir Fraser	2009-12-17 06:27:56 +0000	477)#define SHARED_M2P(_e)           ((_e) == SHARED_M2P_ENTRY)
2ad97141	(kaf24@pb001.cl.cam.ac.uk	2004-12-16 15:41:47 +0000	478)
cb44adae	(Emmanuel Ackaouy	2007-01-05 17:34:30 +0000	479)#define compat_machine_to_phys_mapping ((unsigned int *)RDWR_COMPAT_MPT_VIRT_START)
922626d2	(Keir Fraser	2011-06-10 08:18:33 +0100	480)#define _set_gpfn_from_mfn(mfn, pfn) ({                        \
af909e7e	(Keir Fraser	2009-12-17 06:27:56 +0000	481)    struct domain *d = page_get_owner(__mfn_to_page(mfn));     \
af909e7e	(Keir Fraser	2009-12-17 06:27:56 +0000	482)    unsigned long entry = (d && (d == dom_cow)) ?              \
af909e7e	(Keir Fraser	2009-12-17 06:27:56 +0000	483)        SHARED_M2P_ENTRY : (pfn);                              \
6df62804	(kfraser@localhost.localdomain	2007-07-09 14:06:22 +0100	484)    ((void)((mfn) >= (RDWR_COMPAT_MPT_VIRT_END - RDWR_COMPAT_MPT_VIRT_START) / 4 || \
af909e7e	(Keir Fraser	2009-12-17 06:27:56 +0000	485)            (compat_machine_to_phys_mapping[(mfn)] = (unsigned int)(entry))), \
af909e7e	(Keir Fraser	2009-12-17 06:27:56 +0000	486)     machine_to_phys_mapping[(mfn)] = (entry));                \
af909e7e	(Keir Fraser	2009-12-17 06:27:56 +0000	487)    })
922626d2	(Keir Fraser	2011-06-10 08:18:33 +0100	488)
922626d2	(Keir Fraser	2011-06-10 08:18:33 +0100	489)/*
922626d2	(Keir Fraser	2011-06-10 08:18:33 +0100	490) * Disable some users of set_gpfn_from_mfn() (e.g., free_heap_pages()) until
922626d2	(Keir Fraser	2011-06-10 08:18:33 +0100	491) * the machine_to_phys_mapping is actually set up.
922626d2	(Keir Fraser	2011-06-10 08:18:33 +0100	492) */
922626d2	(Keir Fraser	2011-06-10 08:18:33 +0100	493)extern bool_t machine_to_phys_mapping_valid;
922626d2	(Keir Fraser	2011-06-10 08:18:33 +0100	494)#define set_gpfn_from_mfn(mfn, pfn) do {        \
922626d2	(Keir Fraser	2011-06-10 08:18:33 +0100	495)    if ( machine_to_phys_mapping_valid )        \
922626d2	(Keir Fraser	2011-06-10 08:18:33 +0100	496)        _set_gpfn_from_mfn(mfn, pfn);           \
922626d2	(Keir Fraser	2011-06-10 08:18:33 +0100	497)} while (0)
922626d2	(Keir Fraser	2011-06-10 08:18:33 +0100	498)
d1222afd	(Jan Beulich	2013-05-02 16:46:02 +0200	499)extern struct rangeset *mmio_ro_ranges;
d1222afd	(Jan Beulich	2013-05-02 16:46:02 +0200	500)
b2572e06	(kaf24@firebug.cl.cam.ac.uk	2006-02-02 12:18:28 +0100	501)#define get_gpfn_from_mfn(mfn)      (machine_to_phys_mapping[(mfn)])
0e0f890e	(kaf24@firebug.cl.cam.ac.uk	2005-08-30 17:53:49 +0000	502)
49f7c736	(tdeegan@york.uk.xensource.com	2006-08-16 17:02:35 +0100	503)#define mfn_to_gmfn(_d, mfn)                            \
22d7d00f	(Tim Deegan	2007-02-14 12:02:20 +0000	504)    ( (paging_mode_translate(_d))                       \
49f7c736	(tdeegan@york.uk.xensource.com	2006-08-16 17:02:35 +0100	505)      ? get_gpfn_from_mfn(mfn)                          \
49f7c736	(tdeegan@york.uk.xensource.com	2006-08-16 17:02:35 +0100	506)      : (mfn) )
49f7c736	(tdeegan@york.uk.xensource.com	2006-08-16 17:02:35 +0100	507)
0e0f890e	(kaf24@firebug.cl.cam.ac.uk	2005-08-30 17:53:49 +0000	508)#define INVALID_MFN             (~0UL)
2f32a808	(kaf24@scramble.cl.cam.ac.uk	2005-01-21 18:43:08 +0000	509)
8d6e195a	(Emmanuel Ackaouy	2007-01-05 17:34:30 +0000	510)#define compat_pfn_to_cr3(pfn) (((unsigned)(pfn) << 12) | ((unsigned)(pfn) >> 20))
8d6e195a	(Emmanuel Ackaouy	2007-01-05 17:34:30 +0000	511)#define compat_cr3_to_pfn(cr3) (((unsigned)(cr3) >> 12) | ((unsigned)(cr3) << 20))
8d6e195a	(Emmanuel Ackaouy	2007-01-05 17:34:30 +0000	512)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	513)#ifdef MEMORY_GUARD
c17b1a48	(kaf24@firebug.cl.cam.ac.uk	2005-05-19 12:36:18 +0000	514)void memguard_init(void);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	515)void memguard_guard_range(void *p, unsigned long l);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	516)void memguard_unguard_range(void *p, unsigned long l);
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	517)#else
c17b1a48	(kaf24@firebug.cl.cam.ac.uk	2005-05-19 12:36:18 +0000	518)#define memguard_init()                ((void)0)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	519)#define memguard_guard_range(_p,_l)    ((void)0)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	520)#define memguard_unguard_range(_p,_l)  ((void)0)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	521)#endif
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	522)
c17b1a48	(kaf24@firebug.cl.cam.ac.uk	2005-05-19 12:36:18 +0000	523)void memguard_guard_stack(void *p);
c12bbde8	(Keir Fraser	2010-05-18 15:05:54 +0100	524)void memguard_unguard_stack(void *p);
c17b1a48	(kaf24@firebug.cl.cam.ac.uk	2005-05-19 12:36:18 +0000	525)
5d0d3260	(Tim Deegan	2006-09-28 17:10:54 +0100	526)int  ptwr_do_page_fault(struct vcpu *, unsigned long,
e5302714	(kaf24@firebug.cl.cam.ac.uk	2005-12-11 00:16:26 +0100	527)                        struct cpu_user_regs *);
56b3130c	(Jan Beulich	2012-06-22 13:43:00 +0200	528)int  mmio_ro_do_page_fault(struct vcpu *, unsigned long,
56b3130c	(Jan Beulich	2012-06-22 13:43:00 +0200	529)                           struct cpu_user_regs *);
5e09eaa6	(kaf24@scramble.cl.cam.ac.uk	2005-01-11 11:41:56 +0000	530)
0150d071	(mafetter@fleming.research	2005-03-14 22:07:47 +0000	531)int audit_adjust_pgtables(struct domain *d, int dir, int noisy);
0150d071	(mafetter@fleming.research	2005-03-14 22:07:47 +0000	532)
74168b70	(Keir Fraser	2009-12-11 08:56:50 +0000	533)extern int pagefault_by_memadd(unsigned long addr, struct cpu_user_regs *regs);
74168b70	(Keir Fraser	2009-12-11 08:56:50 +0000	534)extern int handle_memadd_fault(unsigned long addr, struct cpu_user_regs *regs);
74168b70	(Keir Fraser	2009-12-11 08:56:50 +0000	535)
c4625ecc	(kaf24@freefall.cl.cam.ac.uk	2004-10-05 14:30:11 +0000	536)#ifndef NDEBUG
0150d071	(mafetter@fleming.research	2005-03-14 22:07:47 +0000	537)
33ea028e	(mafetter@fleming.research	2005-05-09 13:22:13 +0000	538)#define AUDIT_SHADOW_ALREADY_LOCKED ( 1u << 0 )
33ea028e	(mafetter@fleming.research	2005-05-09 13:22:13 +0000	539)#define AUDIT_ERRORS_OK             ( 1u << 1 )
33ea028e	(mafetter@fleming.research	2005-05-09 13:22:13 +0000	540)#define AUDIT_QUIET                 ( 1u << 2 )
0150d071	(mafetter@fleming.research	2005-03-14 22:07:47 +0000	541)
80a9af64	(mafetter@fleming.research	2005-03-17 12:25:14 +0000	542)void _audit_domain(struct domain *d, int flags);
e98c20f1	(iap10@freefall.cl.cam.ac.uk	2005-04-19 15:18:24 +0000	543)#define audit_domain(_d) _audit_domain((_d), AUDIT_ERRORS_OK)
c4625ecc	(kaf24@freefall.cl.cam.ac.uk	2004-10-05 14:30:11 +0000	544)void audit_domains(void);
0150d071	(mafetter@fleming.research	2005-03-14 22:07:47 +0000	545)
c4625ecc	(kaf24@freefall.cl.cam.ac.uk	2004-10-05 14:30:11 +0000	546)#else
0150d071	(mafetter@fleming.research	2005-03-14 22:07:47 +0000	547)
80a9af64	(mafetter@fleming.research	2005-03-17 12:25:14 +0000	548)#define _audit_domain(_d, _f) ((void)0)
80a9af64	(mafetter@fleming.research	2005-03-17 12:25:14 +0000	549)#define audit_domain(_d)      ((void)0)
80a9af64	(mafetter@fleming.research	2005-03-17 12:25:14 +0000	550)#define audit_domains()       ((void)0)
c4625ecc	(kaf24@freefall.cl.cam.ac.uk	2004-10-05 14:30:11 +0000	551)
0150d071	(mafetter@fleming.research	2005-03-14 22:07:47 +0000	552)#endif
a880f7f4	(kaf24@scramble.cl.cam.ac.uk	2005-01-12 14:17:52 +0000	553)
275ad12c	(kaf24@firebug.cl.cam.ac.uk	2005-04-04 16:09:46 +0000	554)int new_guest_cr3(unsigned long pfn);
49f7c736	(tdeegan@york.uk.xensource.com	2006-08-16 17:02:35 +0100	555)void make_cr3(struct vcpu *v, unsigned long mfn);
1128c254	(Tim Deegan	2006-12-20 12:03:07 +0000	556)void update_cr3(struct vcpu *v);
4939f9a6	(Jan Beulich	2013-05-02 16:37:24 +0200	557)int vcpu_destroy_pagetables(struct vcpu *);
a880f7f4	(kaf24@scramble.cl.cam.ac.uk	2005-01-12 14:17:52 +0000	558)void propagate_page_fault(unsigned long addr, u16 error_code);
cc0de53a	(Keir Fraser	2009-06-16 13:57:18 +0100	559)void *do_page_walk(struct vcpu *v, unsigned long addr);
a880f7f4	(kaf24@scramble.cl.cam.ac.uk	2005-01-12 14:17:52 +0000	560)
6de4ee40	(Keir Fraser	2010-04-19 17:57:28 +0100	561)int __sync_local_execstate(void);
83120737	(kaf24@firebug.cl.cam.ac.uk	2005-11-25 18:43:35 +0100	562)
83120737	(kaf24@firebug.cl.cam.ac.uk	2005-11-25 18:43:35 +0100	563)/* Arch-specific portion of memory_op hypercall. */
e7a527e1	(Stefano Stabellini	2012-10-17 16:43:53 +0100	564)long arch_memory_op(int op, XEN_GUEST_HANDLE_PARAM(void) arg);
e7a527e1	(Stefano Stabellini	2012-10-17 16:43:53 +0100	565)long subarch_memory_op(int op, XEN_GUEST_HANDLE_PARAM(void) arg);
e7a527e1	(Stefano Stabellini	2012-10-17 16:43:53 +0100	566)int compat_arch_memory_op(int op, XEN_GUEST_HANDLE_PARAM(void));
e7a527e1	(Stefano Stabellini	2012-10-17 16:43:53 +0100	567)int compat_subarch_memory_op(int op, XEN_GUEST_HANDLE_PARAM(void));
4fb2acfb	(kaf24@firebug.cl.cam.ac.uk	2005-08-26 09:29:54 +0000	568)
516250da	(kfraser@dhcp93.uk.xensource.com	2006-06-16 14:43:54 +0100	569)int steal_page(
516250da	(kfraser@dhcp93.uk.xensource.com	2006-06-16 14:43:54 +0100	570)    struct domain *d, struct page_info *page, unsigned int memflags);
6009f4dd	(Keir Fraser	2009-05-26 11:05:04 +0100	571)int donate_page(
6009f4dd	(Keir Fraser	2009-05-26 11:05:04 +0100	572)    struct domain *d, struct page_info *page, unsigned int memflags);
516250da	(kfraser@dhcp93.uk.xensource.com	2006-06-16 14:43:54 +0100	573)
3203345b	(kaf24@localhost.localdomain	2006-11-04 19:26:29 +0000	574)int map_ldt_shadow_page(unsigned int);
3203345b	(kaf24@localhost.localdomain	2006-11-04 19:26:29 +0000	575)
50ae2d0c	(   Xi Wang	2013-03-15 10:26:17 +0100	576)#define NIL(type) ((type *)-sizeof(type))
50ae2d0c	(   Xi Wang	2013-03-15 10:26:17 +0100	577)#define IS_NIL(ptr) (!((uintptr_t)(ptr) + sizeof(*(ptr))))
703ac3ab	(Jan Beulich	2013-02-28 11:08:13 +0100	578)
703ac3ab	(Jan Beulich	2013-02-28 11:08:13 +0100	579)int create_perdomain_mapping(struct domain *, unsigned long va,
703ac3ab	(Jan Beulich	2013-02-28 11:08:13 +0100	580)                             unsigned int nr, l1_pgentry_t **,
703ac3ab	(Jan Beulich	2013-02-28 11:08:13 +0100	581)                             struct page_info **);
8db1e759	(Jan Beulich	2013-02-28 11:09:39 +0100	582)void destroy_perdomain_mapping(struct domain *, unsigned long va,
8db1e759	(Jan Beulich	2013-02-28 11:09:39 +0100	583)                               unsigned int nr);
703ac3ab	(Jan Beulich	2013-02-28 11:08:13 +0100	584)void free_perdomain_mappings(struct domain *);
703ac3ab	(Jan Beulich	2013-02-28 11:08:13 +0100	585)
e898e6e2	(Keir Fraser	2009-12-11 08:58:06 +0000	586)extern int memory_add(unsigned long spfn, unsigned long epfn, unsigned int pxm);
e898e6e2	(Keir Fraser	2009-12-11 08:58:06 +0000	587)
aa6bc4f3	(Keir Fraser	2008-06-12 16:05:35 +0100	588)void domain_set_alloc_bitsize(struct domain *d);
83ac3090	(Keir Fraser	2007-02-24 13:57:34 +0000	589)unsigned int domain_clamp_alloc_bitsize(struct domain *d, unsigned int bits);
b8a7efe8	(Emmanuel Ackaouy	2007-01-05 17:34:31 +0000	590)
28f7888d	(kfraser@localhost.localdomain	2007-03-19 16:48:24 +0000	591)unsigned long domain_get_maximum_gpfn(struct domain *d);
83ac3090	(Keir Fraser	2007-02-24 13:57:34 +0000	592)
762e791d	(Tim Deegan	2012-03-08 16:40:05 +0000	593)void mem_event_cleanup(struct domain *d);
762e791d	(Tim Deegan	2012-03-08 16:40:05 +0000	594)
38edca18	(Keir Fraser	2009-12-17 06:27:56 +0000	595)extern struct domain *dom_xen, *dom_io, *dom_cow;	/* for vmcoreinfo */
65ce603c	(Keir Fraser	2008-06-13 09:54:03 +0100	596)
301493fb	(Tim Deegan	2011-06-02 13:16:52 +0100	597)/* Definition of an mm lock: spinlock with extra fields for debugging */
301493fb	(Tim Deegan	2011-06-02 13:16:52 +0100	598)typedef struct mm_lock {
301493fb	(Tim Deegan	2011-06-02 13:16:52 +0100	599)    spinlock_t         lock; 
301493fb	(Tim Deegan	2011-06-02 13:16:52 +0100	600)    int                unlock_level;
301493fb	(Tim Deegan	2011-06-02 13:16:52 +0100	601)    int                locker;          /* processor which holds the lock */
301493fb	(Tim Deegan	2011-06-02 13:16:52 +0100	602)    const char        *locker_function; /* func that took it */
301493fb	(Tim Deegan	2011-06-02 13:16:52 +0100	603)} mm_lock_t;
301493fb	(Tim Deegan	2011-06-02 13:16:52 +0100	604)
8c160c6e	(Tim Deegan	2012-05-17 10:24:53 +0100	605)typedef struct mm_rwlock {
8c160c6e	(Tim Deegan	2012-05-17 10:24:53 +0100	606)    rwlock_t           lock;
8c160c6e	(Tim Deegan	2012-05-17 10:24:53 +0100	607)    int                unlock_level;
8c160c6e	(Tim Deegan	2012-05-17 10:24:53 +0100	608)    int                recurse_count;
8c160c6e	(Tim Deegan	2012-05-17 10:24:53 +0100	609)    int                locker; /* CPU that holds the write lock */
8c160c6e	(Tim Deegan	2012-05-17 10:24:53 +0100	610)    const char        *locker_function; /* func that took it */
8c160c6e	(Tim Deegan	2012-05-17 10:24:53 +0100	611)} mm_rwlock_t;
8c160c6e	(Tim Deegan	2012-05-17 10:24:53 +0100	612)
08aed499	(djm@kirby.fc.hp.com	2004-07-07 16:39:51 +0000	613)#endif /* __ASM_X86_MM_H__ */
