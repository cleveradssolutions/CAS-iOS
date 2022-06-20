//
//  ViewController.m
//  CASSample
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

BOOL isAppReturnEnable = false;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.bannerDelegate = [[BannerAdDelegate alloc] init];
    self.bannerDelegate.infoLabel = self.statusBannerLabel;
	self.interDelegate = [[AdDelegate alloc] initWithType:CASTypeInterstitial];
	self.rewardDelegate = [[AdDelegate alloc] initWithType:CASTypeRewarded];


	[self.versionLabel setText:[CAS getSDKVersion]];

	CASMediationManager *manager = [AppDelegate getMediationManager];
	[manager setAdLoadDelegate:self];

	// Create Banner view from Code
	//[self createBannerView];
	// Else use Banner view from Storyboard

	[self.bannerView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.bannerView setAdSize:[CASSize getSmartBanner]];
	[self.bannerView setRootViewController:self];
	[self.bannerView setAdDelegate:self.bannerDelegate];

	self.statusBannerLabel.text = _bannerView.isAdReady ? @"Ready" : @"Loading";
	self.statusInterstitialLabel.text = manager.isInterstitialReady ? @"Ready" : @"Loading";
	self.statusRewardedLabel.text = manager.isRewardedAdReady ? @"Ready" : @"Loading";
}

-(void)createBannerView {
	CASSize *size = [CASSize getSmartBanner];
	CASMediationManager* manager = [AppDelegate getMediationManager];
	self.bannerView = [[CASBannerView alloc] initWithAdSize:size manager:manager];

	[self.view addSubview:self.bannerView];

	if (@available(iOS 11.0, *)) {
		UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
		[NSLayoutConstraint activateConstraints:@[
			 [NSLayoutConstraint constraintWithItem:self.bannerView
			  attribute:NSLayoutAttributeBottom
			  relatedBy:NSLayoutRelationEqual
			  toItem:guide
			  attribute:NSLayoutAttributeBottom
			  multiplier:1
			  constant:0],
			 [NSLayoutConstraint constraintWithItem:self.bannerView
			  attribute:NSLayoutAttributeRight
			  relatedBy:NSLayoutRelationEqual
			  toItem:guide
			  attribute:NSLayoutAttributeRight
			  multiplier:1
			  constant:0]
		]];
	} else {
		[NSLayoutConstraint activateConstraints:@[
			 [NSLayoutConstraint constraintWithItem:self.bannerView
			  attribute:NSLayoutAttributeBottom
			  relatedBy:NSLayoutRelationEqual
			  toItem:self.view
			  attribute:NSLayoutAttributeBottom
			  multiplier:1
			  constant:0],
			 [NSLayoutConstraint constraintWithItem:self.bannerView
			  attribute:NSLayoutAttributeRight
			  relatedBy:NSLayoutRelationEqual
			  toItem:self.view
			  attribute:NSLayoutAttributeRight
			  multiplier:1
			  constant:0]
		]];
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
	CASMediationManager* manager = [AppDelegate getMediationManager];
	[manager presentInterstitialFromRootViewController:self callback:self.interDelegate];
}

- (IBAction)showRewarded:(id)sender {
	CASMediationManager* manager = [AppDelegate getMediationManager];
	[manager presentRewardedAdFromRootViewController:self callback:self.rewardDelegate];
}

- (IBAction)changeStateOfAppReturn {
	if (isAppReturnEnable) {
		_appReturnStatusLabel.text = @"Disabled";
		[_changeStateOfAppReturnButton setTitle:@"Enable" forState:UIControlStateNormal];
		[CAS.manager disableAppReturnAds];
		isAppReturnEnable = false;
	} else {
		_appReturnStatusLabel.text = @"Enabled";
		[_changeStateOfAppReturnButton setTitle:@"Disable" forState:UIControlStateNormal];
		[CAS.manager enableAppReturnAdsWith:self];
		isAppReturnEnable = true;
	}
}

#pragma mark CASLoadDelegate implementation
- (void)onAdLoaded:(enum CASType)adType {
	// CASLoadDelegate called from background thread. To use UI API we switch to main thread.
	dispatch_async(dispatch_get_main_queue(), ^{
		switch (adType) {
		case CASTypeInterstitial:
			NSLog(@"[CAS Sample] Interstitial Ad loaded and ready to present");
			self.statusInterstitialLabel.text = @"Ready";
			break;
		case CASTypeRewarded:
			NSLog(@"[CAS Sample] Rewarded Ad loaded and ready to present");
			self.statusRewardedLabel.text = @"Ready";
			break;
		case CASTypeBanner:
			// CASLoadDelegate protocol should be used to listen Interstitial and Rewarded Ads only.
			// Listen Banner ads by CASBannerDelegate protocol.
			break;
		default:
			break;
		}
	});
}

- (void)onAdFailedToLoad:(enum CASType) adType withError:(NSString *)error {
	// CASLoadDelegate called from background thread. To use UI API we switch to main thread.
	dispatch_async(dispatch_get_main_queue(), ^{
		switch (adType) {
		case CASTypeInterstitial:
			NSLog(@"[CAS Sample] Interstitial Ad failed to load with error: %@", error);
			self.statusInterstitialLabel.text = @"Ready";
			break;
		case CASTypeRewarded:
			NSLog(@"[CAS Sample] Rewarded Ad failed to load with error: %@", error);
			self.statusRewardedLabel.text = @"Ready";
			break;
		case CASTypeBanner:
			// CASLoadDelegate protocol should be used to listen Interstitial and Rewarded Ads only.
			// Listen Banner ads by CASBannerDelegate protocol.
			break;
		default:
			break;
		}
	});
}

#pragma mark CASAppReturnDelegate implementation
- (UIViewController *)viewControllerForPresentingAppReturnAd {
	return self;
}

@end
