//
//  SafetyViewController.m
//  DOIT
//
//  Created by AppDev on 12-2-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SafetyViewController.h"
#import "DOITUtil.h"
#import "ArticleService.h"
#import "ArticleCell.h"
#import "Article.h"
#import "InformationDetailView.h"
#import "AppDelegate.h"
#import "GTMBase64.h"

@implementation SafetyViewController
@synthesize listArray;
@synthesize listView;
@synthesize imageArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)fetchListArray:(NSString*)requestURL{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSURL* url = [NSURL URLWithString:requestURL];
    NSArray* array = [[ArticleService getArticleArray:url] retain];
    if ([array count] > 0) {
        [self.listArray addObjectsFromArray:array];
        self.imageArray = [[[NSMutableArray alloc] init] autorelease];
        for ( int i = 0; i  < [self.listArray count]; i++) 
        {
            [self.imageArray addObject: [NSNull null]];
        }
        [self.listView reloadData];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [pool release];
}

- (void)appendTableWith:(NSMutableArray*)data{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSArray* array = [data retain];
    for (int i = 0; i < [array count]; i++) {
        [self.listArray addObject:[array objectAtIndex:i]];
        [self.imageArray addObject:[NSNull null]];
    }
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[array count]];
    for (int ind = 0; ind < [array count]; ind++) {
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:[self.listArray indexOfObject:[array objectAtIndex:ind]] inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [self.listView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [array release];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [pool release];
}

- (void)loadMoreList:(NSString*)requestURL{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSURL* url = [NSURL URLWithString:requestURL];
    NSArray* array = [[ArticleService getArticleArray:url] retain];
    if ([array count] > 0) {
        [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:array waitUntilDone:NO];
    }
    [array release];
    [pool release];
}

#pragma mark - UITableView lifecycle
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = [self.listArray count];
    if (rowCount > 0) {
        return rowCount + 1;
    }
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (row == [self.listArray count]) {
        return 30;
    }
    return 75;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    static NSString* cellDefine = @"cellDefine";
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] getCurrntNet]==nil) {
        if (row < [self.listArray count]) {
            Article* article = [self.listArray objectAtIndex:row];
            ArticleCell* cell = (ArticleCell*)[tableView dequeueReusableCellWithIdentifier:cellDefine];
            if (cell == nil) {
                NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"ArticleCell" owner:self options:nil];
                cell = (ArticleCell *)[bundle objectAtIndex:0];
                [cell setCell:article.title summary:article.summary image:[UIImage imageWithData:[GTMBase64 decodeString:article.pictrue]] articletype:[article.articleType intValue]];
            }
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            return cell;
        }else{
            static NSString* endRow = @"endRow";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:endRow];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:endRow] autorelease];
            }
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.text = @"查看更多";
            listView.backgroundColor=[UIColor whiteColor];
            return cell;
        }
    }
    if (row < [self.listArray count]) {
        Article* article = [self.listArray objectAtIndex:row];
        
        ArticleCell* cell = (ArticleCell*)[tableView dequeueReusableCellWithIdentifier:cellDefine];
        if (cell == nil) {
            NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"ArticleCell" owner:self options:nil];
            cell = (ArticleCell *)[bundle objectAtIndex:0];
            NSNull *null = (NSNull *)[self.imageArray objectAtIndex:row];
            if (![null isKindOfClass:[NSNull class]])
            {
                [cell setCell:article.title summary:article.summary image:[self.imageArray objectAtIndex:row] articletype:[article.articleType intValue]];
            }else{
                [cell setCell:article.title summary:article.summary image:nil articletype:[article.articleType intValue]];
                if ([MobileInfo shareInstance].isLoadImg) {
                    ImageDownloader* imageDownLoader = [[[ImageDownloader alloc] init] autorelease];
                    imageDownLoader.delegate = self;
                    imageDownLoader.delPara = indexPath;
                    [imageDownLoader startDownLoaderImage:article.picture];
                }
            }
        }        
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        return cell;
    }else{
        static NSString* endRow = @"endRow";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:endRow];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:endRow] autorelease];
        }
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"查看更多";
        listView.backgroundColor=[UIColor whiteColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (row == [self.listArray count]) {
        index++;
        UITableViewCell* moreCell = [self.listView cellForRowAtIndexPath:indexPath];
        moreCell.textLabel.text = @"正在加载...";
        NSString* requestURL = [NSString stringWithFormat:@"%@article.show.list.do?actionType=server&requestNum=10&page=%i",[DOITUtil getUrlBase],index];
        
        [self performSelectorInBackground:@selector(loadMoreList:) withObject:requestURL];
        [self.listView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        InformationDetailView* informationDetailView = [[InformationDetailView alloc] initWithNibName:@"InformationDetailView" bundle:nil];
        informationDetailView.sortText = @"商用";
        informationDetailView.currentArray = self.listArray;
        informationDetailView.currentIndex = row;
        [self.navigationController pushViewController:informationDetailView animated:YES];
        [informationDetailView release];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    index = 1;
    self.listArray = [[NSMutableArray alloc] init];
    listView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"roding.png"]];

    if (_refreshHeaderView == nil) {
		
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.listView.bounds.size.height, self.view.frame.size.width, self.listView.bounds.size.height)];        
		_refreshHeaderView.delegate = self;
        
		[self.listView addSubview:_refreshHeaderView];
	}
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] getCurrntNet]==nil) {
        SQLite3_Manager *sqlm=[[SQLite3_Manager alloc] init];
        listArray=[[sqlm queryInformationCache:@"Server"] retain];
        [self.listView reloadData];
    }
    else{
        if ([self.listArray count] == 0) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSString* requestURL = [NSString stringWithFormat:@"%@article.show.list.do?actionType=server&requestNum=10&page=%i",[DOITUtil getUrlBase],index];
            [NSThread detachNewThreadSelector:@selector(fetchListArray:) toTarget:self withObject:requestURL];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    if (_refreshHeaderView != nil) {
        [_refreshHeaderView release];
    }
}

