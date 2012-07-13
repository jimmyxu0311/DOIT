//
//  SettingView.m
//  DOIT
//
//  Created by AppDev on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingView.h"
#import "MobileInfo.h"

@implementation SettingView
@synthesize listView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString*)dataFilePath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [paths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:@"userInfo.plist"];
}

//保存用户数据
-(void)saveData{
    NSString* filePath = [self dataFilePath];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:trueOrFalse forKey:@"isLoad"];
    [dict writeToFile:filePath atomically:YES];
    [dict release];
}

//读取数据
-(NSString*)readData{
    NSString* filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableDictionary* dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
        return [dict objectForKey:@"isLoad"];
    }
    return nil;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[self readData] isEqualToString:@"true"]) {
        isLoadImg = YES;
    }else{
        isLoadImg = NO;
    }
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableViewA {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableViewA numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableViewA cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* celldentifier = @"cell";
    UITableViewCell* cell = [tableViewA dequeueReusableCellWithIdentifier:celldentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:celldentifier] autorelease];
    }
    NSUInteger row = [indexPath row];
    if (row == 0) {
        UISwitch* swithchView = [[UISwitch alloc] init];
        [swithchView setOnTintColor:[UIColor orangeColor]];
        [swithchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [swithchView setOn:isLoadImg];
        cell.accessoryView = swithchView;
        cell.textLabel.text = @"下载设置";
        cell.detailTextLabel.text = @"2G/3G网络是否下载文章列表页图片";
    }
    else{
        cell.textLabel.text = @"检测新版本";
        cell.detailTextLabel.text = @"手动检测新版本";
    }
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:10.0]];
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    if (row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/zhang-shang-doit/id513826908?mt=8"]];
    }
    
}

-(void) switchAction:(id)sender{
    UISwitch* swch = (UISwitch*)sender;
    isLoadImg = swch.on;
    if (isLoadImg) {
        trueOrFalse = @"true";
        [self saveData];
        if (![[appDelegate getCurrntNet] isEqualToString:@"wifi"]) {
            [MobileInfo shareInstance].isLoadImg = true;
        }
    }else{
        trueOrFalse = @"false";
        [self saveData];
        if (![[appDelegate getCurrntNet] isEqualToString:@"wifi"]) {
            [MobileInfo shareInstance].isLoadImg = false;
        }
    }
}

-(void)dealloc{
    [self.listView release];
    [super dealloc];
}

@end
