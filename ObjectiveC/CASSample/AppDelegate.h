//
//  AppDelegate.h
//  CASSample
//

#import <UIKit/UIKit.h>
@import CleverAdsSolutions;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

+ (CASMediationManager *) getMediationManager;
@end

