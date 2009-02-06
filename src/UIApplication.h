#import <UIKit/UIKit.h>
#import "UIApplication-SBCustomIcon.h"

@interface UIApplication ()
- (NSString*)pathForCustomIcon;
@end

BOOL UIApplication_Hook();