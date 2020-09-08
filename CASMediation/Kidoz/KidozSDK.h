//
//  KidozSDK.h
//  KidozSDK
//
//  Created by Lev Firer on 14/11/2017.
//  Copyright © 2017 kidoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol KDZInterstitialDelegate <NSObject>
-(void)interstitialDidInitialize;
-(void)interstitialDidClose;
-(void)interstitialDidOpen;
-(void)interstitialIsReady;
-(void)interstitialReturnedWithNoOffers;
-(void)interstitialDidPause;
-(void)interstitialDidResume;
-(void)interstitialLoadFailed;
-(void)interstitialDidReciveError:(NSString*)errorMessage;
-(void)interstitialLeftApplication;
@end

@protocol KDZRewardedDelegate <NSObject>
-(void)rewardedDidInitialize;
-(void)rewardedDidClose;
-(void)rewardedDidOpen;
-(void)rewardedIsReady;
-(void)rewardedReturnedWithNoOffers;
-(void)rewardedDidPause;
-(void)rewardedDidResume;
-(void)rewardedLoadFailed;
-(void)rewardedDidReciveError:(NSString*)errorMessage;
-(void)rewardReceived;
-(void)rewardedStarted;
-(void)rewardedLeftApplication;
@end


@protocol KDZInitDelegate <NSObject>
@optional
-(void)onInitSuccess;
-(void)onInitError:(NSString *)error;
@end


@protocol KDZBannerDelegate <NSObject>
-(void)bannerDidInitialize;
-(void)bannerDidClose;
-(void)bannerDidOpen;
-(void)bannerIsReady;
-(void)bannerReturnedWithNoOffers;
-(void)bannerLoadFailed;
-(void)bannerDidReciveError:(NSString*)errorMessage;
-(void)bannerLeftApplication;
@end


typedef enum {
  BOTTOM_CENTER,TOP_LEFT,TOP_CENTER,TOP_RIGHT,BOTTOM_LEFT,BOTTOM_RIGHT,NONE
}BANNER_POSITION;

@interface KidozSDK : NSObject

+ (id)instance;

- (void)initializeWithPublisherID:(NSString *)publisherID securityToken:(NSString *)securityToken withDelegate:(id<KDZInitDelegate>)delegate;
- (void)initializeWithPublisherID:(NSString *)publisherID securityToken:(NSString *)securityToken;

- (void)initializeInterstitialWithDelegate:(id<KDZInterstitialDelegate>)delegate;

- (void)loadInterstitial;
- (void)showInterstitial;


- (void)initializeRewardedWithDelegate:(id<KDZRewardedDelegate>)delegate;

- (void)loadRewarded;
- (void)showRewarded;

- (BOOL)isInterstitialInitialized;
- (BOOL)isInterstitialReady;


- (BOOL)isRewardedInitialized;
- (BOOL)isRewardedReady;

- (BOOL)isSDKInitialized;

- (void)initializeBannerWithDelegate:(id<KDZBannerDelegate>)delegate withViewController:(UIViewController *)viewController;
- (void)initializeBannerWithDelegate:(id<KDZBannerDelegate>)delegate withView:(UIView*)view;

- (void)loadBanner;
- (void)showBanner;
- (void)hideBanner;
- (void)setBannerPosition:(BANNER_POSITION)bannerPosition;

- (BOOL)isBannerInitialized;
- (BOOL)isBannerReady;
- (void)setInterstitialDelegate:(id<KDZInterstitialDelegate>)delegate;
- (void)setRewardedDelegate:(id<KDZRewardedDelegate>)delegate;
- (void)setBannerDelegate:(id<KDZBannerDelegate>)delegate;
- (NSString*)getSdkVersion;

@end



