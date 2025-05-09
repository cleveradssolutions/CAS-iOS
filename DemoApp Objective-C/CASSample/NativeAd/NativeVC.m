//
//  NativeVC.m
//  CASSample
//

#import "NativeVC.h"
#import "AppDelegate.h"

@interface NativeVC ()

@end

@implementation NativeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loaderSetup];
    [self registerAssetViews];
    
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.navigationItem.title = @"Native Ad";
}

- (void)loaderSetup {
    self.nativeLoader = [[CASNativeLoader alloc] initWithCasID: [AppDelegate casId]];
    self.nativeLoader.delegate = self;
    self.nativeLoader.adChoicesPlacement = CASChoicesPlacementTopRight;
    self.nativeLoader.isStartVideoMuted = YES;
}

- (void)registerAssetViews {
    self.nativeContainerView.headlineView = self.headlineLabel;
    self.nativeContainerView.bodyView = self.bodyLabel;
    self.nativeContainerView.iconView = self.iconView;
    self.nativeContainerView.mediaView = self.mediaView;
    self.nativeContainerView.callToActionView = self.actionButton;
}

- (IBAction)loadAction:(UIButton *)sender {
    [self.nativeLoader loadAd];
}

#pragma mark - CASImpressionDelegate

- (void)adDidRecordImpressionWithInfo:(CASContentInfo * _Nonnull)info {
    NSLog(@"adDidRecordImpressionWithInfo");
}

#pragma mark - CASNativeLoaderDelegate

- (void)nativeAdDidLoadContent:(CASNativeAdContent * _Nonnull)ad {
    ad.delegate = self;
    ad.impressionDelegate = self;
    ad.rootViewController = self;
    [self.nativeContainerView setNativeAd:ad];
}

- (void)nativeAdDidFailToLoadWithError:(CASError * _Nonnull)error {
    NSLog(@"nativeAdDidFailToLoadWithError %@", error.description);
}

#pragma mark - CASNativeAdContentDelegate

- (void)nativeAd:(CASNativeAdContent * _Nonnull)ad didFailToPresentWithError:(CASError * _Nonnull)error {
    NSLog(@"nativeAd:didFailToPresentWithError %@", error.description);
}

- (void)nativeAdDidClickContent:(CASNativeAdContent * _Nonnull)ad {
    NSLog(@"nativeAdDidClickContent");
}

@end
