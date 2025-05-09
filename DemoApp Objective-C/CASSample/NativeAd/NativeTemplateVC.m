//
//  NativeTemplateVC.m
//  CASSample
//

#import "AppDelegate.h"
#import "NativeTemplateVC.h"

@interface NativeTemplateVC ()

@end

@implementation NativeTemplateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sizeSetup];
    [self loaderSetup];
    [self customizeAdViewAppearance];
    
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.navigationItem.title = @"Native Template Ad";
}

- (void)sizeSetup {
    CASSize *size = [CASSize mediumRectangle];
    [self.adView setAdTemplateSize:size];
}

- (void)loaderSetup {
    self.nativeLoader = [[CASNativeLoader alloc] initWithCasID: [AppDelegate casId]];
    self.nativeLoader.delegate = self;
    self.nativeLoader.adChoicesPlacement = CASChoicesPlacementTopRight;
    self.nativeLoader.isStartVideoMuted = YES;
}

- (void)customizeAdViewAppearance {
    self.adView.backgroundColor = [UIColor whiteColor];
    self.adView.headlineView.textColor = [UIColor redColor];
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
    [self.adView setNativeAd:ad];
    NSLog(@"nativeAdDidLoadContent");
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
