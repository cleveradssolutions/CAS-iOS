//
//  AdDelegate.m
//  CASSample
//

#import "AdDelegate.h"

@implementation AdDelegate

- (id)initWithType:(CASType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

+ (NSString *)getNameOfType:(CASType)type{
    switch (type) {
        case CASTypeBanner:
            return @"Banner";
        case CASTypeInterstitial:
            return @"Interstitial";
        case CASTypeRewarded:
            return @"Rewarded";
        case CASTypeNative:
            return @"Native";
        default:
            return @"None";
    }
}

- (NSString *)getTypeName {
    return [AdDelegate getNameOfType:self.type];
}

- (void)willShownWithAd:(id<CASStatusHandler>)adStatus {
    if (_lastInfo) {
        [_lastInfo setText:adStatus.identifier];
        NSLog(@"[CAS Sample] %@d received Show action", [self getTypeName]);
    }
}

- (void)didShowAdFailedWithError:(NSString *)error {
    NSLog(@"[CAS Sample] %@d Ad show failed: %@d", [self getTypeName], error);
}

- (void)didClickedAd {
    NSLog(@"[CAS Sample] %@d Ad received Click action", [self getTypeName]);
}

- (void)didCompletedAd {
    NSLog(@"[CAS Sample] %@d Ad complete. You have been rewarded", [self getTypeName]);
}

- (void)didClosedAd {
    NSLog(@"[CAS Sample] %@d Ad received Close action", [self getTypeName]);
}

@end
