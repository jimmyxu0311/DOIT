//
//  AboutView.m
//  DOIT
//
//  Created by AppDev on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AboutView.h"

@implementation AboutView


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
