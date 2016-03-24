//
//  FRTBroker.h
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRTMoney.h"

@interface FRTBroker : NSObject

@property (nonatomic, strong) NSMutableDictionary *rates;

- (id<FRTMoney>)reduce: (id<FRTMoney>) money
            toCurrency: (NSString *) currency;

- (void) addRate: (NSInteger) rate
    fromCurrency: (NSString *) fromCurrency
      toCurrency: (NSString *) toCurrency;

- (NSString *) keyFromCurrency: fromCurrency
                    toCurrency: (NSString *) toCurrency;

- (void) parseJSONRates: (NSData *) json;
@end
