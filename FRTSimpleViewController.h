//
//  FRTSimpleViewController.h
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRTSimpleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
- (IBAction)displayText:(id)sender;
@end
