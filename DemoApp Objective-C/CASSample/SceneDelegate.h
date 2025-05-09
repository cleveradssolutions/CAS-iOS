//
//  SceneDelegate.h
//  CASSample
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class AppCoordinator;

API_AVAILABLE(ios(14.0))
@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AppCoordinator *coordinator;

@end
