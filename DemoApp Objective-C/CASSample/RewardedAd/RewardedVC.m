//
//  RewardedVC.m
//  CASSample
//

#import "RewardedVC.h"
#import "AppDelegate.h"

@interface RewardedVC ()

@property (strong, nonatomic) CASRewarded *rewarded;

@end

@implementation RewardedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rewarded = [[CASRewarded alloc] initWithCasID: [AppDelegate casId]];
    self.rewarded.delegate = self;
    self.rewarded.impressionDelegate = self;
    
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.navigationItem.title = @"Rewarded Ad";
}

- (IBAction)loadAction:(UIButton *)sender {
    [self.rewarded loadAd];
}

- (IBAction)showAction:(UIButton *)sender {
    [self.rewarded presentFromViewController:self userDidEarnRewardHandler: ^(id rewarded) {
        NSLog(@"userDidEarnRewardHandler");
    }];
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
