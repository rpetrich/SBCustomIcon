#import "SBApplication.h"
#import <objc/runtime.h>
#import <substrate.h>
#import <SpringBoard/SBIconModel.h>

static id $SBApplication_pathForIcon (SBApplication *self, SEL op) {
    if ([self willUseCustomIcon] && [self hasCustomIcon]) return [self pathForCustomIcon];
    else return [self h_pathForIcon];
}

static void $SBApplication_deactivated (SBApplication *self, SEL op) {
    [self h_deactivated];
    [self refreshIcon];
}

static void $SBApplication_exitedCommon (SBApplication *self, SEL op) {
    [self h_exitedCommon];
    if ([self customIconIsPersistent] == NO) [self removeCustomIcon];
    [self refreshIcon];
}

static BOOL $SBApplication_willUseCustomIcon (SBApplication *self, SEL op) {
    NSDictionary * bundleInfo = [[self bundle] infoDictionary];
    id value = [bundleInfo objectForKey:@"SBWillUseCustomIcon"];
    if([value respondsToSelector:@selector(boolValue)])
        return [value boolValue];
    return NO;
}

static BOOL $SBApplication_customIconIsPersistent (SBApplication *self, SEL op) {
    NSDictionary * bundleInfo = [[self bundle] infoDictionary];
    id value = [bundleInfo objectForKey:@"SBCustomIconIsPersistent"];
    if([value respondsToSelector:@selector(boolValue)])
        return [value boolValue];
    return NO;
}

static void $SBApplication_refreshIcon (SBApplication *self, SEL op) {
    SBIconModel *iconModel = [objc_getClass("SBIconModel") sharedInstance];
    if ([iconModel respondsToSelector:@selector(reloadIconImageForDisplayIdentifier:)])
	    [iconModel reloadIconImageForDisplayIdentifier:[self displayIdentifier]];
}

static NSString * $SBApplication_pathForCustomIcon (SBApplication *self, SEL op) {
    return [[@"/var/mobile/Library/Caches/Snapshots/" stringByAppendingPathComponent:[self bundleIdentifier]] stringByAppendingString:@"-Icon.png"];
}

static BOOL $SBApplication_hasCustomIcon (SBApplication *self, SEL op) {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self pathForCustomIcon]];
}

static void $SBApplication_removeCustomIcon (SBApplication *self, SEL op) {
    [[NSFileManager defaultManager] removeItemAtPath:[self pathForCustomIcon] error:NULL];
}

BOOL SBApplication_Hook() {
    Class SBApplication = objc_getClass("SBApplication");
    if (SBApplication == nil) return NO;
    
    MSHookMessage(SBApplication, @selector(pathForIcon), (IMP) &$SBApplication_pathForIcon, "h_");
    MSHookMessage(SBApplication, @selector(deactivated), (IMP) &$SBApplication_deactivated, "h_");
    MSHookMessage(SBApplication, @selector(exitedCommon), (IMP) &$SBApplication_exitedCommon, "h_");
    
    class_addMethod(SBApplication, @selector(willUseCustomIcon), (IMP) &$SBApplication_willUseCustomIcon, "c@:");
    class_addMethod(SBApplication, @selector(hasCustomIcon), (IMP) &$SBApplication_hasCustomIcon, "c@:");
    class_addMethod(SBApplication, @selector(customIconIsPersistent), (IMP) &$SBApplication_customIconIsPersistent, "c@:");
    class_addMethod(SBApplication, @selector(pathForCustomIcon), (IMP) &$SBApplication_pathForCustomIcon, "@@:");
    class_addMethod(SBApplication, @selector(removeCustomIcon), (IMP) &$SBApplication_removeCustomIcon, "v@:");
    class_addMethod(SBApplication, @selector(refreshIcon), (IMP) &$SBApplication_refreshIcon, "v@:");
    return YES;
}