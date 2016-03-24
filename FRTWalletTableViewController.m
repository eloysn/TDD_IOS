//
//  FRTWalletTableViewController.m
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import "FRTWalletTableViewController.h"
#import "FRTWallet.h"
#import "FRTBroker.h"


@interface FRTWalletTableViewController ()
@property (nonatomic, strong) FRTWallet *wallet;
@property (nonatomic, strong) FRTBroker *broker;
@end

@implementation FRTWalletTableViewController

- (id) initWithWallet: (FRTWallet *) wallet
               broker: (FRTBroker *) broker{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _wallet = wallet;
        _broker = broker;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.wallet totalNumberOfCurrencies] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.wallet numberOfMoneysForSection:section] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section < [self.wallet totalNumberOfCurrencies]) {
        return [self.wallet currencyForSection:section];
    }else{
        return @"TOTAL";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
    }
    
    FRTMoney *money = [self.wallet moneyForIndexPath:indexPath
                                    reduceToCurrency:nil
                                          withBroker:self.broker];
    
    if (indexPath.row < [self.wallet numberOfMoneysForSection:indexPath.section]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", money.amount];
    }else{
        if (indexPath.section < [self.wallet totalNumberOfCurrencies]) {
            cell.textLabel.text = [NSString stringWithFormat:@"SUBTOTAL: %@", money.amount];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@", money.amount];
        }
    }
    cell.detailTextLabel.text = money.currency;
    
    return cell;
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row < [self.wallet numberOfMoneysForSection:indexPath.section]) {
        return YES;
    }else{
        return NO;
    }
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.wallet takeMoney:[self.wallet moneyForIndexPath:indexPath
                                             reduceToCurrency:nil
                                                   withBroker:self.broker]];
        //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}



@end
