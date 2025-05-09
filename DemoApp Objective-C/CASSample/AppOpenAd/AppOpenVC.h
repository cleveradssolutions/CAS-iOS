//
//  AppOpenVC.h
//  CASSample
//

#import <UIKit/UIKit.h>
#import <CleverAdsSolutions/CleverAdsSolutions.h>

@class AppCoordinator;

@interface AppOpenVC : UIViewController <CASScreenContentDelegate, CASImpressionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@property (nonatomic, weak) AppCoordinator *coordinator;

@end
