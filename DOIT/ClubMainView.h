//
//  ClubMainView.h
//  DOIT
//
//  Created by AppDev on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubMainView : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView* listView;
    NSMutableArray* listArray;
    NSString* _userip;
}

@property(nonatomic, retain) IBOutlet UITableView* listView;
@property(nonatomic, retain) NSString* userip;

@end
