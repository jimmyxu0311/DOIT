//
//  SettingView.h
//  DOIT
//
//  Created by AppDev on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SettingView : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView* listView;
    BOOL isLoadImg;
    
    NSString* trueOrFalse;
    
    AppDelegate* appDelegate;
}

@property(nonatomic, retain) IBOutlet UITableView* listView;

-(IBAction)backClick:(id)sender;

@end
