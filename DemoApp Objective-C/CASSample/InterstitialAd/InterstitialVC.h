//
//  InterstitialVC.h
//  CASSample
//

#import <CleverAdsSolutions/CleverAdsSolutions.h>

@class AppCoordinator;

@interface InterstitialVC : UIViewController <CASScreenContentDelegate, CASImpressionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@property (nonatomic, weak) AppCoordinator *coordinator;

@end
