//
//  MoreMainView.m
//  DOIT
//
//  Created by AppDev on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MoreMainView.h"
#import "AccountsManagerView.h"
#import "AboutView.h"
#import "FeedBackView.h"
#import "SettingView.h"

@implementation MoreMainView
@synthesize listView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        UIImage* moreImg = [UIImage imageNamed:@"more_icon.png"];
//        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"更多" image:moreImg tag:3];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:3];
        self.tabBarItem = item;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    listItem = [[NSArray alloc] initWithObjects:@"设置",@"账号管理",@"官方网站",@"关于",@"意见反馈",@"亲,给DOIT评分", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImage *image = nil;
    NSUInteger row = [indexPath row];
    switch (row) {
        case 0:
            image = [UIImage imageNamed:@"moreitems_setting_icon.png"];
            break;
        case 1:
            image = [UIImage imageNamed:@"moreitems_account_icon.png"];
            break;
        case 2:
            image = [UIImage imageNamed:@"moreitems_officialweibo_icon.png"];
            break;
        case 3:
            image = [UIImage imageNamed:@"moreitems_about_icon.png"];
            break;
        case 4:
            image = [UIImage imageNamed:@"moreitems_feedback_icon.png"];
            break;
        case 5:
            image = [UIImage imageNamed:@"pingfen.png"];
            break;
        default:
            break;
    }
    cell.imageView.image = image;
    cell.textLabel.text = [listItem objectAtIndex:row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (row == 0) {
        SettingView* settingView = [[SettingView alloc] initWithNibName:@"SettingView" bundle:nil];
        [self.navigationController pushViewController:settingView animated:YES];
        [settingView release];
    }if (row == 1) {
        AccountsManagerView* accounts = [[AccountsManagerView alloc] initWithNibName:@"AccountsManagerView" bundle:nil];
        [self.navigationController pushViewController:accounts animated:YES];
        [accounts release];
    }if (row == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.doit.com.cn"]];
    }if (row == 3) {
        AboutView* aboutView = [[AboutView alloc] initWithNibName:@"AboutView" bundle:nil];
        [self.navigationController pushViewController:aboutView animated:YES];
        [aboutView release];
    }if (row == 4) {
        FeedBackView* feedBackView = [[FeedBackView alloc] initWithNibName:@"FeedBackView" bundle:nil];
        [self.navigationController pushViewController:feedBackView animated:YES];
        [feedBackView release];
    }if (row == 5) {
        NSString* str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",513826908];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

-(void)dealloc{
    [self.listView release];
    [super dealloc];
}

@end
