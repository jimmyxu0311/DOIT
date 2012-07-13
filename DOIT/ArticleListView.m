//
//  ArticleListView.m
//  DOIT
//
//  Created by AppDev on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ArticleListView.h"
#import "InformationDetailView.h"
#import "InformationSqlite.h"

@implementation ArticleListView
@synthesize listView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    sqlite = [[SQLite3_Manager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    listArray = [[sqlite queryInformation] retain];
    [self.listView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if ([listArray count] == 0) {
        return;
    }
    InformationSqlite* article = [listArray objectAtIndex:row];
    int isSuccess = [sqlite deleteInformation:article.articleID];
    if (isSuccess == 22) {
        listArray = [[sqlite queryInformation] retain];
        [self.listView reloadData];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [listArray count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    static NSString *cellIndentifier = @"cell";
    //UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle     reuseIdentifier:cellIndentifier] autorelease];
        //cell.editingAccessoryType = UITableViewCellEditingStyleDelete;
        cell.showsReorderControl = YES;
        if ([listArray count] > 0) {
            InformationSqlite* information = [listArray objectAtIndex:row];
            cell.textLabel.text = information.title;
            [cell.textLabel sizeToFit];
            UIFont* font = [UIFont systemFontOfSize:16.0];
            [cell.textLabel setFont:font];
            cell.detailTextLabel.text = information.summary;
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14.0]];
            cell.detailTextLabel.numberOfLines = 2;
        }
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
//    InformationSqlite* article = [listArray objectAtIndex:row];
    InformationDetailView* informationDetailView = [[InformationDetailView alloc] initWithNibName:@"InformationDetailView" bundle:nil];
//    informationDetailView.articleID = article.articleID;
//    informationDetailView.articleTitle = article.title;
//    informationDetailView.summary = article.summary;
//    informationDetailView.siteID = article.siteid;
    informationDetailView.currentArray = listArray;
    informationDetailView.currentIndex = row;
//    informationDetailView.userip = _userip;
    [self.navigationController pushViewController:informationDetailView animated:YES];
    [informationDetailView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.listView = nil;
    listArray = nil;
    sqlite = nil;
}

- (void)dealloc{
    [self.listView release];
    [super dealloc];

    
}
@end
