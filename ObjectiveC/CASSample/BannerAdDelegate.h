//
//  BannerAdDelegate.h
//  CASSample
//
//  Created by Денис Ешенко on 20.06.2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import CleverAdsSolutions;

NS_ASSUME_NONNULL_BEGIN

@interface BannerAdDelegate : NSObject<CASBannerDelegate>
@property (nonatomic, strong, nullable) UILabel *infoLabel;
@end

NS_ASSUME_NONNULL_END
