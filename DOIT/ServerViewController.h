//
//  ServerViewController.h
//  DOIT
//
//  Created by AppDev on 12-2-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"
#import "EGORefreshTableHeaderView.h"
#import "MobileInfo.h"
#import "SQLite3_Manager.h"

@interface ServerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,imageDownloaderDelegate>{
    IBOutlet UITableView* listView;
@private
    int index;
    NSMutableArray* listArray;
    NSMutableArray* imageArray;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

@property(nonatomic, retain) IBOutlet UITableView* listView;
@property(nonatomic, retain) NSMutableArray* listArray;
@property(nonatomic, retain) NSMutableArray* imageArray;


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData:(BOOL)isLoad;

@end
