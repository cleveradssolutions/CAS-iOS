//
//  AppCoordinator.h
//  CASSample
//

#import <UIKit/UIKit.h>

@interface AppCoordinator : NSObject

- (instancetype)initWithWindow:(UIWindow *)window;
- (void)start;
- (void)navigateToBannerAd;
- (void)navigateToNativeAd;
- (void)navigateToNativeTemplateAd;
- (void)navigateToInterstitialAd;
- (void)navigateToRewardedAd;
- (void)navigateToAppOpenAd;
- (void)goBack;

@end
