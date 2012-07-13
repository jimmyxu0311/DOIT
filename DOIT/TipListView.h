//
//  TipListView.h
//  DOIT
//
//  Created by AppDev on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLite3_Manager.h"

@interface TipListView : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView* listView;
    NSMutableArray* listArray;
    SQLite3_Manager* sqlite;
}

@property(nonatomic, retain) IBOutlet UITableView* listView;

@end
