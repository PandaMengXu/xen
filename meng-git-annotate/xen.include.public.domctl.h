1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1)/******************************************************************************
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	2) * domctl.h
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	3) * 
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	4) * Domain management operations. For use by node control stack.
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	5) * 
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	6) * Permission is hereby granted, free of charge, to any person obtaining a copy
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	7) * of this software and associated documentation files (the "Software"), to
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	8) * deal in the Software without restriction, including without limitation the
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	9) * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	10) * sell copies of the Software, and to permit persons to whom the Software is
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	11) * furnished to do so, subject to the following conditions:
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	12) *
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	13) * The above copyright notice and this permission notice shall be included in
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	14) * all copies or substantial portions of the Software.
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	15) *
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	16) * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	17) * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	18) * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	19) * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	20) * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	21) * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	22) * DEALINGS IN THE SOFTWARE.
1cbd4a63	(kaf24@localhost.localdomain	2006-11-08 00:03:11 +0000	23) *
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	24) * Copyright (c) 2002-2003, B Dragovic
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	25) * Copyright (c) 2002-2006, K Fraser
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	26) */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	27)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	28)#ifndef __XEN_PUBLIC_DOMCTL_H__
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	29)#define __XEN_PUBLIC_DOMCTL_H__
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	30)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	31)#if !defined(__XEN__) && !defined(__XEN_TOOLS__)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	32)#error "domctl operations are intended for use by node control tools only"
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	33)#endif
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	34)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	35)#include "xen.h"
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	36)#include "grant_table.h"
5a3be935	(Jan Beulich	2012-10-04 17:11:25 +0200	37)#include "hvm/save.h"
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	38)
65c9792d	(Dan Magenheimer	2013-03-11 16:13:42 +0000	39)#define XEN_DOMCTL_INTERFACE_VERSION 0x00000009
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	40)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	41)/*
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	42) * NB. xen_domctl.domain is an IN/OUT parameter for this operation.
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	43) * If it is specified as zero, an id is auto-allocated and returned.
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	44) */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	45)/* XEN_DOMCTL_createdomain */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	46)struct xen_domctl_createdomain {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	47)    /* IN parameters */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	48)    uint32_t ssidref;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	49)    xen_domain_handle_t handle;
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	50) /* Is this an HVM guest (as opposed to a PV guest)? */
8aaf8706	(Keir Fraser	2009-03-03 11:52:44 +0000	51)#define _XEN_DOMCTL_CDF_hvm_guest     0
8aaf8706	(Keir Fraser	2009-03-03 11:52:44 +0000	52)#define XEN_DOMCTL_CDF_hvm_guest      (1U<<_XEN_DOMCTL_CDF_hvm_guest)
e0979793	(Keir Fraser	2008-01-29 13:46:16 +0000	53) /* Use hardware-assisted paging if available? */
8aaf8706	(Keir Fraser	2009-03-03 11:52:44 +0000	54)#define _XEN_DOMCTL_CDF_hap           1
8aaf8706	(Keir Fraser	2009-03-03 11:52:44 +0000	55)#define XEN_DOMCTL_CDF_hap            (1U<<_XEN_DOMCTL_CDF_hap)
8aaf8706	(Keir Fraser	2009-03-03 11:52:44 +0000	56) /* Should domain memory integrity be verifed by tboot during Sx? */
8aaf8706	(Keir Fraser	2009-03-03 11:52:44 +0000	57)#define _XEN_DOMCTL_CDF_s3_integrity  2
8aaf8706	(Keir Fraser	2009-03-03 11:52:44 +0000	58)#define XEN_DOMCTL_CDF_s3_integrity   (1U<<_XEN_DOMCTL_CDF_s3_integrity)
90abd243	(Keir Fraser	2009-10-19 10:55:46 +0100	59) /* Disable out-of-sync shadow page tables? */
90abd243	(Keir Fraser	2009-10-19 10:55:46 +0100	60)#define _XEN_DOMCTL_CDF_oos_off       3
90abd243	(Keir Fraser	2009-10-19 10:55:46 +0100	61)#define XEN_DOMCTL_CDF_oos_off        (1U<<_XEN_DOMCTL_CDF_oos_off)
78be3dbb	(Keir Fraser	2010-04-21 12:48:03 +0100	62)    uint32_t flags;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	63)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	64)typedef struct xen_domctl_createdomain xen_domctl_createdomain_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	65)DEFINE_XEN_GUEST_HANDLE(xen_domctl_createdomain_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	66)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	67)/* XEN_DOMCTL_getdomaininfo */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	68)struct xen_domctl_getdomaininfo {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	69)    /* OUT variables. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	70)    domid_t  domain;              /* Also echoed in domctl.domain */
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	71) /* Domain is scheduled to die. */
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	72)#define _XEN_DOMINF_dying     0
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	73)#define XEN_DOMINF_dying      (1U<<_XEN_DOMINF_dying)
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	74) /* Domain is an HVM guest (as opposed to a PV guest). */
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	75)#define _XEN_DOMINF_hvm_guest 1
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	76)#define XEN_DOMINF_hvm_guest  (1U<<_XEN_DOMINF_hvm_guest)
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	77) /* The guest OS has shut down. */
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	78)#define _XEN_DOMINF_shutdown  2
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	79)#define XEN_DOMINF_shutdown   (1U<<_XEN_DOMINF_shutdown)
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	80) /* Currently paused by control software. */
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	81)#define _XEN_DOMINF_paused    3
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	82)#define XEN_DOMINF_paused     (1U<<_XEN_DOMINF_paused)
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	83) /* Currently blocked pending an event.     */
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	84)#define _XEN_DOMINF_blocked   4
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	85)#define XEN_DOMINF_blocked    (1U<<_XEN_DOMINF_blocked)
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	86) /* Domain is currently running.            */
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	87)#define _XEN_DOMINF_running   5
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	88)#define XEN_DOMINF_running    (1U<<_XEN_DOMINF_running)
ac9fcaa9	(kfraser@localhost.localdomain	2007-07-06 14:42:55 +0100	89) /* Being debugged.  */
ac9fcaa9	(kfraser@localhost.localdomain	2007-07-06 14:42:55 +0100	90)#define _XEN_DOMINF_debugged  6
ac9fcaa9	(kfraser@localhost.localdomain	2007-07-06 14:42:55 +0100	91)#define XEN_DOMINF_debugged   (1U<<_XEN_DOMINF_debugged)
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	92) /* XEN_DOMINF_shutdown guest-supplied code.  */
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	93)#define XEN_DOMINF_shutdownmask 255
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	94)#define XEN_DOMINF_shutdownshift 16
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	95)    uint32_t flags;              /* XEN_DOMINF_* */
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	96)    uint64_aligned_t tot_pages;
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	97)    uint64_aligned_t max_pages;
65c9792d	(Dan Magenheimer	2013-03-11 16:13:42 +0000	98)    uint64_aligned_t outstanding_pages;
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	99)    uint64_aligned_t shr_pages;
47e2593c	(Olaf Hering	2011-09-26 22:19:42 +0100	100)    uint64_aligned_t paged_pages;
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	101)    uint64_aligned_t shared_info_frame; /* GMFN of shared_info struct */
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	102)    uint64_aligned_t cpu_time;
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	103)    uint32_t nr_online_vcpus;    /* Number of VCPUs currently online. */
457ee10d	(kfraser@localhost.localdomain	2006-11-03 10:52:29 +0000	104)    uint32_t max_vcpu_id;        /* Maximum VCPUID in use by this domain. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	105)    uint32_t ssidref;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	106)    xen_domain_handle_t handle;
78be3dbb	(Keir Fraser	2010-04-21 12:48:03 +0100	107)    uint32_t cpupool;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	108)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	109)typedef struct xen_domctl_getdomaininfo xen_domctl_getdomaininfo_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	110)DEFINE_XEN_GUEST_HANDLE(xen_domctl_getdomaininfo_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	111)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	112)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	113)/* XEN_DOMCTL_getmemlist */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	114)struct xen_domctl_getmemlist {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	115)    /* IN variables. */
d96c9af4	(kaf24@firebug.cl.cam.ac.uk	2006-08-30 18:19:04 +0100	116)    /* Max entries to write to output buffer. */
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	117)    uint64_aligned_t max_pfns;
d96c9af4	(kaf24@firebug.cl.cam.ac.uk	2006-08-30 18:19:04 +0100	118)    /* Start index in guest's page list. */
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	119)    uint64_aligned_t start_pfn;
28cba610	(Keir Fraser	2007-12-28 15:44:51 +0000	120)    XEN_GUEST_HANDLE_64(uint64) buffer;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	121)    /* OUT variables. */
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	122)    uint64_aligned_t num_pfns;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	123)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	124)typedef struct xen_domctl_getmemlist xen_domctl_getmemlist_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	125)DEFINE_XEN_GUEST_HANDLE(xen_domctl_getmemlist_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	126)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	127)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	128)/* XEN_DOMCTL_getpageframeinfo */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	129)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	130)#define XEN_DOMCTL_PFINFO_LTAB_SHIFT 28
46c6d82a	(Keir Fraser	2007-04-09 11:12:15 +0100	131)#define XEN_DOMCTL_PFINFO_NOTAB   (0x0U<<28)
46c6d82a	(Keir Fraser	2007-04-09 11:12:15 +0100	132)#define XEN_DOMCTL_PFINFO_L1TAB   (0x1U<<28)
46c6d82a	(Keir Fraser	2007-04-09 11:12:15 +0100	133)#define XEN_DOMCTL_PFINFO_L2TAB   (0x2U<<28)
46c6d82a	(Keir Fraser	2007-04-09 11:12:15 +0100	134)#define XEN_DOMCTL_PFINFO_L3TAB   (0x3U<<28)
46c6d82a	(Keir Fraser	2007-04-09 11:12:15 +0100	135)#define XEN_DOMCTL_PFINFO_L4TAB   (0x4U<<28)
46c6d82a	(Keir Fraser	2007-04-09 11:12:15 +0100	136)#define XEN_DOMCTL_PFINFO_LTABTYPE_MASK (0x7U<<28)
46c6d82a	(Keir Fraser	2007-04-09 11:12:15 +0100	137)#define XEN_DOMCTL_PFINFO_LPINTAB (0x1U<<31)
46c6d82a	(Keir Fraser	2007-04-09 11:12:15 +0100	138)#define XEN_DOMCTL_PFINFO_XTAB    (0xfU<<28) /* invalid page */
f35c8f68	(George Dunlap	2011-05-26 15:27:33 +0100	139)#define XEN_DOMCTL_PFINFO_XALLOC  (0xeU<<28) /* allocate-only page */
b7a98e60	(Liu Jinsong	2012-12-06 10:47:22 +0000	140)#define XEN_DOMCTL_PFINFO_BROKEN  (0xdU<<28) /* broken page */
46c6d82a	(Keir Fraser	2007-04-09 11:12:15 +0100	141)#define XEN_DOMCTL_PFINFO_LTAB_MASK (0xfU<<28)
83593d85	(      root	2014-01-03 13:10:38 -0500	142)#define XEN_DOMCTL_PFINFO_INUSE   (0x1U<<31) /* Meng: page is in use */
83593d85	(      root	2014-01-03 13:10:38 -0500	143)#define XEN_DOMCTL_PFINFO_LTAB_INUSE_MASK (0xf8UL<<24) /* Meng: use A32 as inuse bit*/
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	144)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	145)struct xen_domctl_getpageframeinfo {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	146)    /* IN variables. */
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	147)    uint64_aligned_t gmfn; /* GMFN to query */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	148)    /* OUT variables. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	149)    /* Is the page PINNED to a type? */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	150)    uint32_t type;         /* see above type defs */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	151)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	152)typedef struct xen_domctl_getpageframeinfo xen_domctl_getpageframeinfo_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	153)DEFINE_XEN_GUEST_HANDLE(xen_domctl_getpageframeinfo_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	154)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	155)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	156)/* XEN_DOMCTL_getpageframeinfo2 */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	157)struct xen_domctl_getpageframeinfo2 {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	158)    /* IN variables. */
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	159)    uint64_aligned_t num;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	160)    /* IN/OUT variables. */
28cba610	(Keir Fraser	2007-12-28 15:44:51 +0000	161)    XEN_GUEST_HANDLE_64(uint32) array;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	162)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	163)typedef struct xen_domctl_getpageframeinfo2 xen_domctl_getpageframeinfo2_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	164)DEFINE_XEN_GUEST_HANDLE(xen_domctl_getpageframeinfo2_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	165)
b3eb2c1e	(Keir Fraser	2010-01-13 08:14:01 +0000	166)/* XEN_DOMCTL_getpageframeinfo3 */
b3eb2c1e	(Keir Fraser	2010-01-13 08:14:01 +0000	167)struct xen_domctl_getpageframeinfo3 {
b3eb2c1e	(Keir Fraser	2010-01-13 08:14:01 +0000	168)    /* IN variables. */
b3eb2c1e	(Keir Fraser	2010-01-13 08:14:01 +0000	169)    uint64_aligned_t num;
b3eb2c1e	(Keir Fraser	2010-01-13 08:14:01 +0000	170)    /* IN/OUT variables. */
b3eb2c1e	(Keir Fraser	2010-01-13 08:14:01 +0000	171)    XEN_GUEST_HANDLE_64(xen_pfn_t) array;
b3eb2c1e	(Keir Fraser	2010-01-13 08:14:01 +0000	172)};
b3eb2c1e	(Keir Fraser	2010-01-13 08:14:01 +0000	173)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	174)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	175)/*
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	176) * Control shadow pagetables operation
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	177) */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	178)/* XEN_DOMCTL_shadow_op */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	179)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	180)/* Disable shadow mode. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	181)#define XEN_DOMCTL_SHADOW_OP_OFF         0
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	182)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	183)/* Enable shadow mode (mode contains ORed XEN_DOMCTL_SHADOW_ENABLE_* flags). */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	184)#define XEN_DOMCTL_SHADOW_OP_ENABLE      32
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	185)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	186)/* Log-dirty bitmap operations. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	187) /* Return the bitmap and clean internal copy for next round. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	188)#define XEN_DOMCTL_SHADOW_OP_CLEAN       11
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	189) /* Return the bitmap but do not modify internal copy. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	190)#define XEN_DOMCTL_SHADOW_OP_PEEK        12
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	191)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	192)/* Memory allocation accessors. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	193)#define XEN_DOMCTL_SHADOW_OP_GET_ALLOCATION   30
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	194)#define XEN_DOMCTL_SHADOW_OP_SET_ALLOCATION   31
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	195)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	196)/* Legacy enable operations. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	197) /* Equiv. to ENABLE with no mode flags. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	198)#define XEN_DOMCTL_SHADOW_OP_ENABLE_TEST       1
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	199) /* Equiv. to ENABLE with mode flag ENABLE_LOG_DIRTY. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	200)#define XEN_DOMCTL_SHADOW_OP_ENABLE_LOGDIRTY   2
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	201) /* Equiv. to ENABLE with mode flags ENABLE_REFCOUNT and ENABLE_TRANSLATE. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	202)#define XEN_DOMCTL_SHADOW_OP_ENABLE_TRANSLATE  3
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	203)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	204)/* Mode flags for XEN_DOMCTL_SHADOW_OP_ENABLE. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	205) /*
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	206)  * Shadow pagetables are refcounted: guest does not use explicit mmu
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	207)  * operations nor write-protect its pagetables.
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	208)  */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	209)#define XEN_DOMCTL_SHADOW_ENABLE_REFCOUNT  (1 << 1)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	210) /*
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	211)  * Log pages in a bitmap as they are dirtied.
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	212)  * Used for live relocation to determine which pages must be re-sent.
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	213)  */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	214)#define XEN_DOMCTL_SHADOW_ENABLE_LOG_DIRTY (1 << 2)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	215) /*
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	216)  * Automatically translate GPFNs into MFNs.
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	217)  */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	218)#define XEN_DOMCTL_SHADOW_ENABLE_TRANSLATE (1 << 3)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	219) /*
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	220)  * Xen does not steal virtual address space from the guest.
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	221)  * Requires HVM support.
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	222)  */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	223)#define XEN_DOMCTL_SHADOW_ENABLE_EXTERNAL  (1 << 4)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	224)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	225)struct xen_domctl_shadow_op_stats {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	226)    uint32_t fault_count;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	227)    uint32_t dirty_count;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	228)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	229)typedef struct xen_domctl_shadow_op_stats xen_domctl_shadow_op_stats_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	230)DEFINE_XEN_GUEST_HANDLE(xen_domctl_shadow_op_stats_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	231)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	232)struct xen_domctl_shadow_op {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	233)    /* IN variables. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	234)    uint32_t       op;       /* XEN_DOMCTL_SHADOW_OP_* */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	235)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	236)    /* OP_ENABLE */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	237)    uint32_t       mode;     /* XEN_DOMCTL_SHADOW_ENABLE_* */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	238)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	239)    /* OP_GET_ALLOCATION / OP_SET_ALLOCATION */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	240)    uint32_t       mb;       /* Shadow memory allocation in MB */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	241)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	242)    /* OP_PEEK / OP_CLEAN */
28cba610	(Keir Fraser	2007-12-28 15:44:51 +0000	243)    XEN_GUEST_HANDLE_64(uint8) dirty_bitmap;
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	244)    uint64_aligned_t pages; /* Size of buffer. Updated with actual size. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	245)    struct xen_domctl_shadow_op_stats stats;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	246)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	247)typedef struct xen_domctl_shadow_op xen_domctl_shadow_op_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	248)DEFINE_XEN_GUEST_HANDLE(xen_domctl_shadow_op_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	249)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	250)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	251)/* XEN_DOMCTL_max_mem */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	252)struct xen_domctl_max_mem {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	253)    /* IN variables. */
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	254)    uint64_aligned_t max_memkb;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	255)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	256)typedef struct xen_domctl_max_mem xen_domctl_max_mem_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	257)DEFINE_XEN_GUEST_HANDLE(xen_domctl_max_mem_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	258)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	259)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	260)/* XEN_DOMCTL_setvcpucontext */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	261)/* XEN_DOMCTL_getvcpucontext */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	262)struct xen_domctl_vcpucontext {
194fd7d7	(kaf24@firebug.cl.cam.ac.uk	2006-08-31 19:53:27 +0100	263)    uint32_t              vcpu;                  /* IN */
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	264)    XEN_GUEST_HANDLE_64(vcpu_guest_context_t) ctxt; /* IN/OUT */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	265)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	266)typedef struct xen_domctl_vcpucontext xen_domctl_vcpucontext_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	267)DEFINE_XEN_GUEST_HANDLE(xen_domctl_vcpucontext_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	268)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	269)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	270)/* XEN_DOMCTL_getvcpuinfo */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	271)struct xen_domctl_getvcpuinfo {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	272)    /* IN variables. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	273)    uint32_t vcpu;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	274)    /* OUT variables. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	275)    uint8_t  online;                  /* currently online (not hotplugged)? */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	276)    uint8_t  blocked;                 /* blocked waiting for an event? */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	277)    uint8_t  running;                 /* currently scheduled on its CPU? */
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	278)    uint64_aligned_t cpu_time;        /* total cpu time consumed (ns) */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	279)    uint32_t cpu;                     /* current mapping   */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	280)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	281)typedef struct xen_domctl_getvcpuinfo xen_domctl_getvcpuinfo_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	282)DEFINE_XEN_GUEST_HANDLE(xen_domctl_getvcpuinfo_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	283)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	284)
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	285)/* Get/set the NUMA node(s) with which the guest has affinity with. */
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	286)/* XEN_DOMCTL_setnodeaffinity */
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	287)/* XEN_DOMCTL_getnodeaffinity */
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	288)struct xen_domctl_nodeaffinity {
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	289)    struct xenctl_bitmap nodemap;/* IN */
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	290)};
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	291)typedef struct xen_domctl_nodeaffinity xen_domctl_nodeaffinity_t;
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	292)DEFINE_XEN_GUEST_HANDLE(xen_domctl_nodeaffinity_t);
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	293)
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	294)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	295)/* Get/set which physical cpus a vcpu can execute on. */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	296)/* XEN_DOMCTL_setvcpuaffinity */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	297)/* XEN_DOMCTL_getvcpuaffinity */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	298)struct xen_domctl_vcpuaffinity {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	299)    uint32_t  vcpu;              /* IN */
15299b5b	(Dario Faggioli	2013-04-17 10:57:28 +0000	300)    struct xenctl_bitmap cpumap; /* IN/OUT */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	301)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	302)typedef struct xen_domctl_vcpuaffinity xen_domctl_vcpuaffinity_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	303)DEFINE_XEN_GUEST_HANDLE(xen_domctl_vcpuaffinity_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	304)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	305)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	306)/* XEN_DOMCTL_max_vcpus */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	307)struct xen_domctl_max_vcpus {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	308)    uint32_t max;           /* maximum number of vcpus */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	309)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	310)typedef struct xen_domctl_max_vcpus xen_domctl_max_vcpus_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	311)DEFINE_XEN_GUEST_HANDLE(xen_domctl_max_vcpus_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	312)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	313)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	314)/* XEN_DOMCTL_scheduler_op */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	315)/* Scheduler types. */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	316)#define XEN_SCHEDULER_SEDF     4
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	317)#define XEN_SCHEDULER_CREDIT   5
0dd76d3d	(Keir Fraser	2010-04-14 12:07:21 +0100	318)#define XEN_SCHEDULER_CREDIT2  6
22787f2e	(Keir Fraser	2010-12-01 21:20:14 +0000	319)#define XEN_SCHEDULER_ARINC653 7
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	320)#define XEN_SCHEDULER_RTGLOBAL 8
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	321)#define XEN_SCHEDULER_RTPARTITION 9
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	322)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	323)/* Set or get info? */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	324)#define XEN_DOMCTL_SCHEDOP_putinfo 0
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	325)#define XEN_DOMCTL_SCHEDOP_getinfo 1
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	326)struct xen_domctl_scheduler_op {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	327)    uint32_t sched_id;  /* XEN_SCHEDULER_* */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	328)    uint32_t cmd;       /* XEN_DOMCTL_SCHEDOP_* */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	329)    union {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	330)        struct xen_domctl_sched_sedf {
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	331)            uint64_aligned_t period;
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	332)            uint64_aligned_t slice;
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	333)            uint64_aligned_t latency;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	334)            uint32_t extratime;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	335)            uint32_t weight;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	336)        } sedf;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	337)        struct xen_domctl_sched_credit {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	338)            uint16_t weight;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	339)            uint16_t cap;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	340)        } credit;
0dd76d3d	(Keir Fraser	2010-04-14 12:07:21 +0100	341)        struct xen_domctl_sched_credit2 {
0dd76d3d	(Keir Fraser	2010-04-14 12:07:21 +0100	342)            uint16_t weight;
0dd76d3d	(Keir Fraser	2010-04-14 12:07:21 +0100	343)        } credit2;
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	344)		struct xen_domctl_sched_rtglobal {
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	345)			uint16_t period;
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	346)			uint16_t budget;
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	347)			uint16_t extra;
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	348)			uint16_t vcpu;
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	349)		} rtglobal;
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	350)		struct xen_domctl_sched_rtpartition {
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	351)			uint16_t period;
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	352)			uint16_t budget;
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	353)			uint16_t extra;
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	354)			uint16_t vcpu;
5df253cc	(   Sisu Xi	2013-08-20 22:47:15 -0500	355)		} rtpartition;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	356)    } u;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	357)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	358)typedef struct xen_domctl_scheduler_op xen_domctl_scheduler_op_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	359)DEFINE_XEN_GUEST_HANDLE(xen_domctl_scheduler_op_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	360)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	361)/* XEN_DOMCTL_setdomainhandle */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	362)struct xen_domctl_setdomainhandle {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	363)    xen_domain_handle_t handle;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	364)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	365)typedef struct xen_domctl_setdomainhandle xen_domctl_setdomainhandle_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	366)DEFINE_XEN_GUEST_HANDLE(xen_domctl_setdomainhandle_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	367)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	368)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	369)/* XEN_DOMCTL_setdebugging */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	370)struct xen_domctl_setdebugging {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	371)    uint8_t enable;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	372)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	373)typedef struct xen_domctl_setdebugging xen_domctl_setdebugging_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	374)DEFINE_XEN_GUEST_HANDLE(xen_domctl_setdebugging_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	375)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	376)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	377)/* XEN_DOMCTL_irq_permission */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	378)struct xen_domctl_irq_permission {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	379)    uint8_t pirq;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	380)    uint8_t allow_access;    /* flag to specify enable/disable of IRQ access */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	381)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	382)typedef struct xen_domctl_irq_permission xen_domctl_irq_permission_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	383)DEFINE_XEN_GUEST_HANDLE(xen_domctl_irq_permission_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	384)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	385)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	386)/* XEN_DOMCTL_iomem_permission */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	387)struct xen_domctl_iomem_permission {
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	388)    uint64_aligned_t first_mfn;/* first page (physical page number) in range */
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	389)    uint64_aligned_t nr_mfns;  /* number of pages in range (>0) */
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	390)    uint8_t  allow_access;     /* allow (!0) or deny (0) access to range? */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	391)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	392)typedef struct xen_domctl_iomem_permission xen_domctl_iomem_permission_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	393)DEFINE_XEN_GUEST_HANDLE(xen_domctl_iomem_permission_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	394)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	395)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	396)/* XEN_DOMCTL_ioport_permission */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	397)struct xen_domctl_ioport_permission {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	398)    uint32_t first_port;              /* first port int range */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	399)    uint32_t nr_ports;                /* size of port range */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	400)    uint8_t  allow_access;            /* allow or deny access to range? */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	401)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	402)typedef struct xen_domctl_ioport_permission xen_domctl_ioport_permission_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	403)DEFINE_XEN_GUEST_HANDLE(xen_domctl_ioport_permission_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	404)
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	405)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	406)/* XEN_DOMCTL_hypercall_init */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	407)struct xen_domctl_hypercall_init {
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	408)    uint64_aligned_t  gmfn;           /* GMFN to be initialised */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	409)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	410)typedef struct xen_domctl_hypercall_init xen_domctl_hypercall_init_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	411)DEFINE_XEN_GUEST_HANDLE(xen_domctl_hypercall_init_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	412)
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	413)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	414)/* XEN_DOMCTL_arch_setup */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	415)#define _XEN_DOMAINSETUP_hvm_guest 0
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	416)#define XEN_DOMAINSETUP_hvm_guest  (1UL<<_XEN_DOMAINSETUP_hvm_guest)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	417)#define _XEN_DOMAINSETUP_query 1 /* Get parameters (for save)  */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	418)#define XEN_DOMAINSETUP_query  (1UL<<_XEN_DOMAINSETUP_query)
a7933163	(Alex Williamson	2008-02-19 08:11:22 -0700	419)#define _XEN_DOMAINSETUP_sioemu_guest 2
a7933163	(Alex Williamson	2008-02-19 08:11:22 -0700	420)#define XEN_DOMAINSETUP_sioemu_guest  (1UL<<_XEN_DOMAINSETUP_sioemu_guest)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	421)typedef struct xen_domctl_arch_setup {
46c01e05	(kfraser@localhost.localdomain	2007-01-24 16:33:19 +0000	422)    uint64_aligned_t flags;  /* XEN_DOMAINSETUP_* */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	423)} xen_domctl_arch_setup_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	424)DEFINE_XEN_GUEST_HANDLE(xen_domctl_arch_setup_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	425)
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	426)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	427)/* XEN_DOMCTL_settimeoffset */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	428)struct xen_domctl_settimeoffset {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	429)    int32_t  time_offset_seconds; /* applied to domain wallclock time */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	430)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	431)typedef struct xen_domctl_settimeoffset xen_domctl_settimeoffset_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	432)DEFINE_XEN_GUEST_HANDLE(xen_domctl_settimeoffset_t);
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	433)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	434)/* XEN_DOMCTL_gethvmcontext */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	435)/* XEN_DOMCTL_sethvmcontext */
294b0bdd	(Tim Deegan	2007-01-18 16:48:04 +0000	436)typedef struct xen_domctl_hvmcontext {
782821bc	(Tim Deegan	2007-01-31 17:22:00 +0000	437)    uint32_t size; /* IN/OUT: size of buffer / bytes filled */
28cba610	(Keir Fraser	2007-12-28 15:44:51 +0000	438)    XEN_GUEST_HANDLE_64(uint8) buffer; /* IN/OUT: data, or call
28cba610	(Keir Fraser	2007-12-28 15:44:51 +0000	439)                                        * gethvmcontext with NULL
28cba610	(Keir Fraser	2007-12-28 15:44:51 +0000	440)                                        * buffer to get size req'd */
294b0bdd	(Tim Deegan	2007-01-18 16:48:04 +0000	441)} xen_domctl_hvmcontext_t;
294b0bdd	(Tim Deegan	2007-01-18 16:48:04 +0000	442)DEFINE_XEN_GUEST_HANDLE(xen_domctl_hvmcontext_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	443)
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	444)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	445)/* XEN_DOMCTL_set_address_size */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	446)/* XEN_DOMCTL_get_address_size */
15fa4096	(kaf24@localhost.localdomain	2007-01-26 13:27:01 +0000	447)typedef struct xen_domctl_address_size {
15fa4096	(kaf24@localhost.localdomain	2007-01-26 13:27:01 +0000	448)    uint32_t size;
15fa4096	(kaf24@localhost.localdomain	2007-01-26 13:27:01 +0000	449)} xen_domctl_address_size_t;
15fa4096	(kaf24@localhost.localdomain	2007-01-26 13:27:01 +0000	450)DEFINE_XEN_GUEST_HANDLE(xen_domctl_address_size_t);
15fa4096	(kaf24@localhost.localdomain	2007-01-26 13:27:01 +0000	451)
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	452)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	453)/* XEN_DOMCTL_real_mode_area */
f1cf580f	(Hollis Blanchard	2006-12-12 10:23:58 -0600	454)struct xen_domctl_real_mode_area {
f1cf580f	(Hollis Blanchard	2006-12-12 10:23:58 -0600	455)    uint32_t log; /* log2 of Real Mode Area size */
f1cf580f	(Hollis Blanchard	2006-12-12 10:23:58 -0600	456)};
f1cf580f	(Hollis Blanchard	2006-12-12 10:23:58 -0600	457)typedef struct xen_domctl_real_mode_area xen_domctl_real_mode_area_t;
f1cf580f	(Hollis Blanchard	2006-12-12 10:23:58 -0600	458)DEFINE_XEN_GUEST_HANDLE(xen_domctl_real_mode_area_t);
f1cf580f	(Hollis Blanchard	2006-12-12 10:23:58 -0600	459)
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	460)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	461)/* XEN_DOMCTL_sendtrigger */
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	462)#define XEN_DOMCTL_SENDTRIGGER_NMI    0
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	463)#define XEN_DOMCTL_SENDTRIGGER_RESET  1
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	464)#define XEN_DOMCTL_SENDTRIGGER_INIT   2
ab438874	(Keir Fraser	2009-04-02 12:40:09 +0100	465)#define XEN_DOMCTL_SENDTRIGGER_POWER  3
9e2b86f4	(Keir Fraser	2010-01-20 20:34:19 +0000	466)#define XEN_DOMCTL_SENDTRIGGER_SLEEP  4
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	467)struct xen_domctl_sendtrigger {
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	468)    uint32_t  trigger;  /* IN */
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	469)    uint32_t  vcpu;     /* IN */
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	470)};
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	471)typedef struct xen_domctl_sendtrigger xen_domctl_sendtrigger_t;
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	472)DEFINE_XEN_GUEST_HANDLE(xen_domctl_sendtrigger_t);
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	473)
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	474)
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	475)/* Assign PCI device to HVM guest. Sets up IOMMU structures. */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	476)/* XEN_DOMCTL_assign_device */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	477)/* XEN_DOMCTL_test_assign_device */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	478)/* XEN_DOMCTL_deassign_device */
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	479)struct xen_domctl_assign_device {
6865e52b	(Jan Beulich	2011-09-22 18:26:54 +0100	480)    uint32_t  machine_sbdf;   /* machine PCI ID of assigned device */
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	481)};
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	482)typedef struct xen_domctl_assign_device xen_domctl_assign_device_t;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	483)DEFINE_XEN_GUEST_HANDLE(xen_domctl_assign_device_t);
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	484)
6865e52b	(Jan Beulich	2011-09-22 18:26:54 +0100	485)/* Retrieve sibling devices infomation of machine_sbdf */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	486)/* XEN_DOMCTL_get_device_group */
491c0ade	(Keir Fraser	2008-05-28 14:41:23 +0100	487)struct xen_domctl_get_device_group {
6865e52b	(Jan Beulich	2011-09-22 18:26:54 +0100	488)    uint32_t  machine_sbdf;     /* IN */
491c0ade	(Keir Fraser	2008-05-28 14:41:23 +0100	489)    uint32_t  max_sdevs;        /* IN */
491c0ade	(Keir Fraser	2008-05-28 14:41:23 +0100	490)    uint32_t  num_sdevs;        /* OUT */
491c0ade	(Keir Fraser	2008-05-28 14:41:23 +0100	491)    XEN_GUEST_HANDLE_64(uint32)  sdev_array;   /* OUT */
491c0ade	(Keir Fraser	2008-05-28 14:41:23 +0100	492)};
491c0ade	(Keir Fraser	2008-05-28 14:41:23 +0100	493)typedef struct xen_domctl_get_device_group xen_domctl_get_device_group_t;
491c0ade	(Keir Fraser	2008-05-28 14:41:23 +0100	494)DEFINE_XEN_GUEST_HANDLE(xen_domctl_get_device_group_t);
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	495)
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	496)/* Pass-through interrupts: bind real irq -> hvm devfn. */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	497)/* XEN_DOMCTL_bind_pt_irq */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	498)/* XEN_DOMCTL_unbind_pt_irq */
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	499)typedef enum pt_irq_type_e {
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	500)    PT_IRQ_TYPE_PCI,
85715f4b	(Keir Fraser	2008-05-01 10:33:03 +0100	501)    PT_IRQ_TYPE_ISA,
85715f4b	(Keir Fraser	2008-05-01 10:33:03 +0100	502)    PT_IRQ_TYPE_MSI,
11f8ac5e	(Keir Fraser	2009-01-08 11:25:06 +0000	503)    PT_IRQ_TYPE_MSI_TRANSLATE,
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	504)} pt_irq_type_t;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	505)struct xen_domctl_bind_pt_irq {
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	506)    uint32_t machine_irq;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	507)    pt_irq_type_t irq_type;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	508)    uint32_t hvm_domid;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	509)
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	510)    union {
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	511)        struct {
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	512)            uint8_t isa_irq;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	513)        } isa;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	514)        struct {
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	515)            uint8_t bus;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	516)            uint8_t device;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	517)            uint8_t intx;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	518)        } pci;
85715f4b	(Keir Fraser	2008-05-01 10:33:03 +0100	519)        struct {
85715f4b	(Keir Fraser	2008-05-01 10:33:03 +0100	520)            uint8_t gvec;
85715f4b	(Keir Fraser	2008-05-01 10:33:03 +0100	521)            uint32_t gflags;
c3eca726	(Keir Fraser	2009-03-12 08:35:12 +0000	522)            uint64_aligned_t gtable;
85715f4b	(Keir Fraser	2008-05-01 10:33:03 +0100	523)        } msi;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	524)    } u;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	525)};
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	526)typedef struct xen_domctl_bind_pt_irq xen_domctl_bind_pt_irq_t;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	527)DEFINE_XEN_GUEST_HANDLE(xen_domctl_bind_pt_irq_t);
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	528)
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	529)
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	530)/* Bind machine I/O address range -> HVM address range. */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	531)/* XEN_DOMCTL_memory_mapping */
239ad70f	(Keir Fraser	2007-12-12 10:29:35 +0000	532)#define DPCI_ADD_MAPPING         1
239ad70f	(Keir Fraser	2007-12-12 10:29:35 +0000	533)#define DPCI_REMOVE_MAPPING      0
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	534)struct xen_domctl_memory_mapping {
87bdb45d	(Keir Fraser	2007-10-25 11:38:04 +0100	535)    uint64_aligned_t first_gfn; /* first page (hvm guest phys page) in range */
87bdb45d	(Keir Fraser	2007-10-25 11:38:04 +0100	536)    uint64_aligned_t first_mfn; /* first page (machine page) in range */
87bdb45d	(Keir Fraser	2007-10-25 11:38:04 +0100	537)    uint64_aligned_t nr_mfns;   /* number of pages in range (>0) */
87bdb45d	(Keir Fraser	2007-10-25 11:38:04 +0100	538)    uint32_t add_mapping;       /* add or remove mapping */
87bdb45d	(Keir Fraser	2007-10-25 11:38:04 +0100	539)    uint32_t padding;           /* padding for 64-bit aligned structure */
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	540)};
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	541)typedef struct xen_domctl_memory_mapping xen_domctl_memory_mapping_t;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	542)DEFINE_XEN_GUEST_HANDLE(xen_domctl_memory_mapping_t);
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	543)
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	544)
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	545)/* Bind machine I/O port range -> HVM I/O port range. */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	546)/* XEN_DOMCTL_ioport_mapping */
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	547)struct xen_domctl_ioport_mapping {
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	548)    uint32_t first_gport;     /* first guest IO port*/
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	549)    uint32_t first_mport;     /* first machine IO port */
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	550)    uint32_t nr_ports;        /* size of port range */
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	551)    uint32_t add_mapping;     /* add or remove mapping */
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	552)};
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	553)typedef struct xen_domctl_ioport_mapping xen_domctl_ioport_mapping_t;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	554)DEFINE_XEN_GUEST_HANDLE(xen_domctl_ioport_mapping_t);
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	555)
87bdb45d	(Keir Fraser	2007-10-25 11:38:04 +0100	556)
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	557)/*
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	558) * Pin caching type of RAM space for x86 HVM domU.
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	559) */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	560)/* XEN_DOMCTL_pin_mem_cacheattr */
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	561)/* Caching types: these happen to be the same as x86 MTRR/PAT type codes. */
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	562)#define XEN_DOMCTL_MEM_CACHEATTR_UC  0
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	563)#define XEN_DOMCTL_MEM_CACHEATTR_WC  1
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	564)#define XEN_DOMCTL_MEM_CACHEATTR_WT  4
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	565)#define XEN_DOMCTL_MEM_CACHEATTR_WP  5
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	566)#define XEN_DOMCTL_MEM_CACHEATTR_WB  6
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	567)#define XEN_DOMCTL_MEM_CACHEATTR_UCM 7
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	568)struct xen_domctl_pin_mem_cacheattr {
87bdb45d	(Keir Fraser	2007-10-25 11:38:04 +0100	569)    uint64_aligned_t start, end;
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	570)    uint32_t type; /* XEN_DOMCTL_MEM_CACHEATTR_* */
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	571)};
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	572)typedef struct xen_domctl_pin_mem_cacheattr xen_domctl_pin_mem_cacheattr_t;
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	573)DEFINE_XEN_GUEST_HANDLE(xen_domctl_pin_mem_cacheattr_t);
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	574)
87bdb45d	(Keir Fraser	2007-10-25 11:38:04 +0100	575)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	576)/* XEN_DOMCTL_set_ext_vcpucontext */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	577)/* XEN_DOMCTL_get_ext_vcpucontext */
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	578)struct xen_domctl_ext_vcpucontext {
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	579)    /* IN: VCPU that this call applies to. */
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	580)    uint32_t         vcpu;
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	581)    /*
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	582)     * SET: Size of struct (IN)
e1dc98e3	(Jan Beulich	2012-02-24 09:07:54 +0100	583)     * GET: Size of struct (OUT, up to 128 bytes)
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	584)     */
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	585)    uint32_t         size;
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	586)#if defined(__i386__) || defined(__x86_64__)
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	587)    /* SYSCALL from 32-bit mode and SYSENTER callback information. */
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	588)    /* NB. SYSCALL from 64-bit mode is contained in vcpu_guest_context_t */
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	589)    uint64_aligned_t syscall32_callback_eip;
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	590)    uint64_aligned_t sysenter_callback_eip;
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	591)    uint16_t         syscall32_callback_cs;
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	592)    uint16_t         sysenter_callback_cs;
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	593)    uint8_t          syscall32_disables_events;
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	594)    uint8_t          sysenter_disables_events;
19b03acd	(Liu, Jinsong	2012-09-26 12:05:55 +0200	595)#if defined(__GNUC__)
19b03acd	(Liu, Jinsong	2012-09-26 12:05:55 +0200	596)    union {
19b03acd	(Liu, Jinsong	2012-09-26 12:05:55 +0200	597)        uint64_aligned_t mcg_cap;
19b03acd	(Liu, Jinsong	2012-09-26 12:05:55 +0200	598)        struct hvm_vmce_vcpu vmce;
19b03acd	(Liu, Jinsong	2012-09-26 12:05:55 +0200	599)    };
19b03acd	(Liu, Jinsong	2012-09-26 12:05:55 +0200	600)#else
19b03acd	(Liu, Jinsong	2012-09-26 12:05:55 +0200	601)    struct hvm_vmce_vcpu vmce;
19b03acd	(Liu, Jinsong	2012-09-26 12:05:55 +0200	602)#endif
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	603)#endif
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	604)};
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	605)typedef struct xen_domctl_ext_vcpucontext xen_domctl_ext_vcpucontext_t;
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	606)DEFINE_XEN_GUEST_HANDLE(xen_domctl_ext_vcpucontext_t);
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	607)
13511bb0	(Alex Williamson	2007-11-29 11:57:23 -0700	608)/*
47fcfcb7	(Keir Fraser	2008-01-23 13:21:44 +0000	609) * Set the target domain for a domain
47fcfcb7	(Keir Fraser	2008-01-23 13:21:44 +0000	610) */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	611)/* XEN_DOMCTL_set_target */
47fcfcb7	(Keir Fraser	2008-01-23 13:21:44 +0000	612)struct xen_domctl_set_target {
47fcfcb7	(Keir Fraser	2008-01-23 13:21:44 +0000	613)    domid_t target;
47fcfcb7	(Keir Fraser	2008-01-23 13:21:44 +0000	614)};
47fcfcb7	(Keir Fraser	2008-01-23 13:21:44 +0000	615)typedef struct xen_domctl_set_target xen_domctl_set_target_t;
47fcfcb7	(Keir Fraser	2008-01-23 13:21:44 +0000	616)DEFINE_XEN_GUEST_HANDLE(xen_domctl_set_target_t);
47fcfcb7	(Keir Fraser	2008-01-23 13:21:44 +0000	617)
5f14a87c	(Keir Fraser	2008-04-25 13:44:45 +0100	618)#if defined(__i386__) || defined(__x86_64__)
5f14a87c	(Keir Fraser	2008-04-25 13:44:45 +0100	619)# define XEN_CPUID_INPUT_UNUSED  0xFFFFFFFF
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	620)/* XEN_DOMCTL_set_cpuid */
5f14a87c	(Keir Fraser	2008-04-25 13:44:45 +0100	621)struct xen_domctl_cpuid {
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	622)  uint32_t input[2];
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	623)  uint32_t eax;
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	624)  uint32_t ebx;
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	625)  uint32_t ecx;
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	626)  uint32_t edx;
5f14a87c	(Keir Fraser	2008-04-25 13:44:45 +0100	627)};
5f14a87c	(Keir Fraser	2008-04-25 13:44:45 +0100	628)typedef struct xen_domctl_cpuid xen_domctl_cpuid_t;
5f14a87c	(Keir Fraser	2008-04-25 13:44:45 +0100	629)DEFINE_XEN_GUEST_HANDLE(xen_domctl_cpuid_t);
5f14a87c	(Keir Fraser	2008-04-25 13:44:45 +0100	630)#endif
47fcfcb7	(Keir Fraser	2008-01-23 13:21:44 +0000	631)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	632)/* XEN_DOMCTL_subscribe */
4539594d	(Keir Fraser	2008-07-04 12:00:24 +0100	633)struct xen_domctl_subscribe {
4539594d	(Keir Fraser	2008-07-04 12:00:24 +0100	634)    uint32_t port; /* IN */
4539594d	(Keir Fraser	2008-07-04 12:00:24 +0100	635)};
4539594d	(Keir Fraser	2008-07-04 12:00:24 +0100	636)typedef struct xen_domctl_subscribe xen_domctl_subscribe_t;
4539594d	(Keir Fraser	2008-07-04 12:00:24 +0100	637)DEFINE_XEN_GUEST_HANDLE(xen_domctl_subscribe_t);
4539594d	(Keir Fraser	2008-07-04 12:00:24 +0100	638)
41296317	(Keir Fraser	2008-07-11 12:51:26 +0100	639)/*
41296317	(Keir Fraser	2008-07-11 12:51:26 +0100	640) * Define the maximum machine address size which should be allocated
41296317	(Keir Fraser	2008-07-11 12:51:26 +0100	641) * to a guest.
41296317	(Keir Fraser	2008-07-11 12:51:26 +0100	642) */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	643)/* XEN_DOMCTL_set_machine_address_size */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	644)/* XEN_DOMCTL_get_machine_address_size */
41296317	(Keir Fraser	2008-07-11 12:51:26 +0100	645)
39407bed	(Keir Fraser	2008-10-15 15:56:26 +0100	646)/*
39407bed	(Keir Fraser	2008-10-15 15:56:26 +0100	647) * Do not inject spurious page faults into this domain.
39407bed	(Keir Fraser	2008-10-15 15:56:26 +0100	648) */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	649)/* XEN_DOMCTL_suppress_spurious_page_faults */
41296317	(Keir Fraser	2008-07-11 12:51:26 +0100	650)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	651)/* XEN_DOMCTL_debug_op */
74d59a59	(Keir Fraser	2008-12-16 11:49:20 +0000	652)#define XEN_DOMCTL_DEBUG_OP_SINGLE_STEP_OFF         0
74d59a59	(Keir Fraser	2008-12-16 11:49:20 +0000	653)#define XEN_DOMCTL_DEBUG_OP_SINGLE_STEP_ON          1
74d59a59	(Keir Fraser	2008-12-16 11:49:20 +0000	654)struct xen_domctl_debug_op {
74d59a59	(Keir Fraser	2008-12-16 11:49:20 +0000	655)    uint32_t op;   /* IN */
74d59a59	(Keir Fraser	2008-12-16 11:49:20 +0000	656)    uint32_t vcpu; /* IN */
74d59a59	(Keir Fraser	2008-12-16 11:49:20 +0000	657)};
74d59a59	(Keir Fraser	2008-12-16 11:49:20 +0000	658)typedef struct xen_domctl_debug_op xen_domctl_debug_op_t;
74d59a59	(Keir Fraser	2008-12-16 11:49:20 +0000	659)DEFINE_XEN_GUEST_HANDLE(xen_domctl_debug_op_t);
74d59a59	(Keir Fraser	2008-12-16 11:49:20 +0000	660)
1bb7e043	(Keir Fraser	2009-02-05 12:16:28 +0000	661)/*
1bb7e043	(Keir Fraser	2009-02-05 12:16:28 +0000	662) * Request a particular record from the HVM context
1bb7e043	(Keir Fraser	2009-02-05 12:16:28 +0000	663) */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	664)/* XEN_DOMCTL_gethvmcontext_partial */
1bb7e043	(Keir Fraser	2009-02-05 12:16:28 +0000	665)typedef struct xen_domctl_hvmcontext_partial {
1bb7e043	(Keir Fraser	2009-02-05 12:16:28 +0000	666)    uint32_t type;                      /* IN: Type of record required */
1bb7e043	(Keir Fraser	2009-02-05 12:16:28 +0000	667)    uint32_t instance;                  /* IN: Instance of that type */
1bb7e043	(Keir Fraser	2009-02-05 12:16:28 +0000	668)    XEN_GUEST_HANDLE_64(uint8) buffer;  /* OUT: buffer to write record into */
1bb7e043	(Keir Fraser	2009-02-05 12:16:28 +0000	669)} xen_domctl_hvmcontext_partial_t;
1bb7e043	(Keir Fraser	2009-02-05 12:16:28 +0000	670)DEFINE_XEN_GUEST_HANDLE(xen_domctl_hvmcontext_partial_t);
1bb7e043	(Keir Fraser	2009-02-05 12:16:28 +0000	671)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	672)/* XEN_DOMCTL_disable_migrate */
87cb99a6	(Keir Fraser	2009-10-20 08:45:12 +0100	673)typedef struct xen_domctl_disable_migrate {
87cb99a6	(Keir Fraser	2009-10-20 08:45:12 +0100	674)    uint32_t disable; /* IN: 1: disable migration and restore */
87cb99a6	(Keir Fraser	2009-10-20 08:45:12 +0100	675)} xen_domctl_disable_migrate_t;
87cb99a6	(Keir Fraser	2009-10-20 08:45:12 +0100	676)
87cb99a6	(Keir Fraser	2009-10-20 08:45:12 +0100	677)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	678)/* XEN_DOMCTL_gettscinfo */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	679)/* XEN_DOMCTL_settscinfo */
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	680)struct xen_guest_tsc_info {
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	681)    uint32_t tsc_mode;
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	682)    uint32_t gtsc_khz;
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	683)    uint32_t incarnation;
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	684)    uint32_t pad;
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	685)    uint64_aligned_t elapsed_nsec;
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	686)};
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	687)typedef struct xen_guest_tsc_info xen_guest_tsc_info_t;
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	688)DEFINE_XEN_GUEST_HANDLE(xen_guest_tsc_info_t);
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	689)typedef struct xen_domctl_tsc_info {
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	690)    XEN_GUEST_HANDLE_64(xen_guest_tsc_info_t) out_info; /* OUT */
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	691)    xen_guest_tsc_info_t info; /* IN */
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	692)} xen_domctl_tsc_info_t;
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	693)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	694)/* XEN_DOMCTL_gdbsx_guestmemio      guest mem io */
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	695)struct xen_domctl_gdbsx_memio {
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	696)    /* IN */
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	697)    uint64_aligned_t pgd3val;/* optional: init_mm.pgd[3] value */
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	698)    uint64_aligned_t gva;    /* guest virtual address */
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	699)    uint64_aligned_t uva;    /* user buffer virtual address */
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	700)    uint32_t         len;    /* number of bytes to read/write */
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	701)    uint8_t          gwr;    /* 0 = read from guest. 1 = write to guest */
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	702)    /* OUT */
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	703)    uint32_t         remain; /* bytes remaining to be copied */
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	704)};
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	705)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	706)/* XEN_DOMCTL_gdbsx_pausevcpu */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	707)/* XEN_DOMCTL_gdbsx_unpausevcpu */
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	708)struct xen_domctl_gdbsx_pauseunp_vcpu { /* pause/unpause a vcpu */
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	709)    uint32_t         vcpu;         /* which vcpu */
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	710)};
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	711)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	712)/* XEN_DOMCTL_gdbsx_domstatus */
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	713)struct xen_domctl_gdbsx_domstatus {
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	714)    /* OUT */
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	715)    uint8_t          paused;     /* is the domain paused */
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	716)    uint32_t         vcpu_id;    /* any vcpu in an event? */
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	717)    uint32_t         vcpu_ev;    /* if yes, what event? */
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	718)};
74d59a59	(Keir Fraser	2008-12-16 11:49:20 +0000	719)
bd8fd8c1	(Keir Fraser	2009-12-17 06:27:55 +0000	720)/*
bd8fd8c1	(Keir Fraser	2009-12-17 06:27:55 +0000	721) * Memory event operations
bd8fd8c1	(Keir Fraser	2009-12-17 06:27:55 +0000	722) */
bd8fd8c1	(Keir Fraser	2009-12-17 06:27:55 +0000	723)
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	724)/* XEN_DOMCTL_mem_event_op */
bd8fd8c1	(Keir Fraser	2009-12-17 06:27:55 +0000	725)
35b1c10c	(Keir Fraser	2009-12-17 06:27:55 +0000	726)/*
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	727) * Domain memory paging
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	728) * Page memory in and out.
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	729) * Domctl interface to set up and tear down the 
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	730) * pager<->hypervisor interface. Use XENMEM_paging_op*
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	731) * to perform per-page operations.
cf705ff8	(Olaf Hering	2012-04-03 17:22:59 +0200	732) *
cf705ff8	(Olaf Hering	2012-04-03 17:22:59 +0200	733) * The XEN_DOMCTL_MEM_EVENT_OP_PAGING_ENABLE domctl returns several
cf705ff8	(Olaf Hering	2012-04-03 17:22:59 +0200	734) * non-standard error codes to indicate why paging could not be enabled:
cf705ff8	(Olaf Hering	2012-04-03 17:22:59 +0200	735) * ENODEV - host lacks HAP support (EPT/NPT) or HAP is disabled in guest
cf705ff8	(Olaf Hering	2012-04-03 17:22:59 +0200	736) * EMLINK - guest has iommu passthrough enabled
cf705ff8	(Olaf Hering	2012-04-03 17:22:59 +0200	737) * EXDEV  - guest has PoD enabled
cf705ff8	(Olaf Hering	2012-04-03 17:22:59 +0200	738) * EBUSY  - guest has or had paging enabled, ring buffer still active
35b1c10c	(Keir Fraser	2009-12-17 06:27:55 +0000	739) */
fbbedcae	(Joe Epstein	2011-01-07 11:54:40 +0000	740)#define XEN_DOMCTL_MEM_EVENT_OP_PAGING            1
35b1c10c	(Keir Fraser	2009-12-17 06:27:55 +0000	741)
2c36185d	(Olaf Hering	2011-09-16 12:19:26 +0100	742)#define XEN_DOMCTL_MEM_EVENT_OP_PAGING_ENABLE     0
2c36185d	(Olaf Hering	2011-09-16 12:19:26 +0100	743)#define XEN_DOMCTL_MEM_EVENT_OP_PAGING_DISABLE    1
35b1c10c	(Keir Fraser	2009-12-17 06:27:55 +0000	744)
fbbedcae	(Joe Epstein	2011-01-07 11:54:40 +0000	745)/*
fbbedcae	(Joe Epstein	2011-01-07 11:54:40 +0000	746) * Access permissions.
fbbedcae	(Joe Epstein	2011-01-07 11:54:40 +0000	747) *
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	748) * As with paging, use the domctl for teardown/setup of the
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	749) * helper<->hypervisor interface.
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	750) *
fbbedcae	(Joe Epstein	2011-01-07 11:54:40 +0000	751) * There are HVM hypercalls to set the per-page access permissions of every
fbbedcae	(Joe Epstein	2011-01-07 11:54:40 +0000	752) * page in a domain.  When one of these permissions--independent, read, 
fbbedcae	(Joe Epstein	2011-01-07 11:54:40 +0000	753) * write, and execute--is violated, the VCPU is paused and a memory event 
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	754) * is sent with what happened.  (See public/mem_event.h) .
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	755) *
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	756) * The memory event handler can then resume the VCPU and redo the access 
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	757) * with a XENMEM_access_op_resume hypercall.
cf705ff8	(Olaf Hering	2012-04-03 17:22:59 +0200	758) *
cf705ff8	(Olaf Hering	2012-04-03 17:22:59 +0200	759) * The XEN_DOMCTL_MEM_EVENT_OP_ACCESS_ENABLE domctl returns several
cf705ff8	(Olaf Hering	2012-04-03 17:22:59 +0200	760) * non-standard error codes to indicate why access could not be enabled:
cf705ff8	(Olaf Hering	2012-04-03 17:22:59 +0200	761) * ENODEV - host lacks HAP support (EPT/NPT) or HAP is disabled in guest
cf705ff8	(Olaf Hering	2012-04-03 17:22:59 +0200	762) * EBUSY  - guest has or had access enabled, ring buffer still active
fbbedcae	(Joe Epstein	2011-01-07 11:54:40 +0000	763) */
fbbedcae	(Joe Epstein	2011-01-07 11:54:40 +0000	764)#define XEN_DOMCTL_MEM_EVENT_OP_ACCESS            2
2c36185d	(Olaf Hering	2011-09-16 12:19:26 +0100	765)
2c36185d	(Olaf Hering	2011-09-16 12:19:26 +0100	766)#define XEN_DOMCTL_MEM_EVENT_OP_ACCESS_ENABLE     0
2c36185d	(Olaf Hering	2011-09-16 12:19:26 +0100	767)#define XEN_DOMCTL_MEM_EVENT_OP_ACCESS_DISABLE    1
fbbedcae	(Joe Epstein	2011-01-07 11:54:40 +0000	768)
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	769)/*
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	770) * Sharing ENOMEM helper.
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	771) *
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	772) * As with paging, use the domctl for teardown/setup of the
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	773) * helper<->hypervisor interface.
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	774) *
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	775) * If setup, this ring is used to communicate failed allocations
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	776) * in the unshare path. XENMEM_sharing_op_resume is used to wake up
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	777) * vcpus that could not unshare.
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	778) *
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	779) * Note that shring can be turned on (as per the domctl below)
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	780) * *without* this ring being setup.
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	781) */
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	782)#define XEN_DOMCTL_MEM_EVENT_OP_SHARING           3
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	783)
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	784)#define XEN_DOMCTL_MEM_EVENT_OP_SHARING_ENABLE    0
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	785)#define XEN_DOMCTL_MEM_EVENT_OP_SHARING_DISABLE   1
cc0b0b44	(Tim Deegan	2012-03-08 16:40:05 +0000	786)
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	787)/* Use for teardown/setup of helper<->hypervisor interface for paging, 
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	788) * access and sharing.*/
bd8fd8c1	(Keir Fraser	2009-12-17 06:27:55 +0000	789)struct xen_domctl_mem_event_op {
2c36185d	(Olaf Hering	2011-09-16 12:19:26 +0100	790)    uint32_t       op;           /* XEN_DOMCTL_MEM_EVENT_OP_*_* */
2c36185d	(Olaf Hering	2011-09-16 12:19:26 +0100	791)    uint32_t       mode;         /* XEN_DOMCTL_MEM_EVENT_OP_* */
bd8fd8c1	(Keir Fraser	2009-12-17 06:27:55 +0000	792)
08d62198	(Tim Deegan	2012-03-08 16:40:05 +0000	793)    uint32_t port;              /* OUT: event channel for ring */
bd8fd8c1	(Keir Fraser	2009-12-17 06:27:55 +0000	794)};
bd8fd8c1	(Keir Fraser	2009-12-17 06:27:55 +0000	795)typedef struct xen_domctl_mem_event_op xen_domctl_mem_event_op_t;
bd8fd8c1	(Keir Fraser	2009-12-17 06:27:55 +0000	796)DEFINE_XEN_GUEST_HANDLE(xen_domctl_mem_event_op_t);
bd8fd8c1	(Keir Fraser	2009-12-17 06:27:55 +0000	797)
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	798)/*
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	799) * Memory sharing operations
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	800) */
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	801)/* XEN_DOMCTL_mem_sharing_op.
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	802) * The CONTROL sub-domctl is used for bringup/teardown. */
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	803)#define XEN_DOMCTL_MEM_SHARING_CONTROL          0
3881f1a9	(Andres Lagar-Cavilla	2012-01-26 12:46:26 +0000	804)
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	805)struct xen_domctl_mem_sharing_op {
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	806)    uint8_t op; /* XEN_DOMCTL_MEM_SHARING_* */
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	807)
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	808)    union {
59a36d66	(Andres Lagar-Cavilla	2012-02-10 16:07:07 +0000	809)        uint8_t enable;                   /* CONTROL */
63408197	(Keir Fraser	2009-12-22 11:33:15 +0000	810)    } u;
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	811)};
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	812)typedef struct xen_domctl_mem_sharing_op xen_domctl_mem_sharing_op_t;
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	813)DEFINE_XEN_GUEST_HANDLE(xen_domctl_mem_sharing_op_t);
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	814)
5e6ced10	(Andres Lagar-Cavilla	2011-12-01 14:56:42 +0000	815)struct xen_domctl_audit_p2m {
5e6ced10	(Andres Lagar-Cavilla	2011-12-01 14:56:42 +0000	816)    /* OUT error counts */
b010d7f5	(Tim Deegan	2011-12-02 06:07:52 -0800	817)    uint64_t orphans;
5e6ced10	(Andres Lagar-Cavilla	2011-12-01 14:56:42 +0000	818)    uint64_t m2p_bad;
5e6ced10	(Andres Lagar-Cavilla	2011-12-01 14:56:42 +0000	819)    uint64_t p2m_bad;
5e6ced10	(Andres Lagar-Cavilla	2011-12-01 14:56:42 +0000	820)};
5e6ced10	(Andres Lagar-Cavilla	2011-12-01 14:56:42 +0000	821)typedef struct xen_domctl_audit_p2m xen_domctl_audit_p2m_t;
5e6ced10	(Andres Lagar-Cavilla	2011-12-01 14:56:42 +0000	822)DEFINE_XEN_GUEST_HANDLE(xen_domctl_audit_p2m_t);
5e6ced10	(Andres Lagar-Cavilla	2011-12-01 14:56:42 +0000	823)
87521589	(Daniel De Graaf	2012-01-28 13:48:03 +0000	824)struct xen_domctl_set_virq_handler {
87521589	(Daniel De Graaf	2012-01-28 13:48:03 +0000	825)    uint32_t virq; /* IN */
87521589	(Daniel De Graaf	2012-01-28 13:48:03 +0000	826)};
87521589	(Daniel De Graaf	2012-01-28 13:48:03 +0000	827)typedef struct xen_domctl_set_virq_handler xen_domctl_set_virq_handler_t;
87521589	(Daniel De Graaf	2012-01-28 13:48:03 +0000	828)DEFINE_XEN_GUEST_HANDLE(xen_domctl_set_virq_handler_t);
87521589	(Daniel De Graaf	2012-01-28 13:48:03 +0000	829)
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	830)#if defined(__i386__) || defined(__x86_64__)
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	831)/* XEN_DOMCTL_setvcpuextstate */
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	832)/* XEN_DOMCTL_getvcpuextstate */
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	833)struct xen_domctl_vcpuextstate {
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	834)    /* IN: VCPU that this call applies to. */
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	835)    uint32_t         vcpu;
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	836)    /*
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	837)     * SET: xfeature support mask of struct (IN)
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	838)     * GET: xfeature support mask of struct (IN/OUT)
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	839)     * xfeature mask is served as identifications of the saving format
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	840)     * so that compatible CPUs can have a check on format to decide
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	841)     * whether it can restore.
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	842)     */
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	843)    uint64_aligned_t         xfeature_mask;
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	844)    /*
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	845)     * SET: Size of struct (IN)
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	846)     * GET: Size of struct (IN/OUT)
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	847)     */
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	848)    uint64_aligned_t         size;
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	849)    XEN_GUEST_HANDLE_64(uint64) buffer;
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	850)};
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	851)typedef struct xen_domctl_vcpuextstate xen_domctl_vcpuextstate_t;
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	852)DEFINE_XEN_GUEST_HANDLE(xen_domctl_vcpuextstate_t);
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	853)#endif
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	854)
b4057928	(Joe Epstein	2011-01-07 11:54:42 +0000	855)/* XEN_DOMCTL_set_access_required: sets whether a memory event listener
b4057928	(Joe Epstein	2011-01-07 11:54:42 +0000	856) * must be present to handle page access events: if false, the page
b4057928	(Joe Epstein	2011-01-07 11:54:42 +0000	857) * access will revert to full permissions if no one is listening;
b4057928	(Joe Epstein	2011-01-07 11:54:42 +0000	858) *  */
b4057928	(Joe Epstein	2011-01-07 11:54:42 +0000	859)struct xen_domctl_set_access_required {
b4057928	(Joe Epstein	2011-01-07 11:54:42 +0000	860)    uint8_t access_required;
b4057928	(Joe Epstein	2011-01-07 11:54:42 +0000	861)};
b4057928	(Joe Epstein	2011-01-07 11:54:42 +0000	862)typedef struct xen_domctl_set_access_required xen_domctl_set_access_required_t;
b4057928	(Joe Epstein	2011-01-07 11:54:42 +0000	863)DEFINE_XEN_GUEST_HANDLE(xen_domctl_set_access_required_t);
b4057928	(Joe Epstein	2011-01-07 11:54:42 +0000	864)
b7a98e60	(Liu Jinsong	2012-12-06 10:47:22 +0000	865)struct xen_domctl_set_broken_page_p2m {
b7a98e60	(Liu Jinsong	2012-12-06 10:47:22 +0000	866)    uint64_aligned_t pfn;
b7a98e60	(Liu Jinsong	2012-12-06 10:47:22 +0000	867)};
b7a98e60	(Liu Jinsong	2012-12-06 10:47:22 +0000	868)typedef struct xen_domctl_set_broken_page_p2m xen_domctl_set_broken_page_p2m_t;
b7a98e60	(Liu Jinsong	2012-12-06 10:47:22 +0000	869)DEFINE_XEN_GUEST_HANDLE(xen_domctl_set_broken_page_p2m_t);
b7a98e60	(Liu Jinsong	2012-12-06 10:47:22 +0000	870)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	871)struct xen_domctl {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	872)    uint32_t cmd;
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	873)#define XEN_DOMCTL_createdomain                   1
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	874)#define XEN_DOMCTL_destroydomain                  2
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	875)#define XEN_DOMCTL_pausedomain                    3
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	876)#define XEN_DOMCTL_unpausedomain                  4
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	877)#define XEN_DOMCTL_getdomaininfo                  5
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	878)#define XEN_DOMCTL_getmemlist                     6
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	879)#define XEN_DOMCTL_getpageframeinfo               7
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	880)#define XEN_DOMCTL_getpageframeinfo2              8
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	881)#define XEN_DOMCTL_setvcpuaffinity                9
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	882)#define XEN_DOMCTL_shadow_op                     10
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	883)#define XEN_DOMCTL_max_mem                       11
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	884)#define XEN_DOMCTL_setvcpucontext                12
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	885)#define XEN_DOMCTL_getvcpucontext                13
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	886)#define XEN_DOMCTL_getvcpuinfo                   14
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	887)#define XEN_DOMCTL_max_vcpus                     15
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	888)#define XEN_DOMCTL_scheduler_op                  16
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	889)#define XEN_DOMCTL_setdomainhandle               17
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	890)#define XEN_DOMCTL_setdebugging                  18
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	891)#define XEN_DOMCTL_irq_permission                19
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	892)#define XEN_DOMCTL_iomem_permission              20
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	893)#define XEN_DOMCTL_ioport_permission             21
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	894)#define XEN_DOMCTL_hypercall_init                22
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	895)#define XEN_DOMCTL_arch_setup                    23
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	896)#define XEN_DOMCTL_settimeoffset                 24
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	897)#define XEN_DOMCTL_getvcpuaffinity               25
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	898)#define XEN_DOMCTL_real_mode_area                26
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	899)#define XEN_DOMCTL_resumedomain                  27
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	900)#define XEN_DOMCTL_sendtrigger                   28
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	901)#define XEN_DOMCTL_subscribe                     29
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	902)#define XEN_DOMCTL_gethvmcontext                 33
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	903)#define XEN_DOMCTL_sethvmcontext                 34
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	904)#define XEN_DOMCTL_set_address_size              35
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	905)#define XEN_DOMCTL_get_address_size              36
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	906)#define XEN_DOMCTL_assign_device                 37
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	907)#define XEN_DOMCTL_bind_pt_irq                   38
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	908)#define XEN_DOMCTL_memory_mapping                39
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	909)#define XEN_DOMCTL_ioport_mapping                40
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	910)#define XEN_DOMCTL_pin_mem_cacheattr             41
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	911)#define XEN_DOMCTL_set_ext_vcpucontext           42
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	912)#define XEN_DOMCTL_get_ext_vcpucontext           43
e567964a	(Ian Campbell	2012-09-12 17:55:27 +0100	913)#define XEN_DOMCTL_set_opt_feature               44 /* Obsolete IA64 only */
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	914)#define XEN_DOMCTL_test_assign_device            45
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	915)#define XEN_DOMCTL_set_target                    46
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	916)#define XEN_DOMCTL_deassign_device               47
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	917)#define XEN_DOMCTL_unbind_pt_irq                 48
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	918)#define XEN_DOMCTL_set_cpuid                     49
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	919)#define XEN_DOMCTL_get_device_group              50
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	920)#define XEN_DOMCTL_set_machine_address_size      51
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	921)#define XEN_DOMCTL_get_machine_address_size      52
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	922)#define XEN_DOMCTL_suppress_spurious_page_faults 53
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	923)#define XEN_DOMCTL_debug_op                      54
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	924)#define XEN_DOMCTL_gethvmcontext_partial         55
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	925)#define XEN_DOMCTL_mem_event_op                  56
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	926)#define XEN_DOMCTL_mem_sharing_op                57
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	927)#define XEN_DOMCTL_disable_migrate               58
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	928)#define XEN_DOMCTL_gettscinfo                    59
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	929)#define XEN_DOMCTL_settscinfo                    60
b3eb2c1e	(Keir Fraser	2010-01-13 08:14:01 +0000	930)#define XEN_DOMCTL_getpageframeinfo3             61
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	931)#define XEN_DOMCTL_setvcpuextstate               62
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	932)#define XEN_DOMCTL_getvcpuextstate               63
b4057928	(Joe Epstein	2011-01-07 11:54:42 +0000	933)#define XEN_DOMCTL_set_access_required           64
5e6ced10	(Andres Lagar-Cavilla	2011-12-01 14:56:42 +0000	934)#define XEN_DOMCTL_audit_p2m                     65
87521589	(Daniel De Graaf	2012-01-28 13:48:03 +0000	935)#define XEN_DOMCTL_set_virq_handler              66
b7a98e60	(Liu Jinsong	2012-12-06 10:47:22 +0000	936)#define XEN_DOMCTL_set_broken_page_p2m           67
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	937)#define XEN_DOMCTL_setnodeaffinity               68
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	938)#define XEN_DOMCTL_getnodeaffinity               69
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	939)#define XEN_DOMCTL_gdbsx_guestmemio            1000
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	940)#define XEN_DOMCTL_gdbsx_pausevcpu             1001
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	941)#define XEN_DOMCTL_gdbsx_unpausevcpu           1002
3cd5473c	(Keir Fraser	2010-01-04 10:35:16 +0000	942)#define XEN_DOMCTL_gdbsx_domstatus             1003
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	943)    uint32_t interface_version; /* XEN_DOMCTL_INTERFACE_VERSION */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	944)    domid_t  domain;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	945)    union {
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	946)        struct xen_domctl_createdomain      createdomain;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	947)        struct xen_domctl_getdomaininfo     getdomaininfo;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	948)        struct xen_domctl_getmemlist        getmemlist;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	949)        struct xen_domctl_getpageframeinfo  getpageframeinfo;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	950)        struct xen_domctl_getpageframeinfo2 getpageframeinfo2;
b3eb2c1e	(Keir Fraser	2010-01-13 08:14:01 +0000	951)        struct xen_domctl_getpageframeinfo3 getpageframeinfo3;
b5b79a12	(Dario Faggioli	2013-04-17 10:57:32 +0000	952)        struct xen_domctl_nodeaffinity      nodeaffinity;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	953)        struct xen_domctl_vcpuaffinity      vcpuaffinity;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	954)        struct xen_domctl_shadow_op         shadow_op;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	955)        struct xen_domctl_max_mem           max_mem;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	956)        struct xen_domctl_vcpucontext       vcpucontext;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	957)        struct xen_domctl_getvcpuinfo       getvcpuinfo;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	958)        struct xen_domctl_max_vcpus         max_vcpus;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	959)        struct xen_domctl_scheduler_op      scheduler_op;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	960)        struct xen_domctl_setdomainhandle   setdomainhandle;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	961)        struct xen_domctl_setdebugging      setdebugging;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	962)        struct xen_domctl_irq_permission    irq_permission;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	963)        struct xen_domctl_iomem_permission  iomem_permission;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	964)        struct xen_domctl_ioport_permission ioport_permission;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	965)        struct xen_domctl_hypercall_init    hypercall_init;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	966)        struct xen_domctl_arch_setup        arch_setup;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	967)        struct xen_domctl_settimeoffset     settimeoffset;
87cb99a6	(Keir Fraser	2009-10-20 08:45:12 +0100	968)        struct xen_domctl_disable_migrate   disable_migrate;
08a0b4ab	(Keir Fraser	2009-11-25 14:05:28 +0000	969)        struct xen_domctl_tsc_info          tsc_info;
f1cf580f	(Hollis Blanchard	2006-12-12 10:23:58 -0600	970)        struct xen_domctl_real_mode_area    real_mode_area;
294b0bdd	(Tim Deegan	2007-01-18 16:48:04 +0000	971)        struct xen_domctl_hvmcontext        hvmcontext;
1bb7e043	(Keir Fraser	2009-02-05 12:16:28 +0000	972)        struct xen_domctl_hvmcontext_partial hvmcontext_partial;
15fa4096	(kaf24@localhost.localdomain	2007-01-26 13:27:01 +0000	973)        struct xen_domctl_address_size      address_size;
da97fcd3	(Keir Fraser	2007-02-24 14:10:27 +0000	974)        struct xen_domctl_sendtrigger       sendtrigger;
491c0ade	(Keir Fraser	2008-05-28 14:41:23 +0100	975)        struct xen_domctl_get_device_group  get_device_group;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	976)        struct xen_domctl_assign_device     assign_device;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	977)        struct xen_domctl_bind_pt_irq       bind_pt_irq;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	978)        struct xen_domctl_memory_mapping    memory_mapping;
f8fc0c58	(kfraser@localhost.localdomain	2007-09-12 15:42:39 +0100	979)        struct xen_domctl_ioport_mapping    ioport_mapping;
907e0a60	(Keir Fraser	2007-10-23 14:38:47 +0100	980)        struct xen_domctl_pin_mem_cacheattr pin_mem_cacheattr;
3d98e9d1	(Keir Fraser	2007-10-25 14:24:52 +0100	981)        struct xen_domctl_ext_vcpucontext   ext_vcpucontext;
47fcfcb7	(Keir Fraser	2008-01-23 13:21:44 +0000	982)        struct xen_domctl_set_target        set_target;
4539594d	(Keir Fraser	2008-07-04 12:00:24 +0100	983)        struct xen_domctl_subscribe         subscribe;
74d59a59	(Keir Fraser	2008-12-16 11:49:20 +0000	984)        struct xen_domctl_debug_op          debug_op;
bd8fd8c1	(Keir Fraser	2009-12-17 06:27:55 +0000	985)        struct xen_domctl_mem_event_op      mem_event_op;
fa52adbc	(Keir Fraser	2009-12-17 06:27:56 +0000	986)        struct xen_domctl_mem_sharing_op    mem_sharing_op;
5f14a87c	(Keir Fraser	2008-04-25 13:44:45 +0100	987)#if defined(__i386__) || defined(__x86_64__)
5f14a87c	(Keir Fraser	2008-04-25 13:44:45 +0100	988)        struct xen_domctl_cpuid             cpuid;
47a3fb96	(Keir Fraser	2010-11-08 15:44:02 +0000	989)        struct xen_domctl_vcpuextstate      vcpuextstate;
5f14a87c	(Keir Fraser	2008-04-25 13:44:45 +0100	990)#endif
b4057928	(Joe Epstein	2011-01-07 11:54:42 +0000	991)        struct xen_domctl_set_access_required access_required;
5e6ced10	(Andres Lagar-Cavilla	2011-12-01 14:56:42 +0000	992)        struct xen_domctl_audit_p2m         audit_p2m;
87521589	(Daniel De Graaf	2012-01-28 13:48:03 +0000	993)        struct xen_domctl_set_virq_handler  set_virq_handler;
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	994)        struct xen_domctl_gdbsx_memio       gdbsx_guest_memio;
b7a98e60	(Liu Jinsong	2012-12-06 10:47:22 +0000	995)        struct xen_domctl_set_broken_page_p2m set_broken_page_p2m;
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	996)        struct xen_domctl_gdbsx_pauseunp_vcpu gdbsx_pauseunp_vcpu;
61f2a440	(Keir Fraser	2009-10-15 09:36:40 +0100	997)        struct xen_domctl_gdbsx_domstatus   gdbsx_domstatus;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	998)        uint8_t                             pad[128];
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	999)    } u;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1000)};
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1001)typedef struct xen_domctl xen_domctl_t;
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1002)DEFINE_XEN_GUEST_HANDLE(xen_domctl_t);
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1003)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1004)#endif /* __XEN_PUBLIC_DOMCTL_H__ */
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1005)
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1006)/*
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1007) * Local variables:
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1008) * mode: C
82639998	(David Vrabel	2013-02-21 16:12:46 +0000	1009) * c-file-style: "BSD"
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1010) * c-basic-offset: 4
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1011) * tab-width: 4
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1012) * indent-tabs-mode: nil
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1013) * End:
1df42147	(kfraser@localhost.localdomain	2006-08-25 18:39:10 +0100	1014) */
