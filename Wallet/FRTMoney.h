//
//  FRTMoney.h
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FRTMoney;
@class FRTBroker;

@protocol FRTMoney <NSObject>

- (id) initWithAmount: (NSInteger) amount
             currency: (NSString *) currency;
- (FRTMoney *)reduceToCurrency: (NSString *) currency
                    withBroker: (FRTBroker *) broker;

@end



@interface FRTMoney : NSObject<FRTMoney>

@property (nonatomic, readonly) NSString *currency;
@property (nonatomic, strong, readonly) NSNumber *amount;

+ (id) euroWithAmount: (NSInteger) amount;
+ (id) dollarWithAmount: (NSInteger) amount;

- (id<FRTMoney>) times: (NSUInteger) multiplier;
- (id<FRTMoney>) plus: (FRTMoney *) other;
- (id<FRTMoney>) minus: (FRTMoney *) other;


@end
