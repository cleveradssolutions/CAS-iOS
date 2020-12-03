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
    [[CAS settings] setTrackLocationWithEnabled:YES];
    [[CAS settings] setInterstitialAdsWhenVideoCostAreLowerWithAllow:YES];

    // Inform SDK of the users details
    [[CAS targetingOptions] setAge:12];
    [[CAS targetingOptions] setGender:GenderFemale];

    // Validate integration. For develop only.
    [CAS validateIntegration];

    // CAS storage last created manager in strong static CAS.manager property
    CASMediationManager *manager =
        [CAS createWithManagerID:@"demo"
                     enableTypes:CASTypeInt.everything
                      demoAdMode:YES
                          onInit:^(BOOL complete, NSString *_Nullable error) {
                              NSLog(@"[CAS Sample] Mediation manager initialization: %s with error: %@",
                                    complete ? "true" : "false", error);
                          }];

    // Set banner size immediately after CAS.create
    [manager setBannerSize:[CASSize getSmartBanner]];

    return YES;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
