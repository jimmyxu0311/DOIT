//
//  TipListView.m
//  DOIT
//
//  Created by AppDev on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TipListView.h"
#import "TipSqlite.h"
#import "TipDetailView.h"

@implementation TipListView
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
    listArray = [[sqlite queryTip] retain];
    if ([listArray count] == 0) {
        return;
    }
    [self.listView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    sqlite = nil;
    listArray = nil;
    listView = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"点击了编辑");
    NSUInteger row = [indexPath row];
    if ([listArray count] == 0) {
        return;
    }
    TipSqlite* tip = [listArray objectAtIndex:row];
    int isSuccess = [sqlite deleteTip:tip.tid];
    if (isSuccess == 22) {
        listArray = [[sqlite queryTip] retain];
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
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    static NSString *cellIndentifier = @"celldefine";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier] autorelease];
        cell.showsReorderControl = YES;
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        TipSqlite* tip = [listArray objectAtIndex:row];
        cell.textLabel.text = tip.title;
        [cell.textLabel sizeToFit];
        UIFont* font = [UIFont systemFontOfSize:16.0];
        [cell.textLabel setFont:font];
        cell.textLabel.numberOfLines = 2;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    TipSqlite* tip = [listArray objectAtIndex:row];
    TipDetailView* tipDetailView = [[TipDetailView alloc] initWithNibName:@"TipDetailView" bundle:nil];
    tipDetailView.tid = tip.tid;
    tipDetailView.tipTitle = tip.title;
    tipDetailView.bkid = tip.bkid;
//    tipDetailView.userip = _userip;
    [self.navigationController pushViewController:tipDetailView animated:YES];
    [tipDetailView release];
}

- (void)dealloc{
    [self.listView release];
    [super dealloc];
    
}

@end
