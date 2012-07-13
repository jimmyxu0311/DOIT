//
//  AppDelegate.m
//  DOIT
//
//  Created by AppDev on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "ClubMainView.h"
#import "CollectMainView.h"
#import "MoreMainView.h"
#import "DOITUtil.h"
#import "MobileInfo.h"
#import "UserInfo.h"
#import "NSURL+QAdditions.h"
#import "MainViewController.h"
#import "JSON.h"
#import "PushController.h"

#define AppKey			@"appKey"
#define AppSecret		@"appSecret"
#define AppTokenKey		@"tokenKey"
#define AppTokenSecret	@"tokenSecret"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController;

@synthesize appKey;
@synthesize appSecret;
@synthesize tokenKey;
@synthesize tokenSecret;
@synthesize verifier;
@synthesize response;


- (void)dealloc
{
    [appKey release];
	[appSecret release];
	[tokenKey release];
	[tokenSecret release];
	[verifier release];
    [self.navigationController release];
    [_window release];
    [super dealloc];
}

-(NSString*)dataFilePath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [paths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:@"userInfo.plist"];
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

- (NSString*)getCarrier:(NSString*)imsi{
    if (imsi == nil || [imsi isEqualToString:@"SIM Not Inserted"]) {
        return @"Unknown";
    }else{
        if ([[imsi substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"460"]) {
            NSInteger MNC = [[imsi substringWithRange:NSMakeRange(3, 2)] intValue];
            switch (MNC) {
                case 00:
                case 02:
                case 07:
                    return @"China Mobile";
                    break;
                case 01:
                case 06:
                    return @"China Unicom";
                    break;
                case 03:
                case 05:
                    return @"China Telecom";
                    break;
                case 20:
                    return @"China Tietong";
                    break;
                default:
                    break;
            }
        }
    }
    return @"Unknown";
}

- (NSString*)getCurrntNet{
    NSString* result = @"3g";
    Reachability* r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            result = nil;
            break;
        case ReachableViaWWAN:
            result = @"3g";
            break;
        case ReachableViaWiFi:
            result = @"wifi";
            break;
    }
    return result;
}


- (void)loadDefaultKey {
	self.appKey = [[NSUserDefaults standardUserDefaults] valueForKey:AppKey];
	self.appSecret = [[NSUserDefaults standardUserDefaults] valueForKey:AppSecret];
	self.tokenKey = [[NSUserDefaults standardUserDefaults] valueForKey:AppTokenKey];
	self.tokenSecret = [[NSUserDefaults standardUserDefaults] valueForKey:AppTokenSecret];
}

-(void)customizeAppearance{
    //    UIImage* gradientImage44 = [[UIImage imageNamed:@"homebar"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    //    [[UINavigationBar appearance] setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsDefault];
    
    //    UIImage* tabBackground = [[UIImage imageNamed:@"down_toolbar_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    //    [[UITabBar appearance] setBackgroundImage:tabBackground];
    
    //定制UISegmentedControl
    //    UIImage* segmentSelected = [[UIImage imageNamed:@"segment_sel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    //    UIImage* segmentUnselected = [[UIImage imageNamed:@"segment_unsel"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    //    
    //    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    
//    [[UISegmentedControl appearance] setBackgroundImage:[UIImage imageNamed:@"segment_select.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
 
}

-(void)acountUserCount{
    NSString *deviceid = [DOITUtil deviceID];
    deviceid = [deviceid substringFromIndex:8];
    NSString* requestURL = [NSString stringWithFormat:@"http://m.doit.com.cn:80/api/more.submit.phoneinfo.do?productid=%@&phonemodel=iphone",deviceid];
    NSURL* url = [NSURL URLWithString:requestURL];
    NSString* jsonString = [DOITUtil getRequestJsonData:url];
    NSString* stute = nil;
    if (nil!=jsonString) {
        NSDictionary* jsonDictionary = [jsonString JSONValue];
        if (nil != jsonDictionary) {
            stute = [jsonDictionary objectForKey:@"state"];
            if ([stute isEqualToString:@"0"]) {
                [self acountUserCount];
            }
        }
    }
}

-(void)sendToken:(NSString*)str{
    NSString* url = [NSString stringWithFormat:@"http://m.doit.com.cn/api/more.submit.tokeninfo.do?tokenstr=%@",str];
    NSURL* rqURL = [NSURL URLWithString:url];
    NSString* backData = [DOITUtil getRequestJsonData:rqURL];
    
//    NSLog(@"backData = %@",backData);
    
    NSString* stute = nil;
    if (nil != backData) {
        NSDictionary* jsonDictionary = [backData JSONValue];
        if (nil != jsonDictionary) {
            stute = [jsonDictionary objectForKey:@"state"];
            if ([stute isEqualToString:@"0"]) {
                [self sendToken:str];
            }
        }
    }
    
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString* str = [NSString stringWithFormat:@"%@",deviceToken];
//    NSLog(@"str = %@",str);
    NSString* tokenStr = [str substringWithRange:NSMakeRange(1,([str length] - 2))];
//    NSLog(@"tokenStr = %@",tokenStr);
    NSString* token = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"token = %@",token);
