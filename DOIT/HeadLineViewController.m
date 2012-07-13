//
//  HeadLineViewController.m
//  DOIT
//
//  Created by AppDev on 12-2-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HeadLineViewController.h"
#import "DOITUtil.h"
#import "ArticleService.h"
#import "TopImageViewCell.h"
#import "ArticleCell.h"
#import "InformationDetailView.h"
#import "Article.h"
#import "AppDelegate.h"
#import "SQLite3_Manager.h"
#import "GTMBase64.h"

@implementation HeadLineViewController
@synthesize listView;
@synthesize topArray;
@synthesize listArray;
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
        self.imageArray = [[NSMutableArray alloc] init];
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
        return rowCount + 2;
    }
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (row == 0) {
        return 170;
    }else if (row == [self.listArray count] + 1) {
        return 30;
    }else{
        return 75;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] getCurrntNet]==nil) {
        if (row == 0) {
            static NSString* firstRow = @"firstRow";
            TopImageViewCell* cell = (TopImageViewCell*)[tableView dequeueReusableCellWithIdentifier:firstRow];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            if (cell == nil) {
                cell = [[[TopImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstRow] autorelease];
                [cell setCell:topArray];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }else if(row == [self.listArray count] + 1){
            static NSString* endRow = @"endRow";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:endRow];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:endRow] autorelease];
            }
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.text = @"查看更多";
            listView.backgroundColor=[UIColor whiteColor];
            return cell;
        }else{
            static NSString* cellDefine = @"cellDefine";
            Article* article = [self.listArray objectAtIndex:(row - 1)];
            ArticleCell* cell = (ArticleCell*)[tableView dequeueReusableCellWithIdentifier:cellDefine];
            if (nil == cell) {
                NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"ArticleCell" owner:self options:nil];
                cell = (ArticleCell *)[bundle objectAtIndex:0];
                [cell setCell:article.title summary:article.summary image:[UIImage imageWithData:[GTMBase64 decodeString:article.pictrue]] articletype:[article.articleType intValue]];
            }
            return cell;
        }
    }

    if (row == 0) {
        static NSString* firstRow = @"firstRow";
        TopImageViewCell* cell = (TopImageViewCell*)[tableView dequeueReusableCellWithIdentifier:firstRow];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        if (cell == nil) {
            cell = [[[TopImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstRow] autorelease];
            [cell setCell:topArray];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if(row == [self.listArray count] + 1){
        static NSString* endRow = @"endRow";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:endRow];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:endRow] autorelease];
        }
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"查看更多";
        listView.backgroundColor=[UIColor whiteColor];
        return cell;
    }else{
        static NSString* cellDefine = @"cellDefine";
        Article* article = [self.listArray objectAtIndex:(row - 1)];
        ArticleCell* cell = (ArticleCell*)[tableView dequeueReusableCellWithIdentifier:cellDefine];
        if (nil == cell) {
            NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"ArticleCell" owner:self options:nil];
            cell = (ArticleCell *)[bundle objectAtIndex:0];
            NSNull *null = (NSNull *)[self.imageArray objectAtIndex:(row - 1)];
            if (![null isKindOfClass:[NSNull class]])
            {
                [cell setCell:article.title summary:article.summary image:[self.imageArray objectAtIndex:(row - 1)] articletype:[article.articleType intValue]];
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
    }
}

