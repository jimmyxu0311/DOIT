//
//  ClubSubView.m
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ClubSubView.h"
#import "DOITUtil.h"
#import "ClubService.h"
#import "Club.h"
//#import "ClubListView.h"
#import "ClubMainListView.h"

@implementation ClubSubView
@synthesize listView;
@synthesize bkid = _bkid;
@synthesize userip = _userip;
@synthesize titleLabel;
@synthesize titleText;

-(IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.titleLabel.text = titleText;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([listArray count] == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [NSThread detachNewThreadSelector:@selector(loadContent) toTarget:self withObject:nil];
    }
}

-(void)loadContent{
    NSString* urlString = [NSString stringWithFormat:@"%@bbs.zbk.list.do?bkid=%@",[DOITUtil getUrlBase],_bkid];
    NSURL* url = [NSURL URLWithString:urlString];
    listArray = [[ClubService getClubArray:url] retain];
    [self.listView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [listArray count];
    return count;
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
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImage *image = [UIImage imageNamed:@"icon_08.png"];
    cell.imageView.image = image;
    Club* club = [listArray objectAtIndex:row];
    cell.textLabel.text = club.bname;
    
//    UIImage* imageacc = [UIImage imageNamed:@"right_row"];
//    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageacc.size.width, imageacc.size.height)];
//    imageView.image = imageacc;
//    cell.accessoryView = imageView;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    Club* club = [listArray objectAtIndex:row];
    ClubMainListView* clubMainListView = [[ClubMainListView alloc] initWithNibName:@"ClubMainListView" bundle:nil];
    clubMainListView.bkid = club.bkid;
    clubMainListView.titleText = club.bname;
    [self.navigationController pushViewController:clubMainListView animated:YES];
    [clubMainListView release];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    listArray = nil;
}

-(void)dealloc{
    [self.titleText release];
    [self.titleLabel release];
    [self.bkid release];
    [self.userip release];
    //[listArray release];
    [self.listView release];
    [super dealloc];
}


@end
