//
//  SceneDelegate.m
//  CASSample
//

#import "UIKit/UIKit.h"
#import "SceneDelegate.h"
#import "AppCoordinator.h"

@implementation SceneDelegate

- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
      options:(UISceneConnectionOptions *)connectionOptions {
    
    if ([scene isKindOfClass:[UIWindowScene class]]) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        
        self.coordinator = [[AppCoordinator alloc] initWithWindow:self.window];
        [self.coordinator start];
    }
}

@end
