//
//  MoreMainView.h
//  DOIT
//
//  Created by AppDev on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreMainView : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView* listView;
    NSArray* listItem;
}

@property(nonatomic, retain) IBOutlet UITableView* listView;

@end
