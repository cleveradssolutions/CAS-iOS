//
//  AppDelegate.m
//  CASSample
//

#import "AppDelegate.h"

@implementation AppDelegate

+ (NSString *)casId {
    return @"demo";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeCAS];
    return YES;
}

- (void)initializeCAS {
    CASManagerBuilder *builder = [CAS buildManager];
    
    [builder withCompletionHandler:^(CASInitialConfig *config) {
        NSString *error = config.error;
        NSString *userCountryISO2 = config.countryCode;
        BOOL protectionApplied = config.isConsentRequired;
        CASConsentFlowStatus consentStatus = config.consentFlowStatus;
        BOOL trackingAuthorized = config.isATTrackingAuthorized;
    }];
        
    [builder createWithCasId:[AppDelegate casId]];
}

- (UISceneConfiguration *)application:(UIApplication *)application
configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
                               options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application
didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Optional: Handle discarded scene sessions
}

@end
