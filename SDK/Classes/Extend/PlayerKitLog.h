
#import <Foundation/Foundation.h>

#ifdef DEBUG
#define MCLog(fmt, ...) NSLog([NSString stringWithFormat:@"[INFO] %s(%d) %@", __FUNCTION__, __LINE__, fmt],##__VA_ARGS__,nil)
#else
#define MCLog(fmt, ...)
#endif