//
//  FRTWallet.h
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FRTMoney.h"
@class FRTBroker;


@interface FRTWallet : NSObject<FRTMoney>

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSMutableArray *currencies;

- (id<FRTMoney>) addMoney: (FRTMoney *) other;
- (id<FRTMoney>) takeMoney: (FRTMoney *) other;
- (NSUInteger) totalNumberOfCurrencies;
- (NSString *) currencyForSection: (NSUInteger) section;
- (NSUInteger) numberOfMoneysForSection: (NSUInteger) section;
- (void) subscribeToMemoryWarning: (NSNotificationCenter *) nc;
- (FRTMoney *) moneyForIndexPath: (NSIndexPath *) indexPath
                reduceToCurrency: (NSString *) currency
                      withBroker: (FRTBroker *) broker;
- (FRTMoney *) totalMoneyForCurrency: (NSString *) currency;
- (FRTMoney *) totalMoneyForSection: (NSUInteger) section;

@end
