//
//  ViewController.m
//  CASSample
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerDelegate = [[AdDelegate alloc] initWithType:CASTypeBanner];
    self.interDelegate = [[AdDelegate alloc] initWithType:CASTypeInterstitial];
    self.rewardDelegate = [[AdDelegate alloc] initWithType:CASTypeRewarded];

    self.bannerDelegate.lastInfo = self.lastBannerLabel;
    self.interDelegate.lastInfo = self.lastInterstitialLabel;
    self.rewardDelegate.lastInfo = self.lastRewardedInfo;

    [self.versionLabel setText:[CAS getSDKVersion]];

    CASMediationManager *manager = [CAS manager];
    if (manager) {
        [self.lastBannerLabel setText:[manager getLastActiveMediationWithType:CASTypeBanner]];
        [self.lastInterstitialLabel setText:[manager getLastActiveMediationWithType:CASTypeInterstitial]];
        [self.lastRewardedInfo setText:[manager getLastActiveMediationWithType:CASTypeRewarded]];

        [[CAS manager] setAdLoadDelegate:self];

        //self.bannerView = [[CASBannerView alloc] initWithManager:manager];
        
        [self.bannerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.bannerView setRootViewController:self];
        [self.bannerView setDelegate:self.bannerDelegate];
        
        //[self.view addSubview:self.bannerView];

//        if (@available(iOS 11.0, *)) {
//            UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
//            [NSLayoutConstraint activateConstraints:@[
//                 [NSLayoutConstraint constraintWithItem:self.bannerTest
//                                              attribute:NSLayoutAttributeBottom
//                                              relatedBy:NSLayoutRelationEqual
//                                                 toItem:guide
//                                              attribute:NSLayoutAttributeBottom
//                                             multiplier:1
//                                               constant:0],
//                 [NSLayoutConstraint constraintWithItem:self.bannerTest
//                                              attribute:NSLayoutAttributeRight
//                                              relatedBy:NSLayoutRelationEqual
//                                                 toItem:guide
//                                              attribute:NSLayoutAttributeRight
//                                             multiplier:1
//                                               constant:0]
//            ]];
//        } else {
//            [NSLayoutConstraint activateConstraints:@[
//                 [NSLayoutConstraint constraintWithItem:self.bannerTest
//                                              attribute:NSLayoutAttributeBottom
//                                              relatedBy:NSLayoutRelationEqual
//                                                 toItem:self.view
//                                              attribute:NSLayoutAttributeBottom
//                                             multiplier:1
//                                               constant:0],
//                 [NSLayoutConstraint constraintWithItem:self.bannerTest
//                                              attribute:NSLayoutAttributeRight
//                                              relatedBy:NSLayoutRelationEqual
//                                                 toItem:self.view
//                                              attribute:NSLayoutAttributeRight
//                                             multiplier:1
//                                               constant:0]
//            ]];
//        }
    }
}

- (IBAction)showBanner:(id)sender {
    [self.bannerView setHidden:NO];
}

- (IBAction)hideBanner:(id)sender {
    [self.bannerView setHidden:YES];
}

- (IBAction)setBannerSize:(id)sender {
    [self.bannerView setAdSize:CASSize.banner];
}

- (IBAction)setLeaderboardSize:(id)sender {
    [self.bannerView setAdSize:CASSize.leaderboard];
}

- (IBAction)setMrecSize:(id)sender {
    [self.bannerView setAdSize:CASSize.mediumRectangle];
}

- (IBAction)setAdaptiveSize:(id)sender {
    [self.bannerView setAdSize:[CASSize getAdaptiveBannerInContainer:self.view]];
}

- (IBAction)setSmartSize:(id)sender {
    [self.bannerView setAdSize:[CASSize getSmartBanner]];
}

- (IBAction)showInterstitial:(id)sender {
    if (CAS.manager) {
        [CAS.manager showFromRootViewController:self type:CASTypeInterstitial callback:self.interDelegate];
    }
}

- (IBAction)showRewarded:(id)sender {
    if (CAS.manager) {
        [CAS.manager showFromRootViewController:self type:CASTypeRewarded callback:self.rewardDelegate];
    }
}

- (void)onAdLoaded:(enum CASType)adType {
    NSLog(@"[CAS Sample] %@d Ad loaded and ready to show", [AdDelegate getNameOfType:adType]);
}

- (void)onAdFailedToLoad:(enum CASType) adType withError:(NSString *)error {
    NSLog(@"[CAS Sample] %@d Ad failed to load with error: %@d", [AdDelegate getNameOfType:adType], error);
}

@end
