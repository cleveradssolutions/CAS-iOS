//
//  BannerAdDelegate.m
//  CASSample
//
//  Created by Денис Ешенко on 20.06.2022.
//

#import "BannerAdDelegate.h"

@implementation BannerAdDelegate
- (void)bannerAdViewDidLoad:(CASBannerView *)view {
	if(self.infoLabel) {
		self.infoLabel.text = @"Ready";
	}
    NSLog(@"[CAS Sample] Banner Ad loaded and ready to present");
}
- (void)bannerAdView:(CASBannerView *)adView didFailWith:(enum CASError)error {
	NSString * message = [NSString stringWithFormat: @"Error code %ld", (long)error];
	if(self.infoLabel) {
		self.infoLabel.text = message;
	}
	NSLog(@"[CAS Sample] Banner Ad did fail: %@", message);
}
- (void)bannerAdView:(CASBannerView *)adView willPresent:(id<CASStatusHandler>)impression {
    NSLog(@"[CAS Sample] Banner Ad will present");
}
- (void)bannerAdViewDidRecordClick:(CASBannerView *)adView {
    NSLog(@"[CAS Sample] Banner Ad did record click");
}
@end
