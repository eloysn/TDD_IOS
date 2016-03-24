//
//  FRTWalletTableViewController.h
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FRTWallet;
@class FRTBroker;


@interface FRTWalletTableViewController : UITableViewController

@property (nonatomic, strong, readonly) FRTWallet *wallet;

- (id) initWithWallet: (FRTWallet *) wallet
               broker: (FRTBroker *) broker;
@end
