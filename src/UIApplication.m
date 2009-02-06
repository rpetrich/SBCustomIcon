#import "UIApplication.h"

static NSString * $UIApplication_pathForCustomIcon (UIApplication *self, SEL op) {
    NSString * bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    return [[@"/var/mobile/Library/Caches/Snapshots/" stringByAppendingPathComponent:bundleIdentifier] stringByAppendingString:@"-Icon.png"];
}

static BOOL $UIApplication_setCustomIcon$ (UIApplication * self, SEL op, UIImage * customIcon) {
    if (customIcon == nil) return NO;
    NSData * iconData = UIImagePNGRepresentation(customIcon);
    if (iconData == nil) return NO;
    return [iconData writeToFile:[self pathForCustomIcon] atomically:YES];
}

static BOOL $UIApplication_setCustomIconFile$ (UIApplication * self, SEL op, NSString * customIconFile) {
    [self removeCustomIcon];
    return [[NSFileManager defaultManager] copyItemAtPath:customIconFile toPath:[self pathForCustomIcon] error:NULL];
}

static void $UIApplication_removeCustomIcon (UIApplication * self, SEL op) {
    [[NSFileManager defaultManager] removeItemAtPath:[self pathForCustomIcon] error:NULL];
}

static BOOL $UIApplication_hasCustomIcon (UIApplication * self, SEL op) {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self pathForCustomIcon]];
}

BOOL UIApplication_Hook() {
    Class UIApplication = objc_getClass("UIApplication");
    if (UIApplication == nil) return NO;
    
    class_addMethod(UIApplication, @selector(pathForCustomIcon), (IMP) &$UIApplication_pathForCustomIcon, "@@:");
    class_addMethod(UIApplication, @selector(setCustomIcon:), (IMP) &$UIApplication_setCustomIcon$, "c@:@");
    class_addMethod(UIApplication, @selector(setCustomIconFile:), (IMP) &$UIApplication_setCustomIconFile$, "c@:@");
    class_addMethod(UIApplication, @selector(removeCustomIcon), (IMP) &$UIApplication_removeCustomIcon, "v@:");
    class_addMethod(UIApplication, @selector(hasCustomIcon), (IMP) &$UIApplication_hasCustomIcon, "c@:");
    return YES;
}