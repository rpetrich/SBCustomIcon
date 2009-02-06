#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIAlertView.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <substrate.h>
#import <signal.h>
#import "SBApplication.h"
#import "UIApplication.h"

void MyHookInitialize() {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    SBApplication_Hook();
    UIApplication_Hook();
    [pool drain];
}