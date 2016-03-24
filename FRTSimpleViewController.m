//
//  FRTSimpleViewController.m
//  Wallet
//
//  Created by Eloy Sanz Navarro on 24/3/16.
//  Copyright © 2016 FratelliApps. All rights reserved.
//

#import "FRTSimpleViewController.h"


@interface FRTSimpleViewController ()

@end
@implementation FRTSimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)displayText:(id)sender {
    
    UIButton *button = sender;
    self.displayLabel.text = button.titleLabel.text;
    
}

@end
