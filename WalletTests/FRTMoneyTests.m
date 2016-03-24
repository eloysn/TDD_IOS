//
//  FRTMoneyTests.m
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FRTMoney.h"

@interface FRTMoneyTests : XCTestCase

@end

@implementation FRTMoneyTests

- (void) testCurrencies{
    
    XCTAssertEqualObjects(@"EUR", [[FRTMoney euroWithAmount:1] currency], @"The currency of euros should be EUR");
    XCTAssertEqualObjects(@"USD", [[FRTMoney dollarWithAmount:1] currency], @"The currency of dollars should be USD");
}

- (void) testMultiplication{
    
    FRTMoney *five = [FRTMoney euroWithAmount:5];
    FRTMoney *ten = [FRTMoney euroWithAmount:10];
    FRTMoney *total = [five times:2];
    
    XCTAssertEqualObjects(total, ten, @"5€ * 2 should be 10€");
}

- (void) testEquality{
    FRTMoney *five = [FRTMoney euroWithAmount:5];
    FRTMoney *ten = [FRTMoney euroWithAmount:10];
    FRTMoney *totalEuros = [five times:2];
    
    FRTMoney *four = [FRTMoney dollarWithAmount:4];
    FRTMoney *eight = [FRTMoney dollarWithAmount:8];
    FRTMoney *totalDollars = [four times:2];
    
    XCTAssertEqualObjects(ten, totalEuros, @"Equivalent objects should be equal");
    XCTAssertEqualObjects(eight, totalDollars, @"Equivalent objects should be equal");
    XCTAssertFalse([totalEuros isEqual:five], @"Non equivalent objects should not be equal");
}

- (void) testDifferentCurrencies{
    FRTMoney *euro = [FRTMoney euroWithAmount:1];
    FRTMoney *dollar = [FRTMoney dollarWithAmount:1];
    
    XCTAssertNotEqualObjects(euro, dollar, @"Different currencies should not be equal");
}

- (void) testHash{
    
    FRTMoney *a = [FRTMoney euroWithAmount:2];
    FRTMoney *b = [FRTMoney euroWithAmount:2];
    
    FRTMoney *c = [FRTMoney dollarWithAmount:1];
    FRTMoney *d = [FRTMoney dollarWithAmount:1];
    
    XCTAssertEqual([a hash], [b hash], @"Equal objects must have same hash");
    XCTAssertEqual([c hash], [d hash], @"Equal objects must have same hash");
}

- (void) testAmountStorage{
    int amount = 10;
    FRTMoney *euro = [FRTMoney euroWithAmount:amount];
    FRTMoney *dollar = [FRTMoney dollarWithAmount:amount];
    
    // Eliminamos el warnig que habia por acceder a un selector de la parte privada
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    XCTAssertEqual(amount, [[euro performSelector:@selector(amount)] integerValue], @"The value retrieved should be the same as the stored");
    XCTAssertEqual(amount, [[dollar performSelector:@selector(amount)] integerValue], @"The value retrieved should be the same as the stored");
#pragma clang diagnostic pop
    
}

- (void) testSimpleAdition{
    FRTMoney *sum = [[FRTMoney dollarWithAmount:5] plus: [FRTMoney dollarWithAmount:5]];
    XCTAssertEqualObjects(sum, [FRTMoney dollarWithAmount:10],  @"$5 + $5 should be $10");
}

- (void) testSimpleSubstraction{
    FRTMoney *subs = [[FRTMoney dollarWithAmount:10] minus: [FRTMoney dollarWithAmount:5]];
    XCTAssertEqualObjects(subs, [FRTMoney dollarWithAmount:5],  @"$10 - $5 should be $5");
}

- (void) testThatSubstractionOfBiggestAmountThanExistingThrowsException{
    XCTAssertThrows([[FRTMoney dollarWithAmount:1] minus: [FRTMoney dollarWithAmount:2]], @"Substraction of biggest amount than existing should cause exception");
}

- (void) testThatHashIsAmount{
    FRTMoney *one = [FRTMoney dollarWithAmount:1];
    XCTAssertEqual([one hash], 1, @"The hash must be the same as the amount");
}

- (void) testDescription{
    
    FRTMoney *one = [FRTMoney dollarWithAmount:1];
    NSString *desc = @"<FRTMoney: USD 1>";
    
    XCTAssertEqualObjects(desc, [one description], @"Description must match template");
}


@end
