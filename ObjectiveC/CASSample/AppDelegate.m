//
//  AppDelegate.m
//  CASSample
//

#import "AppDelegate.h"
#import <CleverAdsSolutions/CleverAdsSolutions-Swift.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // Set any CAS Settings before CAS.create
    [[CAS settings] setDebugMode:YES];
    //[[CAS settings] updateUserWithConsent:CASConsentStatusAccepted];
    //[[CAS settings] updateCCPAWithStatus:CASCCPAStatusOptInSale];
    //[[CAS settings] setTaggedWithAudience:CASAudienceNotChildren];

    // CAS storage last created manager in strong static CAS.manager property
    CASMediationManager *manager =
        [CAS createWithManagerID:@"demo"
                     enableTypes:CASTypeInt.everything
                      demoAdMode:YES
                          onInit:^(BOOL complete, NSString *_Nullable error) {
        NSLog(@"[CAS Sample] Mediation manager initialization: %s with error: %@", complete ? "true" : "false", error);
    }];

    // Set banner size immediately after CAS.create
    [manager setBannerSize:[CASSize getSmartBanner]];
    
    return YES;
}

@end
