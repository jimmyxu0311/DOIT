//
//  HeadLineViewController.h
//  DOIT
//
//  Created by AppDev on 12-2-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MobileInfo.h"
#import "ImageDownloader.h"

@interface HeadLineViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,imageDownloaderDelegate>{
    IBOutlet UITableView* listView;
@private  
    NSMutableArray* listArray;
    NSMutableArray* topArray;
    NSMutableArray* imageArray;
    int index;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

@property(nonatomic, retain) IBOutlet UITableView* listView;
@property(nonatomic, retain) NSMutableArray* listArray;
@property(nonatomic, retain) NSMutableArray* topArray;
@property(nonatomic, retain) NSMutableArray* imageArray;


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData:(BOOL)isLoad;

@end
