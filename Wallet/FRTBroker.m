//
//  FRTBroker.m
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import "FRTBroker.h"
#import "FRTMoney.h"
@implementation FRTBroker
- (id) init{
    if (self = [super init]) {
        _rates = [@{} mutableCopy];
    }
    return self;
}

- (FRTMoney *)reduce: (id<FRTMoney>) money
          toCurrency: (NSString *) currency{
    
    // double dispatch
    return [money reduceToCurrency: currency
                        withBroker: self];
}

- (void) addRate: (NSInteger) rate
    fromCurrency: (NSString *) fromCurrency
      toCurrency: (NSString *) toCurrency{
    
    [self.rates setObject:@(rate)
                   forKey:[self keyFromCurrency: fromCurrency
                                     toCurrency: toCurrency]];
    
    [self.rates setObject:@(1.0f/rate)
                   forKey:[self keyFromCurrency: toCurrency
                                     toCurrency: fromCurrency]];
}

- (NSString *) keyFromCurrency: fromCurrency
                    toCurrency: (NSString *) toCurrency{
    return [NSString stringWithFormat:@"%@-%@", fromCurrency, toCurrency];
}

#pragma mark - Rates

- (void) parseJSONRates: (NSData *) json{
    
    NSError *err;
    id obj = [NSJSONSerialization JSONObjectWithData:json
                                             options:NSJSONReadingAllowFragments
                                               error:&err];
    
    if (obj != nil) {
        
    }else{
        
        [NSException raise:@"NoRatesInJSONException"
                    format:@"JSON must carry some data!"];
    }
}

@end
