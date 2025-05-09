//
//  InterstitialVC.m
//  CASSample
//

#import "AppDelegate.h"
#import "InterstitialVC.h"

@interface InterstitialVC ()

@property (strong, nonatomic) CASInterstitial *interstitial;

@end

@implementation InterstitialVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.interstitial = [[CASInterstitial alloc] initWithCasID: [AppDelegate casId]];
    self.interstitial.delegate = self;
    self.interstitial.impressionDelegate = self;
    
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.navigationItem.title = @"Interstitial Ad";
}

- (IBAction)loadAction:(UIButton *)sender {
    [self.interstitial loadAd];
}

- (IBAction)showAction:(UIButton *)sender {
    [self.interstitial presentFromViewController:self];
}

#pragma mark - CASImpressionDelegate

- (void)adDidRecordImpressionWithInfo:(CASContentInfo *)info {
    NSLog(@"adDidRecordImpressionWithInfo");
}


#pragma mark - CASScreenContentDelegate

- (void)screenAdDidLoadContent:(id<CASScreenContent>)ad {
    NSLog(@"screenAdDidLoadContent");
}

- (void)screenAd:(id<CASScreenContent>)ad didFailToLoadWithError:(CASError *)error {
    NSLog(@"screenAd:didFailToLoadWithError %@", error.description);
}

- (void)screenAdWillPresentContent:(id<CASScreenContent>)ad {
    NSLog(@"screenAdWillPresentContent");
}

- (void)screenAd:(id<CASScreenContent>)ad didFailToPresentWithError:(CASError *)error {
    NSLog(@"screenAd:didFailToPresentWithError %@", error.description);
}

- (void)screenAdDidClickContent:(id<CASScreenContent>)ad {
    NSLog(@"screenAdDidClickContent");
}

- (void)screenAdDidDismissContent:(id<CASScreenContent>)ad {
    NSLog(@"screenAdDidDismissContent");
}

@end
