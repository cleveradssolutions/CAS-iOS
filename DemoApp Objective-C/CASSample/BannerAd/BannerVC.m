//
//  BannerVC.m
//  CASSample
//

#import "BannerVC.h"

@interface BannerVC ()

@end

@implementation BannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBanner];
    [self setupBannerButton];
    
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    self.navigationItem.title = @"Banner Ad";
}

- (void)setupBanner {
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bannerView.adSize = [CASSize getAdaptiveBannerInContainer:self.view];
    self.bannerView.casID = @"demo";
    self.bannerView.delegate = self;
    self.bannerView.impressionDelegate = self;
    self.bannerView.rootViewController = self;
    self.bannerView.isAutoloadEnabled = true;
}

- (void)setupBannerButton {
    UIAction *adaptive = [UIAction actionWithTitle:@"Adaptive"
                                             image:nil
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
        self.bannerView.adSize = [CASSize getAdaptiveBannerInContainer:self.view];
        [self.bannerSizeButton setTitle:@"Adaptive" forState:UIControlStateNormal];
    }];

    UIAction *standard = [UIAction actionWithTitle:@"Standard 320x50"
                                             image:nil
                                        identifier:nil
                                           handler:^(__kindof UIAction * _Nonnull action) {
        self.bannerView.adSize = [CASSize banner];
        [self.bannerSizeButton setTitle:@"Standard" forState:UIControlStateNormal];
    }];
    
    UIAction *leaderboard = [UIAction actionWithTitle:@"Leaderboard 728x90"
                                                image:nil
                                           identifier:nil
                                              handler:^(__kindof UIAction * _Nonnull action) {
        self.bannerView.adSize = [CASSize leaderboard];
        [self.bannerSizeButton setTitle:@"Standard" forState:UIControlStateNormal];
    }];
    
    UIAction *medium = [UIAction actionWithTitle:@"Medium 300x250"
                                           image:nil
                                      identifier:nil
                                         handler:^(__kindof UIAction * _Nonnull action) {
        self.bannerView.adSize = [CASSize mediumRectangle];
        [self.bannerSizeButton setTitle:@"Standard" forState:UIControlStateNormal];
    }];
    
    UIAction *smart = [UIAction actionWithTitle:@"Smart 320x50 or 728x90"
                                          image:nil
                                     identifier:nil
                                        handler:^(__kindof UIAction * _Nonnull action) {
        self.bannerView.adSize = [CASSize getSmartBanner];
        [self.bannerSizeButton setTitle:@"Standard" forState:UIControlStateNormal];
    }];
            
    UIMenu *menu = [UIMenu menuWithTitle:@"" image:nil identifier:nil options:UIMenuOptionsDisplayInline children:@[adaptive, standard, leaderboard, medium, smart]];
    self.bannerSizeButton.menu = menu;
    self.bannerSizeButton.showsMenuAsPrimaryAction = YES;
}

- (IBAction)loadAction:(id)sender {
    [self.bannerView loadAd];
}

#pragma mark - CASImpressionDelegate

- (void)adDidRecordImpressionWithInfo:(CASContentInfo *)info {
    NSLog(@"adDidRecordImpressionWithInfo");
}

#pragma mark - CASBannerDelegate

- (void)bannerAdViewDidLoad:(CASBannerView *)view {
    NSLog(@"bannerAdViewDidLoad");
}

- (void)bannerAdView:(CASBannerView *)adView didFailWith:(CASError *)error {
    NSLog(@"bannerAdView:didFailWith %@", error.description);
}

- (void)bannerAdViewDidRecordClick:(CASBannerView *)adView {
    NSLog(@"bannerAdViewDidRecordClick");
}

@end
