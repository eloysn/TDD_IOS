//
//  FRTFakeNotificationCenter.h
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRTFakeNotificationCenter : NSObject

@property (nonatomic, strong) NSMutableDictionary *observers;

- (void)addObserver:(id)observer
           selector:(SEL)aSelector
               name:(NSString *)aName
             object:(id)anObject;

@end
