/**
 *	My small debug macros which get stripped away when compiled without -DDEBUG.
 *	
 *	Thanks to http://www.redhat.com/docs/manuals/enterprise/RHEL-4-Manual/gcc/variadic-macros.html
 */

#ifndef DEBUGFU_H_DXPMYUJG
#define DEBUGFU_H_DXPMYUJG

#ifdef DEBUG
#define FULog(...) NSLog(__VA_ARGS__)
#define IF_DEBUG(WHTEVR) WHTEVR

#else
#define FULog(...)
#define IF_DEBUG(WHTEVR)

#endif


#endif /* end of include guard: DEBUGFU_H_DXPMYUJG */
