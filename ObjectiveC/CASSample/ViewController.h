//
//  ViewController.h
//  CASSample
//

#import <UIKit/UIKit.h>
#import <CleverAdsSolutions/CleverAdsSolutions-Swift.h>
#import "AdDelegate.h"
#import "BannerAdDelegate.h"

@interface ViewController : UIViewController<CASLoadDelegate, CASAppReturnDelegate>
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet CASBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *statusBannerLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusInterstitialLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusRewardedLabel;

@property (nonatomic, strong, nonnull) BannerAdDelegate *bannerDelegate;
@property (nonatomic, strong, nonnull) AdDelegate *interDelegate;
@property (nonatomic, strong, nonnull) AdDelegate *rewardDelegate;

@property (strong, nonatomic) IBOutlet UILabel *appReturnStatusLabel;
@property (strong, nonatomic) IBOutlet UIButton *changeStateOfAppReturnButton;
@end

