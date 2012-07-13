//
//  AllTipListView.m
//  DOIT
//
//  Created by AppDev on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AllTipListView.h"
#import "DOITUtil.h"
#import "TipService.h"
#import "TipCell.h"
#import "TipDetailView.h"
#import "SendView.h"
#import "PlateInfoService.h"
#import "MobileInfo.h"

@implementation AllTipListView
@synthesize bkid;
@synthesize plateName;
@synthesize plateViews;
@synthesize plateDescribe;
@synthesize plateModerator;
@synthesize listView;
@synthesize pageSizeLabel;
@synthesize titleText;
@synthesize leftbtn;
@synthesize rightbtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)sendClick:(id)sender{
    if ([listArray count] > 0) {
        SendView* sendView = [[SendView alloc] initWithNibName:@"SendView" bundle:nil];
        sendView.userip = _userip;
        sendView.fid = self.bkid;
        [self.navigationController pushViewController:sendView animated:YES];
        [sendView release];
    }
}

-(IBAction)leftClick:(id)sender{
    if (pageIndex > 1) {
        [rightbtn setImage:[UIImage imageNamed:@"club_button_right.png"] forState:UIControlStateNormal];
        [leftbtn setImage:[UIImage imageNamed:@"club_button_left.png"] forState:UIControlStateNormal];
        pageIndex--;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString* urlStr = [NSString stringWithFormat:@"%@bbs.topic.list.do?fid=%@&page=%d&requestNum=%d&digest=",[DOITUtil getUrlBase],self.bkid,pageIndex,pageSize];
        [NSThread detachNewThreadSelector:@selector(loadClubList:) toTarget:self withObject:urlStr];
        if (pageIndex==1) {
            [leftbtn setImage:[UIImage imageNamed:@"club_button_un_left.png"] forState:UIControlStateNormal];
        }
        
    }
    else{
        [leftbtn setImage:[UIImage imageNamed:@"club_button_un_left.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)rightClick:(id)sender{
    if ([plateInfo.pageSize intValue] > pageIndex) {
        [rightbtn setImage:[UIImage imageNamed:@"club_button_right.png"] forState:UIControlStateNormal];
        [leftbtn setImage:[UIImage imageNamed:@"club_button_left.png"] forState:UIControlStateNormal];
        pageIndex++;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSString* urlStr = [NSString stringWithFormat:@"%@bbs.topic.list.do?fid=%@&page=%d&requestNum=%d&digest=",[DOITUtil getUrlBase],self.bkid,pageIndex,pageSize];
        
        [NSThread detachNewThreadSelector:@selector(loadClubList:) toTarget:self withObject:urlStr];
        if (pageIndex==[plateInfo.pageSize intValue]) {
            [rightbtn setImage:[UIImage imageNamed:@"club_button_un_right.png"] forState:UIControlStateNormal];
        }
    }
    else{
        [rightbtn setImage:[UIImage imageNamed:@"club_button_un_right.png"] forState:UIControlStateNormal];
    }
}

-(void)loadClubList:(NSString*)urlString{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSURL* url = [NSURL URLWithString:urlString];
    listArray = [[TipService getTipArray:url] retain];
    [self.listView reloadData];
    NSString* pageSizeString = [NSString stringWithFormat:@"%d/%@",pageIndex,plateInfo.pageSize];
    if (pageSizeString) {
        int size = 0;
        @try {
            size = [plateInfo.pageSize intValue];
        }
        @catch (NSException *exception) {
            size = -1;
        }
        if (size > 0) {
            [self.pageSizeLabel performSelectorOnMainThread:@selector(setText:) withObject:pageSizeString waitUntilDone:YES];
        }
    }
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [pool release];
}

-(void)loadContent{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSString* urlString = [NSString stringWithFormat:@"%@bbs.forum.detail.do?fid=%@&digest=",[DOITUtil getUrlBase],self.bkid];
    
    NSURL* url = [NSURL URLWithString:urlString];
    plateInfo = [[PlateInfoService getPlateInfo:url] retain];
    NSString* views = [NSString stringWithFormat:@"%@主题|%@回复",plateInfo.threads,plateInfo.posts];
    
    NSString* plateModeratorText = [NSString stringWithFormat:@"版主: %@",plateInfo.moderators];
    
    [self.plateName performSelectorOnMainThread:@selector(setText:) withObject:plateInfo.name waitUntilDone:YES];
    [self.plateViews performSelectorOnMainThread:@selector(setText:) withObject:views waitUntilDone:YES];
    [self.plateDescribe performSelectorOnMainThread:@selector(setText:) withObject:plateInfo.description waitUntilDone:YES];
    [self.plateModerator performSelectorOnMainThread:@selector(setText:) withObject:plateModeratorText waitUntilDone:YES];
    NSString* urlStr = [NSString stringWithFormat:@"%@bbs.topic.list.do?fid=%@&page=%d&requestNum=%d&digest=",[DOITUtil getUrlBase],self.bkid,pageIndex,pageSize];
    [NSThread detachNewThreadSelector:@selector(loadClubList:) toTarget:self withObject:urlStr];
    [pool release];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [listArray count];
    return count+1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 93;
    }
    return 65;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (row==0) {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        UIView *tempView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 93)];
        plateName=[[UILabel alloc] initWithFrame:CGRectMake(9, 0, 172, 27)];
        [plateName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [plateName setLineBreakMode:UILineBreakModeTailTruncation];
        [plateName setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [plateName setBackgroundColor:[UIColor clearColor]];
        [plateName setTextColor:[UIColor darkGrayColor]];
        [tempView addSubview:plateName];
        plateViews=[[UILabel alloc] initWithFrame:CGRectMake(180, 0, 140, 27)];
        [plateViews setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [plateViews setLineBreakMode:UILineBreakModeTailTruncation];
        [plateViews setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [plateViews setTextColor:[UIColor grayColor]];
        [plateViews setBackgroundColor:[UIColor clearColor]];
        [tempView addSubview:plateViews];
        plateDescribe=[[UILabel alloc] initWithFrame:CGRectMake(9, 25, 304, 50)];
        [plateDescribe setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [plateDescribe setLineBreakMode:UILineBreakModeCharacterWrap];
        [plateDescribe setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        [plateDescribe setNumberOfLines:0];
        [plateDescribe setTextColor:[UIColor blackColor]];
        [plateDescribe setBackgroundColor:[UIColor clearColor]];
        [tempView addSubview:plateDescribe];
        plateModerator=[[UILabel alloc] initWithFrame:CGRectMake(9, 68, 304, 31)];
        [plateModerator setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [plateModerator setLineBreakMode:UILineBreakModeTailTruncation];
        [plateModerator setLineBreakMode:UILineBreakModeCharacterWrap];
        [plateModerator setTextColor:[UIColor colorWithRed:0.19 green:0.3 blue:0.52 alpha:1]];
        [plateModerator setBackgroundColor:[UIColor clearColor]];
        [tempView addSubview:plateModerator];
        [cell.contentView addSubview:tempView];

            
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else{
        static NSString *cellIndentifier = @"cell";
        TipCell* cell = (TipCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil) {
            NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"TipCell" owner:self options:nil];
            cell = (TipCell *)[bundle objectAtIndex:0];
        }
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        Tip* tip = [listArray objectAtIndex:row-1];
        
        if (tip) {
            [cell setCell:tip];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if (row>0) {
        row-=1;
        Tip* tip = [listArray objectAtIndex:row];
        if (tip) {
            TipDetailView* tipDetailView = [[TipDetailView alloc] initWithNibName:@"TipDetailView" bundle:nil];
            tipDetailView.tid = tip.tid;
            tipDetailView.tipTitle = tip.subejct;
            tipDetailView.bkid = self.bkid;
            tipDetailView.userip = _userip;
            tipDetailView.titleText = self.titleText;
            [self.navigationController pushViewController:tipDetailView animated:YES];
            [tipDetailView release];
        }
    }
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    pageIndex = 1;
    pageSize = 20;
    _userip = [MobileInfo shareInstance].userIPAddress;
    
    if (_refreshHeaderView == nil) {
		
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.listView.bounds.size.height, self.view.frame.size.width, self.listView.bounds.size.height)];        
		_refreshHeaderView.delegate = self;
        
		[self.listView addSubview:_refreshHeaderView];
	}
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([listArray count] == 0 || plateInfo == nil) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [NSThread detachNewThreadSelector:@selector(loadContent) toTarget:self withObject:nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _userip = nil;
    self.bkid = nil;
    plateInfo = nil;
    listArray = nil;
    self.plateDescribe = nil;
    self.plateModerator = nil;
    self.plateName = nil;
    self.plateViews = nil;
    self.listView = nil;
    self.pageSizeLabel = nil;
    self.titleText = nil;
    _refreshHeaderView = nil;
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.listView];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}



#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    [self.listView reloadData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}


- (void)dealloc{    
    [self.bkid release];
    [self.plateDescribe release];
    [self.plateModerator release];
    [self.plateName release];
    [self.plateViews release];
    [self.listView release];
    [self.pageSizeLabel release];
    [super dealloc];
}

@end