//    for (int i = 0; i < [tokenStr length]; i++) {
//        char c = [tokenStr characterAtIndex:i];
//        if (c != ' ') {
//            
//        }
//    }
    
    //将deviceToken发送到服务器端
    [NSThread detachNewThreadSelector:@selector(sendToken:) toTarget:self withObject:token];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSString* str = [NSString stringWithFormat:@"Error: %@",error];
    NSLog(@"error = %@",str);
}

//处理收到的消息推送
-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    /*
     判断程序是在前台还是在后台运行
     */
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive) {
        NSString* UrlData = [userInfo objectForKey:@"url"];
        if (UrlData) {
            PushController* pushController = [[PushController alloc] initWithNibName:@"PushController" bundle:nil];
            pushController.artID = UrlData;
            [self.navigationController pushViewController:pushController animated:YES];
            [pushController release];
            application.applicationIconBadgeNumber = 0;
            //            [application unregisterForRemoteNotifications];
            [application cancelAllLocalNotifications];
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [NSThread detachNewThreadSelector:@selector(acountUserCount) toTarget:self withObject:nil];
    
    if ([self readData] == nil || [[self readData] isEqualToString:@"true"]){
        [MobileInfo shareInstance].isLoadImg = true;
    }else{
        if ([[self getCurrntNet] isEqualToString:@"wifi"]) {
            [MobileInfo shareInstance].isLoadImg = true;
        }else{
            [MobileInfo shareInstance].isLoadImg = false;
        }
    }
    [self loadDefaultKey];
    [self customizeAppearance];
    
    //测试获取手机ip地址
    _userip = [DOITUtil deviceIPAddress];
    [MobileInfo shareInstance].userIPAddress = _userip;
    
    self.navigationController = [[UINavigationController alloc] init];
    navigationController.navigationBarHidden = YES;
    
    //资讯页面
    MainViewController* mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UITabBarItem *mainItem=[[UITabBarItem alloc] initWithTitle:@"资讯" image:[UIImage imageNamed:@"icon_zixun.png"] tag:0];
    [mainItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_sel_zixun.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_zixun.png"]];
    [mainViewController setTabBarItem:mainItem];
    [mainItem release];

    
    //社区页面
    ClubMainView* clubMainView = [[[ClubMainView alloc] initWithNibName:@"ClubMainView" bundle:nil] autorelease];
    clubMainView.userip = _userip;
    UITabBarItem *clubMainItem=[[UITabBarItem alloc] initWithTitle:@"社区" image:[UIImage imageNamed:@"icon_shequ.png"] tag:1];
    [clubMainItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_sel_shequ.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_shequ.png"]];
    [clubMainView setTabBarItem:clubMainItem];
    [clubMainItem release];

    
    //收藏
    CollectMainView* favoritesMainView = [[[CollectMainView alloc] initWithNibName:@"CollectMainView" bundle:nil] autorelease];
    UITabBarItem *favoritesMainItem=[[UITabBarItem alloc] initWithTitle:@"收藏" image:[UIImage imageNamed:@"icon_shoucang.png"] tag:2];
    [favoritesMainItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_sel_shoucang.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_shoucang.png"]];
    [favoritesMainView setTabBarItem:favoritesMainItem];
    [favoritesMainItem release];

    
    //更多
    MoreMainView* moreMainView = [[[MoreMainView alloc] initWithNibName:@"MoreMainView" bundle:nil] autorelease];
    UITabBarItem *moreMainItem=[[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"icon_gengduo.png"] tag:3];
    [moreMainItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_sel_gengduo.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_gengduo.png"]];
    [moreMainView setTabBarItem:moreMainItem];
    [moreMainItem release];
    
    NSArray* viewArray = [NSArray arrayWithObjects:mainViewController, clubMainView, favoritesMainView, moreMainView, nil];
    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background.png"]];
    [tabController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_select.png"]];

    tabController.viewControllers = viewArray;
    
    [self.navigationController pushViewController:tabController animated:YES];
    [tabController release];
    
    [self.window addSubview:self.navigationController.view];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive) {
        NSDictionary* pushDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (pushDict) {
            NSString* URLData = [pushDict objectForKey:@"url"];
            if (URLData) {
                PushController* pushController = [[PushController alloc] initWithNibName:@"PushController" bundle:nil];
                pushController.artID = URLData;
                [self.navigationController pushViewController:pushController animated:YES];
                [pushController release];
                application.applicationIconBadgeNumber = 0;
                //                [application unregisterForRemoteNotifications];
                [application cancelAllLocalNotifications];
            }
        }
    }
    
    return YES;
}

- (void)parseTokenKeyWithResponse:(NSString *)aResponse {
	NSDictionary *params = [NSURL parseURLQueryString:aResponse];
	self.tokenKey = [params objectForKey:@"oauth_token"];
	self.tokenSecret = [params objectForKey:@"oauth_token_secret"];
	
}

- (void)saveDefaultKey {
	[[NSUserDefaults standardUserDefaults] setValue:self.appKey forKey:AppKey];
	[[NSUserDefaults standardUserDefaults] setValue:self.appSecret forKey:AppSecret];
	[[NSUserDefaults standardUserDefaults] setValue:self.tokenKey forKey:AppTokenKey];
	[[NSUserDefaults standardUserDefaults] setValue:self.tokenSecret forKey:AppTokenSecret];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIViewController *)mainViewController {
	return self.navigationController;
}

@end
