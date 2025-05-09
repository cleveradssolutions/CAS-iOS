//
//  NativeVC.h
//  CASSample
//

#import <UIKit/UIKit.h>
#import <CleverAdsSolutions/CleverAdsSolutions.h>

@interface NativeVC : UIViewController <CASImpressionDelegate, CASNativeLoaderDelegate, CASNativeAdContentDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet CASNativeView *nativeContainerView;
@property (weak, nonatomic) IBOutlet UIStackView *adStackView;
@property (weak, nonatomic) IBOutlet UILabel *adLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet CASMediaView *mediaView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (strong, nonatomic) CASNativeLoader *nativeLoader;

- (IBAction)loadAction:(UIButton *)sender;

@end
