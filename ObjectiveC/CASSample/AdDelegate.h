//
//  AdDelegate.h
//  CASSample
//

#import <Foundation/Foundation.h>
#import <CleverAdsSolutions/CleverAdsSolutions-Swift.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdDelegate : NSObject<CASCallback>

- (id _Nonnull)initWithType:(CASType)type;

@property (nonatomic) CASType type;
@property (strong, nonatomic, nullable) UILabel *lastInfo;

+ (NSString *) getNameOfType:(CASType)type;
@end

NS_ASSUME_NONNULL_END
