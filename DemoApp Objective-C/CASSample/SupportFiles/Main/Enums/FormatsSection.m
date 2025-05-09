//
//  FormatsSection.m
//  CASSample
//

#import "FormatsSection.h"

@implementation FormatsSectionHelper

+ (NSArray<NSNumber *> *)allCases {
    return @[
        @(FormatsSectionAppOpen),
        @(FormatsSectionBanner),
        @(FormatsSectionNative),
        @(FormatsSectionNativeTemplate),
        @(FormatsSectionInterstitial),
        @(FormatsSectionRewarded)
    ];
}

+ (NSString *)titleForFormat:(FormatsSection)format {
    switch (format) {
        case FormatsSectionAppOpen:
            return @"App Open";
        case FormatsSectionBanner:
            return @"Banner";
        case FormatsSectionNative:
            return @"Native";
        case FormatsSectionNativeTemplate:
            return @"Native Template";
        case FormatsSectionInterstitial:
            return @"Interstitial";
        case FormatsSectionRewarded:
            return @"Rewarded";
    }
}

@end
