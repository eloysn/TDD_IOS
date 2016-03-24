//
//  FRTFakeNotificationCenter.m
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import "FRTFakeNotificationCenter.h"

@implementation FRTFakeNotificationCenter
- (id) init{
    if (self = [super init]) {
        _observers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addObserver:(id)observer
           selector:(SEL)aSelector
               name:(NSString *)aName
             object:(id)anObject{
    
    [self.observers setObject:observer
                       forKey:aName];
}
@end
