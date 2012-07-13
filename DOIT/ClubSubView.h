//
//  ClubSubView.h
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubSubView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView* listView;
    IBOutlet UILabel* titleLabel;
    NSString* titleText;
    NSMutableArray* listArray;
    NSString* _bkid;
    NSString* _userip;
}

@property(nonatomic, retain) IBOutlet UITableView* listView;
@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) NSString* bkid;
@property(nonatomic, retain) NSString* userip;
@property(nonatomic, retain) NSString* titleText;

-(IBAction)backClick:(id)sender;

@end
