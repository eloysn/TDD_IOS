//
//  FRTNetworkTest.m
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FRTBroker.h"

@interface FRTNetworkTest : XCTestCase

@end

@implementation FRTNetworkTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void) testThatEmptyRatesRaisesException{
    FRTBroker *broker = [FRTBroker new];
    NSData *jsonData = nil;
    
    XCTAssertThrows([broker parseJSONRates: jsonData], @"An empty json should raise exception");
}

@end
