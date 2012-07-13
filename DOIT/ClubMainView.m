//
//  ClubMainView.m
//  DOIT
//
//  Created by AppDev on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ClubMainView.h"
#import "Club.h"
#import "DOITUtil.h"
#import "ClubService.h"
#import "ClubSubView.h"
#import "ClubMainListView.h"

@implementation ClubMainView
@synthesize listView;
@synthesize userip = _userip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        UIImage* clubImg = [UIImage imageNamed:@"club_icon.png"];
//        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"社区" image:clubImg tag:1];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:1];
        self.tabBarItem = item;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([listArray count] == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [NSThread detachNewThreadSelector:@selector(loadContent) toTarget:self withObject:nil];
    }
}

-(void)loadContent{
    NSString* urlString = [NSString stringWithFormat:@"%@bbs.bkname.list.do",[DOITUtil getUrlBase]];
    NSURL* url = [NSURL URLWithString:urlString];
    listArray = [[ClubService getAllClubArray:url] retain];
    [self.listView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [listArray count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [[[listArray objectAtIndex:section] objectAtIndex:0] count];
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[listArray objectAtIndex:section] objectAtIndex:1];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    Club* club = [[[listArray objectAtIndex:indexPath.section] objectAtIndex:0] objectAtIndex:row];
    cell.textLabel.text = club.bname;
    
    cell.imageView.image = [UIImage imageNamed:@"icon00.png"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    Club* club = [[[listArray objectAtIndex:indexPath.section] objectAtIndex:0] objectAtIndex:row];
    ClubMainListView* clubMainListView = [[ClubMainListView alloc] initWithNibName:@"ClubMainListView" bundle:nil];
    clubMainListView.bkid = club.bkid;
    clubMainListView.titleText = club.bname;
    [self.navigationController pushViewController:clubMainListView animated:YES];
    [clubMainListView release];
}

-(void)dealloc{
    [self.userip release];
    [listArray release];
    [self.listView release];
    [super dealloc];
}


@end
