//
//  BannerVC.h
//  CASSample
//

#import <UIKit/UIKit.h>
#import <CleverAdsSolutions/CleverAdsSolutions.h>

@class AppCoordinator;

@interface BannerVC : UIViewController <CASBannerDelegate, CASImpressionDelegate>

@property (nonatomic, weak) AppCoordinator *coordinator;

@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIButton *bannerSizeButton;
@property (weak, nonatomic) IBOutlet CASBannerView *bannerView;

@end
