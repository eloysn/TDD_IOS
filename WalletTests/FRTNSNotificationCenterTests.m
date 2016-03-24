//
//  FRTNSNotificationCenterTests.m
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FRTFakeNotificationCenter.h"
#import "FRTWallet.h"

@interface FRTNSNotificationCenterTests : XCTestCase

@end

@implementation FRTNSNotificationCenterTests

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

-(void) testThatSubscribesToMemoryWarning {
    
    
    FRTFakeNotificationCenter *fakeNc = [FRTFakeNotificationCenter new];
    
    
    FRTWallet *fatWallet = [FRTWallet new];
    
   
    [fatWallet subscribeToMemoryWarning: (NSNotificationCenter *) fakeNc];
    
    NSDictionary *obs = [fakeNc observers];
    
    id observer = [obs objectForKey:UIApplicationDidReceiveMemoryWarningNotification];
    
    XCTAssertEqualObjects(observer, fatWallet, @"Fat object must suscribe to UIApplicationDidReceiveMemoryWarningNotification");
}

@end
