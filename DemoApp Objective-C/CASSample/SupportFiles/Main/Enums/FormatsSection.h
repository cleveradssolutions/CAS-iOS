//
//  FormatsSection.h
//  CASSample
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FormatsSection) {
    FormatsSectionAppOpen,
    FormatsSectionBanner,
    FormatsSectionNative,
    FormatsSectionNativeTemplate,
    FormatsSectionInterstitial,
    FormatsSectionRewarded
};

@interface FormatsSectionHelper : NSObject

+ (NSArray<NSNumber *> *)allCases;
+ (NSString *)titleForFormat:(FormatsSection)format;

@end
