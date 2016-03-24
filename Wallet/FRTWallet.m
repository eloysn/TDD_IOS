//
//  FRTWallet.m
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import "FRTWallet.h"
#import "FRTBroker.h"

@interface FRTWallet ()

@property (nonatomic, strong) NSMutableArray *moneys;

@end

@implementation FRTWallet
- (NSUInteger) count{
    return self.moneys.count;
}

- (id) initWithAmount: (NSInteger) amount
             currency: (NSString *) currency{
    if (self = [super init]) {
        FRTMoney *money = [[FRTMoney alloc] initWithAmount:amount
                                                  currency:currency];
        _moneys = [NSMutableArray array];
        [_moneys addObject:money];
        
        _currencies = [NSMutableArray array];
        [_currencies addObject:money.currency];
    }
    return self;
}

- (id<FRTMoney>) times: (NSUInteger) multiplier{
    NSMutableArray *newMoneys = [NSMutableArray arrayWithCapacity:self.moneys.count];
    for (FRTMoney *each in self.moneys) {
        FRTMoney *newMoney = [each times:multiplier];
        [newMoneys addObject:newMoney];
    }
    self.moneys = newMoneys;
    return self;
}

- (id<FRTMoney>) addMoney: (FRTMoney *) other{
    [self.moneys addObject:other];
    if (![self.currencies containsObject:other.currency]) {
        [self.currencies addObject:other.currency];
    }
    return self;
}

- (id<FRTMoney>) takeMoney: (FRTMoney *) other{
    if (![self.moneys containsObject:other]) {
        [NSException raise:@"TryingToSubstractANonExistingMoneyException"
                    format:@"Imposible to substract %@ %@ form the wallet", other.amount, other.currency];
    }
    [self.moneys removeObject:other];
    return self;
}

- (FRTMoney *)reduceToCurrency:(NSString *)currency
                    withBroker:(FRTBroker *)broker{
    
    FRTMoney *result = [[FRTMoney alloc] initWithAmount:0
                                               currency:currency];
    for (FRTMoney *each in self.moneys) {
        result = [result plus:[each reduceToCurrency:currency
                                          withBroker:broker]];
    }
    return result;
}

- (NSString *) currencyForSection: (NSUInteger) section{
    if (section < self.currencies.count) {
        return [self.currencies objectAtIndex:section];
    }
    return @"";
}

- (NSUInteger) numberOfMoneysForCurrency: (NSString *) currency{
    NSUInteger numberOfMoneys = 0;
    for (FRTMoney *each in self.moneys) {
        if ([each.currency isEqual:currency]) {
            numberOfMoneys++;
        }
    }
    return numberOfMoneys;
}

- (NSUInteger) totalNumberOfCurrencies{
    return self.currencies.count;
}

- (NSUInteger) numberOfMoneysForSection: (NSUInteger) section{
    return [self numberOfMoneysForCurrency:[self currencyForSection:section]];
}

- (FRTMoney *) moneyForIndexPath: (NSIndexPath *) indexPath
                reduceToCurrency:(NSString *) currency
                      withBroker:(FRTBroker *)broker{
    
    if (indexPath.section < self.currencies.count) {
        // No es la seccion con el total
        if (indexPath.row < [self numberOfMoneysForSection:indexPath.section]) {
            // No es la ultima celda, la del subtotal
            NSString *desiredCurrency = [self.currencies objectAtIndex:indexPath.section];
            NSInteger moneyPlace = indexPath.row;
            NSInteger moneysFoundForDesiredCurrency = 0;
            FRTMoney *desiredMoney;
            for (FRTMoney *each in self.moneys) {
                if ([each.currency isEqual:desiredCurrency]) {
                    if (moneysFoundForDesiredCurrency == moneyPlace) {
                        desiredMoney = each;
                        break;
                    }
                    moneysFoundForDesiredCurrency++;
                }
            }
            if (!currency) {
                currency = desiredMoney.currency;
            }
            return [desiredMoney reduceToCurrency:currency
                                       withBroker:broker];
        }else{
            // Es la ultima celda, la del subtotal
            NSString *desiredCurrency = [self.currencies objectAtIndex:indexPath.section];
            FRTMoney *total = [[FRTMoney alloc] initWithAmount:0 currency:desiredCurrency];
            for (FRTMoney *each in self.moneys) {
                if ([each.currency isEqual:desiredCurrency]) {
                    total = [total plus:[each reduceToCurrency:desiredCurrency withBroker:broker]];
                }
            }
            return total;
        }
    }else{
        // Es la seccion con el total
        if (!currency) {
            currency = [self.currencies firstObject];
            if (!currency) {
                currency = @"USD";
            }
        }
        FRTMoney *total = [[FRTMoney alloc] initWithAmount:0 currency:currency];
        for (FRTMoney *each in self.moneys) {
            total = [total plus:[each reduceToCurrency:currency withBroker:broker]];
        }
        return total;
    }
}

- (FRTMoney *) totalMoneyForCurrency: (NSString *) currency{
    
    FRTMoney *total = [[FRTMoney alloc] initWithAmount:0
                                              currency:currency];
    for (FRTMoney *each in self.moneys) {
        if ([each.currency isEqual:currency]) {
            total = [total plus:each];
        }
    }
    return total;
}

- (FRTMoney *) totalMoneyForSection: (NSUInteger) section{
    
    if (section < self.currencies.count){
        return [self totalMoneyForCurrency:[self.currencies objectAtIndex:section]];
    }else{
        return nil;
    }
}

- (void) subscribeToMemoryWarning: (NSNotificationCenter *) nc{
    
    [nc addObserver:self
           selector:@selector(dumpToDisk:)
               name:UIApplicationDidReceiveMemoryWarningNotification
             object:nil];
    
}

- (void) dumpToDisk: (NSNotification *) notification{
    // Guarda las cosas en disco cuando la cosa se pknga fea
}

#pragma mark - Overwritten

- (NSString *) description{
    NSString *desc = [NSString stringWithFormat:@"<%@\r\n", [self class]];
    for (FRTMoney *each in self.moneys) {
        desc = [NSString stringWithFormat:@"%@<%@: %@ %@>\r\n", desc, [each class], [each currency], [each amount]];
    }
    return desc;
}
@end
