//
//  CASKidozBridge.m
//  CleverAdsSolutions
//
//  Copyright © 2020 Clever Ads Solutions. All rights reserved.
//

#import "CASKidozBridge.h"

@implementation CASKidozBridge

+ (KidozSDK *)sharedSDK{
    return [KidozSDK instance];
}

@end
