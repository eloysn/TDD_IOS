//
//  FRTBrokerTests.m
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FRTMoney.h"
#import "FRTBroker.h"


@interface FRTBrokerTests : XCTestCase
@property (nonatomic, strong) FRTBroker *emptyBroker;
@property (nonatomic, strong) FRTMoney *oneDollar;
@end

@implementation FRTBrokerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.emptyBroker = [FRTBroker new];
    self.oneDollar = [FRTMoney dollarWithAmount:1];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.emptyBroker = nil;
    self.oneDollar = nil;
}


- (void) testSimpleReduction{
    FRTMoney *sum = [[FRTMoney dollarWithAmount:5] plus:[FRTMoney dollarWithAmount:5]];
    
    FRTMoney *reduced = [self.emptyBroker reduce: sum toCurrency: @"USD"];
    
    XCTAssertEqualObjects(sum, reduced, @"Conversion to same currency should be a NOP");
}

// $10 == 5€ (2:1)

- (void) testReduction{
    [self.emptyBroker addRate: 2
                 fromCurrency: @"EUR"
                   toCurrency: @"USD"];
    
    FRTMoney *dollars = [FRTMoney dollarWithAmount:10];
    FRTMoney *euros = [FRTMoney euroWithAmount:5];
    
    FRTMoney *converted = [self.emptyBroker reduce:dollars
                                        toCurrency:@"EUR"];
    
    XCTAssertEqualObjects(converted, euros, @"$10 == 5€ (2:1)");
}

- (void) testThatNoRateRaisesException{
    XCTAssertThrows([self.emptyBroker reduce:self.oneDollar toCurrency:@"EUR"], @"No rates should cause exception");
}

- (void) testThatNilConversionDoesNotChangeMoney{
    XCTAssertEqualObjects(self.oneDollar, [self.emptyBroker reduce:self.oneDollar toCurrency:self.oneDollar.currency], @"A nil conversion should have no effect");
}


@end
