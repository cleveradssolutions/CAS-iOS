//
//  ViewController.h
//  CASSample
//

#import <UIKit/UIKit.h>
#import <CleverAdsSolutions/CleverAdsSolutions-Swift.h>
#import "AdDelegate.h"

@interface ViewController : UIViewController<CASLoadDelegate, CASAppReturnDelegate>
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastBannerLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastInterstitialLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastRewardedInfo;
@property (strong, nonatomic) IBOutlet CASBannerView *bannerView;

@property (nonatomic, strong, nonnull) AdDelegate *bannerDelegate;
@property (nonatomic, strong, nonnull) AdDelegate *interDelegate;
@property (nonatomic, strong, nonnull) AdDelegate *rewardDelegate;

@property (strong, nonatomic) IBOutlet UILabel *appReturnStatusLabel;
@property (strong, nonatomic) IBOutlet UIButton *changeStateOfAppReturnButton;
@end

