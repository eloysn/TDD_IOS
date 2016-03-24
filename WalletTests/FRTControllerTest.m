//
//  FRTControllerTest.m
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FRTSimpleViewController.h"
#import "FRTWalletTableViewController.h"
#import "FRTWallet.h"
#import "FRTBroker.h"

@interface FRTControllerTest : XCTestCase
@property (nonatomic, strong) FRTSimpleViewController *simpleVC;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) FRTWalletTableViewController *walletVC;
@property (nonatomic, strong) FRTWallet *wallet;
@property (nonatomic, strong) FRTBroker *broker;
@end

@implementation FRTControllerTest

- (void)setUp {
    [super setUp];
    self.broker = [[FRTBroker alloc] init];
    [self.broker addRate: 2 fromCurrency: @"EUR" toCurrency: @"USD"];
    
    
    // Creamos el entorno de laboratorio
    self.simpleVC = [[FRTSimpleViewController alloc] initWithNibName:nil
                                                              bundle:nil];
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button setTitle:@"Hello Amundio" forState:UIControlStateNormal];
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.simpleVC.displayLabel = self.label;
    
    self.wallet = [[FRTWallet alloc] initWithAmount:1 currency:@"USD"];
    [self.wallet addMoney:[FRTMoney euroWithAmount:1]];
    self.walletVC = [[FRTWalletTableViewController alloc] initWithWallet: self.wallet broker:self.broker];
    
    
    }

- (void)tearDown {
    
    [super tearDown];
    self.simpleVC = nil;
    self.button = nil;
    self.label = nil;
}

- (void) testThatTextOnLabelIsEqualToTextOnButton{
    
    // Mandamos el mensaje
    [self.simpleVC displayText:self.button];
    
    //comprobamos que etiqueta y botón tienen el mismo texto
    XCTAssertEqualObjects(self.button.titleLabel.text, self.label.text, @"Button and Label have the same text");
}
- (void) testThatNumberOfSectionsIsNumberOfCurrenciesPlusOne{
    
    NSUInteger sections = [self.walletVC numberOfSectionsInTableView:nil];
    
    XCTAssertEqual(sections, [self.walletVC.wallet totalNumberOfCurrencies] + 1, @"The number of sections should be the number of currencies plus one");
}

- (void) testThatNumberOfCellsInSectionForAGivenCurrencyIsTheNumberOfMoneysOfThatCurrency{
    
    [self.wallet addMoney:[FRTMoney dollarWithAmount:20]];
    [self.wallet addMoney:[FRTMoney euroWithAmount:5]];
    [self.wallet addMoney:[FRTMoney euroWithAmount:10]];
    
    NSUInteger numberOfSections = [self.walletVC numberOfSectionsInTableView:nil];
    NSUInteger numberOfCurrencies = [self.wallet totalNumberOfCurrencies];
    
    for (int i=0; i < numberOfSections; i++) {
        NSUInteger numberOfRowsForSection = [self.wallet numberOfMoneysForSection:i] + 1;
        if (i < numberOfCurrencies) {
            XCTAssertEqual(numberOfRowsForSection, [self.walletVC tableView:nil numberOfRowsInSection:i], @"Number of cells is the number of moneys plus 1");
        }else{
            XCTAssertEqual(numberOfRowsForSection, 1, @"Number of cells is 1 (one cell for the total)");
        }
    }
}

