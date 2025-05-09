//
//  NativeTemplateVC.h
//  CASSample
//

#import <UIKit/UIKit.h>
#import <CleverAdsSolutions/CleverAdsSolutions.h>

@interface NativeTemplateVC : UIViewController <CASImpressionDelegate, CASNativeLoaderDelegate, CASNativeAdContentDelegate>

@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, weak) IBOutlet CASNativeView *adView;

@property (nonatomic, strong) CASNativeLoader *nativeLoader;

- (IBAction)loadAction:(UIButton *)sender;

@end
