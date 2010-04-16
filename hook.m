#import <Foundation/Foundation.h>
#import "SBApplication.h"
#import "UIApplication.h"

__attribute__((constructor))
static void SBCustomIconInitialize() {
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    SBApplication_Hook();
    UIApplication_Hook();
    [pool release];
}