- (void)dealloc{
    [self.listView release];
    [self.listArray release];
    [self.imageArray release];
    [super dealloc];

}

- (void)imageDidFinished:(UIImage *)image para:(NSObject *)obj
{
    NSIndexPath *indexPath = (NSIndexPath *)obj;
    NSUInteger row = [indexPath row];
    if (image) {
        [self.imageArray replaceObjectAtIndex:row withObject:image];
    }
    ArticleCell* cell = (ArticleCell*)[self.listView cellForRowAtIndexPath:indexPath];
    Article* article = [self.listArray objectAtIndex:row];
    [cell setCell:article.title summary:article.summary image:image articletype:[article.articleType intValue]];
    [cell setNeedsDisplay];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)freshLoadArray:(NSString*)reqURL{
    if([(AppDelegate*)[[UIApplication sharedApplication] delegate] getCurrntNet]==nil)
    {
        
    }
    else{
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        NSURL* url = [NSURL URLWithString:reqURL];
        NSArray* array = [[ArticleService getArticleArray:url] retain];
        if ([array count] > 0) {
            [self.listArray removeAllObjects];
            [self.listArray addObjectsFromArray:array];
            [array release];
            [self performSelector:@selector(doneLoadingTableViewData:) withObject:YES];
        }else{
            [self performSelector:@selector(doneLoadingTableViewData:) withObject:NO];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [pool release];
    }
}

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    if([(AppDelegate*)[[UIApplication sharedApplication] delegate] getCurrntNet]==nil)
    {
        
    }
    else{
    	_reloading = YES;
        index = 1;
        NSString* requestURL = [NSString stringWithFormat:@"%@article.show.list.do?actionType=server&requestNum=10&page=%i",[DOITUtil getUrlBase],index];
        [NSThread detachNewThreadSelector:@selector(freshLoadArray:) toTarget:self withObject:requestURL];
    }	
}


- (void)doneLoadingTableViewData:(BOOL)isLoad{
	
	//  model should call this when its done loading
	_reloading = NO;
    if (isLoad) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.listView];
        [self.listView reloadData];
    }
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
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}


@end
