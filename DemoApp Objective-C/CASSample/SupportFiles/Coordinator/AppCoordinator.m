//
//  AppCoordinator.m
//  CASSample
//

#import "AppCoordinator.h"
#import "MainVC.h"
#import "BannerVC.h"
#import "InterstitialVC.h"
#import "RewardedVC.h"
#import "AppOpenVC.h"
#import "NativeVC.h"
#import "NativeTemplateVC.h"

@interface AppCoordinator ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIStoryboard *storyboard;
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation AppCoordinator

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        _window = window;
        _storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    return self;
}

- (void)start {
    MainVC *mainVC = (MainVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
    mainVC.coordinator = self;

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
}

- (void)navigateToBannerAd {
    BannerVC *vc = (BannerVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"BannerVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToNativeAd {
    NativeVC *vc = (NativeVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"NativeVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToNativeTemplateAd {
    NativeTemplateVC *vc = (NativeTemplateVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"NativeTemplateVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToInterstitialAd {
    InterstitialVC *vc = (InterstitialVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"InterstitialVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToRewardedAd {
    RewardedVC *vc = (RewardedVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"RewardedVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigateToAppOpenAd {
    AppOpenVC *vc = (AppOpenVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"AppOpenVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