- (void) testMoneyForCellAtIndexPath{
    
    NSString *baseCurrency = @"USD";
    
    FRTMoney *dollar2 = [FRTMoney dollarWithAmount:20];
    FRTMoney *euro2 = [FRTMoney euroWithAmount:5];
    FRTMoney *euro3 = [FRTMoney euroWithAmount:10];
    [self.wallet addMoney:euro2];
    [self.wallet addMoney:dollar2];
    [self.wallet addMoney:euro3];
    
    NSIndexPath *indexPathForCurrency1 = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *indexPathForCurrency2 = [NSIndexPath indexPathForRow:2 inSection:1];
    NSIndexPath *indexPathForTotal = [NSIndexPath indexPathForRow:0 inSection:3];
    
    FRTMoney *moneyForIndexPathForCurrency1 = [self.wallet moneyForIndexPath: indexPathForCurrency1
                                                            reduceToCurrency: nil
                                                                  withBroker:self.broker];
    FRTMoney *moneyForIndexPathForCurrency2 = [self.wallet moneyForIndexPath: indexPathForCurrency2
                                                            reduceToCurrency: nil
                                                                  withBroker:self.broker];
    FRTMoney *moneyForIndexPathForTotal = [self.wallet moneyForIndexPath: indexPathForTotal
                                                        reduceToCurrency: baseCurrency
                                                              withBroker:self.broker];
    
    XCTAssertEqualObjects(moneyForIndexPathForCurrency1, dollar2, @"The money for a given indexPath(%@) should be money inserted in %@ª place for currency of index %@", indexPathForCurrency1, @(indexPathForCurrency1.section), @(indexPathForCurrency1.row));
    
    XCTAssertEqualObjects(moneyForIndexPathForCurrency2, euro3, @"The money for a given indexPath(%@) should be money inserted in %@ª place for currency of index %@", indexPathForCurrency2, @(indexPathForCurrency2.section), @(indexPathForCurrency2.row));
    
    XCTAssertEqualObjects(moneyForIndexPathForTotal, [self.wallet reduceToCurrency:baseCurrency withBroker:self.broker], @"The money for a given indexPath(%@) should be money inserted in %@ª place for currency of index %@", indexPathForTotal, @(indexPathForTotal.section), @(indexPathForTotal.row));
}


- (void) testMoneyForSubTotalCells{
    
    FRTMoney *dollar2 = [FRTMoney dollarWithAmount:20];
    FRTMoney *euro2 = [FRTMoney euroWithAmount:5];
    FRTMoney *euro3 = [FRTMoney euroWithAmount:10];
    [self.wallet addMoney:euro2];
    [self.wallet addMoney:dollar2];
    [self.wallet addMoney:euro3];
    
    NSIndexPath *indexPathForTotalEuros = [NSIndexPath indexPathForRow:3 inSection:1];
    NSIndexPath *indexPathForTotalDollars = [NSIndexPath indexPathForRow:2 inSection:0];
    
    FRTMoney *moneyForIndexPathForTotalEuros = [self.wallet moneyForIndexPath: indexPathForTotalEuros
                                                             reduceToCurrency: nil
                                                                   withBroker:self.broker];
    FRTMoney *moneyForIndexPathForTotalDollars = [self.wallet moneyForIndexPath: indexPathForTotalDollars
                                                               reduceToCurrency: nil
                                                                     withBroker:self.broker];
    
    XCTAssertEqualObjects(moneyForIndexPathForTotalEuros, [FRTMoney euroWithAmount:16], @"The total money for a given currency should be the same");
    
    XCTAssertEqualObjects(moneyForIndexPathForTotalDollars, [FRTMoney dollarWithAmount:21], @"The total money for a given currency should be the same");
}

- (void) testTotalMoneyInWalletForSection{
    
    FRTMoney *dollar2 = [FRTMoney dollarWithAmount:20];
    FRTMoney *euro2 = [FRTMoney euroWithAmount:5];
    FRTMoney *euro3 = [FRTMoney euroWithAmount:10];
    [self.wallet addMoney:euro2];
    [self.wallet addMoney:dollar2];
    [self.wallet addMoney:euro3];
    
    XCTAssertEqualObjects([[FRTMoney alloc] initWithAmount:21 currency:@"USD"], [self.wallet totalMoneyForSection: 0], @"Total amount of dollars must be the same");
    XCTAssertEqualObjects([[FRTMoney alloc] initWithAmount:16 currency:@"EUR"], [self.wallet totalMoneyForSection: 1], @"Total amount of dollars must be the same");
    
}



@end