- (void)imageDidFinished:(UIImage *)image para:(NSObject *)obj
{
    
    NSIndexPath *indexPath = (NSIndexPath *)obj;
    NSUInteger row = [indexPath row];
    if (image) {
        [self.imageArray replaceObjectAtIndex:(row - 1) withObject:image];
    }
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] getCurrntNet]==nil) {
        ArticleCell* cell = (ArticleCell*)[self.listView cellForRowAtIndexPath:indexPath];
        Article* article = [self.listArray objectAtIndex:(row - 1)];
        [cell setCell:article.title summary:article.summary image:[UIImage imageWithData:[GTMBase64 decodeString:article.pictrue]] articletype:[article.articleType intValue]];
        [cell setNeedsDisplay];

    }
    else{
        ArticleCell* cell = (ArticleCell*)[self.listView cellForRowAtIndexPath:indexPath];
        Article* article = [self.listArray objectAtIndex:(row - 1)];
        [cell setCell:article.title summary:article.summary image:image articletype:[article.articleType intValue]];
        [cell setNeedsDisplay];

    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger row = [indexPath row];
    if (row==0) {
        return;
    }
    
    else if (row == [self.listArray count] + 1) {
        index++;
        UITableViewCell* moreCell = [self.listView cellForRowAtIndexPath:indexPath];
        moreCell.textLabel.text = @"正在加载...";
        
        NSString *informationURLStr = [NSString stringWithFormat:@"http://m.doit.com.cn/api/article.show.list.do?actionType=ttlist&requestNum=5&page=%d",index];
        
        [self performSelectorInBackground:@selector(loadMoreList:) withObject:informationURLStr];
        [self.listView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        InformationDetailView* informationDetailView = [[InformationDetailView alloc] initWithNibName:@"InformationDetailView" bundle:nil];
        informationDetailView.sortText = @"头条";
        informationDetailView.currentIndex = row - 1;
        informationDetailView.currentArray = self.listArray;
        
        [self.navigationController pushViewController:informationDetailView animated:YES];
        [informationDetailView release];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    listView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"roding.png"]];
    index = 1;
    self.listArray = [[NSMutableArray alloc] init];    
    if (_refreshHeaderView == nil) {
		
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.listView.bounds.size.height, self.view.frame.size.width, self.listView.bounds.size.height)];        
		_refreshHeaderView.delegate = self;
        
		[self.listView addSubview:_refreshHeaderView];
	}
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] getCurrntNet]==nil) {
        SQLite3_Manager *sqlm=[[SQLite3_Manager alloc] init];
        listArray=[[sqlm queryInformationCache:@"HeadLine"] retain];
        topArray=[[sqlm queryInformationTop] retain];
        [self.listView reloadData];
    }
    else{
        if ([self.listArray count] == 0 || [self.topArray count] == 0) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSString* requestURL = [NSString stringWithFormat:@"%@article.show.list.do?actionType=ttlist&requestNum=5&page=%i",[DOITUtil getUrlBase],index];
            [NSThread detachNewThreadSelector:@selector(fetchListArray:) toTarget:self withObject:requestURL];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (_refreshHeaderView != nil) {
        [_refreshHeaderView release];
    }
}

- (void)dealloc{
    [self.listView release];
    [self.topArray release];
    [self.imageArray release];

    [super dealloc];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)freshLoadArray:(NSString*)reqURL{
    if([(AppDelegate*)[[UIApplication sharedApplication] delegate] getCurrntNet]==nil)
    {
    
    }
    else{
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        NSURL* topURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=ttfocus",[DOITUtil getUrlBase]]];
        NSArray* topArr = [[ArticleService getArticleArray:topURL] copy];
        
        NSURL* url = [NSURL URLWithString:reqURL];
        NSArray* array = [[ArticleService getArticleArray:url] copy];
        if ([topArr count] > 0 && [array count] > 0) {
            [self.topArray removeAllObjects];
            [self.listArray removeAllObjects];
            [self.topArray addObjectsFromArray:topArr];
            [self.listArray addObjectsFromArray:array];
            [self performSelector:@selector(doneLoadingTableViewData:) withObject:YES];
        }else{
            [self performSelector:@selector(doneLoadingTableViewData:) withObject:NO];
        }
        [topArr release];
        [array release];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [pool release];

    }
}

- (void)reloadTableViewDataSource{
    if([(AppDelegate*)[[UIApplication sharedApplication] delegate] getCurrntNet]==nil)
    {
        
    }
    else{
        _reloading = YES;
        index = 1;
        
        NSString* requestURL = [NSString stringWithFormat:@"%@article.show.list.do?actionType=ttlist&requestNum=5&page=%i",[DOITUtil getUrlBase],index];
        [NSThread detachNewThreadSelector:@selector(freshLoadArray:) toTarget:self withObject:requestURL];
    }
}

- (void)doneLoadingTableViewData:(BOOL)isLoad{
	
	//  model should call this when its done loading
   	_reloading = NO;
    
    if (isLoad) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.listView];
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
    [listView reloadData];
	return [NSDate date]; // should return date data source was last changed
}


@end
