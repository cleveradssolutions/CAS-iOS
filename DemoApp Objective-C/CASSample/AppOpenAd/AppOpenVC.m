//
//  AppOpenVC.m
//  CASSample
//

#import "AppOpenVC.h"
#import "AppDelegate.h"

@interface AppOpenVC ()

@property (strong, nonatomic) CASAppOpen *appOpen;

@end

@implementation AppOpenVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.appOpen = [[CASAppOpen alloc] initWithCasID: [AppDelegate casId]];
    self.appOpen.delegate = self;
    self.appOpen.impressionDelegate = self;
    
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.navigationItem.title = @"App Open Ad";
}

- (IBAction)loadAction:(UIButton *)sender {
    [self.appOpen loadAd];
}

- (IBAction)showAction:(UIButton *)sender {
    [self.appOpen presentFromViewController:self];
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
