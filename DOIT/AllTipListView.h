//
//  AllTipListView.h
//  DOIT
//
//  Created by AppDev on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlateInfo.h"
#import "EGORefreshTableHeaderView.h"

@interface AllTipListView : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>{
    IBOutlet UILabel* plateName;
    IBOutlet UILabel* plateViews;
    IBOutlet UILabel* plateDescribe;
    IBOutlet UILabel* plateModerator;
    IBOutlet UILabel* pageSizeLabel;
    IBOutlet UITableView* listView;
    IBOutlet UIButton *leftbtn;
    IBOutlet UIButton *rightbtn;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;

@private
    NSString* bkid;
    PlateInfo* plateInfo;
    NSMutableArray* listArray;
    int pageIndex;
    int pageSize;
    NSString* titleText;
    NSString* _userip;
}

@property(nonatomic, retain) NSString* bkid;
@property(nonatomic, retain) NSString* titleText;

@property(nonatomic, retain) IBOutlet UILabel* plateName;
@property(nonatomic, retain) IBOutlet UILabel* plateViews;
@property(nonatomic, retain) IBOutlet UILabel* plateDescribe;
@property(nonatomic, retain) IBOutlet UILabel* plateModerator;
@property(nonatomic, retain) IBOutlet UITableView* listView;
@property(nonatomic, retain) IBOutlet UILabel* pageSizeLabel;
@property(nonatomic, retain) IBOutlet UIButton *leftbtn;
@property(nonatomic, retain) IBOutlet UIButton *rightbtn;

-(IBAction)sendClick:(id)sender;
-(IBAction)leftClick:(id)sender;
-(IBAction)rightClick:(id)sender;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
