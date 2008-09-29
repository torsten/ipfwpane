/**
 *	My small debug macro which gets stripped when compiled without -DDEBUG.
 *
 *	Thanks to http://www.redhat.com/docs/manuals/enterprise/RHEL-4-Manual/gcc/variadic-macros.html
 */

#ifndef DEBUGFU_H_DXPMYUJG
#define DEBUGFU_H_DXPMYUJG

#ifdef DEBUG
#define FULog(...) NSLog(__VA_ARGS__)

#else
#define FULog(...)

#endif


#endif /* end of include guard: DEBUGFU_H_DXPMYUJG */
