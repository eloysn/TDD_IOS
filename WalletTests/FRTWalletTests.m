//
//  FRTWalletTests.m
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "FRTMoney.h"
#import "FRTBroker.h"
#import "FRTWallet.h"

@interface FRTWalletTests : XCTestCase

@end

@implementation FRTWalletTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testAdditionWithReduction{
    
    FRTBroker *broker = [FRTBroker new];
    [broker addRate: 2 fromCurrency: @"EUR" toCurrency: @"USD"];
    
    FRTWallet *wallet = [[FRTWallet alloc]initWithAmount:40 currency: @"EUR"];
    [wallet addMoney: [FRTMoney dollarWithAmount: 20]];
    
    FRTMoney *reduced = [broker reduce:wallet toCurrency: @"USD"];
    
    XCTAssertEqualObjects(reduced, [FRTMoney dollarWithAmount:100], @"€40 + $20 = $100 (2:1)");
}

- (void) testSimpleSubstraction{
    FRTWallet *wallet = [[FRTWallet alloc]initWithAmount:20 currency: @"EUR"];
    [wallet addMoney: [FRTMoney euroWithAmount: 10]];
    
    FRTMoney *total = [[wallet takeMoney:[FRTMoney euroWithAmount: 10]] reduceToCurrency:@"EUR"
                                                                              withBroker:[FRTBroker new]];
    
    XCTAssertEqualObjects(total, [FRTMoney euroWithAmount:20], @"€30€ - 10€ = 20€");
}

- (void) testThatSubstractionOfANonExistingMoneyThrowsException{
    FRTWallet *wallet = [[FRTWallet alloc]initWithAmount:20 currency: @"EUR"];
    [wallet addMoney: [FRTMoney euroWithAmount: 10]];
    
    XCTAssertThrows([wallet takeMoney: [FRTMoney euroWithAmount:5]], @"Substraction of a non existing money should cause exception");
}

- (void) testNumberOfCurrencies{
    FRTWallet *wallet = [[FRTWallet alloc]initWithAmount:20 currency: @"EUR"];
    [wallet addMoney: [FRTMoney euroWithAmount: 10]];
    [wallet addMoney: [FRTMoney dollarWithAmount: 10]];
    
    XCTAssertEqual([wallet totalNumberOfCurrencies], 2, @"The number of currencies in the wallet should be 2");
}

- (void) testTotalMoneyForAGivenCurrency{
    
    NSInteger initialAmount = 20;
    
    FRTMoney *euro1 = [FRTMoney euroWithAmount: initialAmount];
    FRTMoney *euro2 = [FRTMoney euroWithAmount: 10];
    FRTMoney *dollar1 = [FRTMoney dollarWithAmount: 10];
    FRTMoney *dollar2 = [FRTMoney dollarWithAmount: 50];
    FRTMoney *dollar3 = [FRTMoney dollarWithAmount: 5];
    
    FRTWallet *wallet = [[FRTWallet alloc]initWithAmount:initialAmount currency: @"EUR"];
    
    [wallet addMoney: euro2];
    [wallet addMoney: dollar1];
    [wallet addMoney: dollar2];
    [wallet addMoney: dollar3];
    
    FRTMoney *totalEuros = [euro1 plus:euro2];
    FRTMoney *totalDollars = [(FRTMoney *)[dollar1 plus:dollar2] plus: dollar3];
    
    XCTAssertEqualObjects([wallet totalMoneyForCurrency: euro1.currency], totalEuros, @"Total money for a given currency should be the same");
    XCTAssertEqualObjects([wallet totalMoneyForCurrency: dollar1.currency], totalDollars, @"Total money for a given currency should be the same");
}


@end
