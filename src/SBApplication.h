#import <UIKit/UIKit.h>
#import <SpringBoard/SBApplication.h>

@interface SBApplication ()
// hooked methods
- (id)h_pathForIcon;
- (void)h_deactivated;
- (void)h_exitedCommon;

// added methods
- (BOOL)willUseCustomIcon;
- (BOOL)customIconIsPersistent;
- (BOOL)hasCustomIcon;
- (NSString*)pathForCustomIcon;
- (void)refreshIcon;
- (void)removeCustomIcon;
@end

BOOL SBApplication_Hook();