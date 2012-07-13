//
//  AccountsManagerView.m
//  DOIT
//
//  Created by AppDev on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AccountsManagerView.h"
#import "LoginView.h"
#import "RegisterView.h"
#import "UserInfo.h"
#import "QWeiboSyncApi.h"
#import "TencentLoginView.h"

#define kOAuthConsumerKey				@"3427254395"		//REPLACE ME
#define kOAuthConsumerSecret			@"a90214025b43251d3b22cabdabf5d8ff"		//REPLACE ME


#define CONSUMERKEY @"801062118"
#define CONSUMERSECRET @"40d8c2c2588b958446457d2c3b868be5"

@interface AccountsManagerView (Private)

- (void)removeCachedOAuthDataForUsername:(NSString *) username;

@end


@implementation AccountsManagerView
@synthesize userIcon;
@synthesize isLoginLabel;
@synthesize isLoginButton;
@synthesize registerButton;
@synthesize sinaButton;
@synthesize qqButton;
@synthesize userNameLabel;

@synthesize connection;
@synthesize responseData;

bool isBindSina = false;

-(IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) loadLoginView{
    QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
    NSString *retString = [api getRequestTokenWithConsumerKey:CONSUMERKEY consumerSecret:CONSUMERSECRET];
    [appDelegate parseTokenKeyWithResponse:retString];
    
    TencentLoginView* weiboLogin = [[TencentLoginView alloc] initWithNibName:@"TencentLoginView" bundle:nil];
    [self.navigationController pushViewController:weiboLogin animated:YES];
    [weiboLogin release];
}


-(IBAction)loginClick:(id)sender{
    if ([UserInfo sharedInstance].username != nil){
        //清空数据后跳转到登陆页面
        [UserInfo sharedInstance].username = nil;
        [UserInfo sharedInstance].password = nil;
        [UserInfo sharedInstance].faxnumber = nil;
        [UserInfo sharedInstance].gender = nil;
        [UserInfo sharedInstance].address = nil;
        [UserInfo sharedInstance].province = nil;
        [UserInfo sharedInstance].industrytype = nil;
        [UserInfo sharedInstance].department = nil;
        [UserInfo sharedInstance].idnumber = nil;
        [UserInfo sharedInstance].result = nil;
        [UserInfo sharedInstance].postcode = nil;
        [UserInfo sharedInstance].celnumber = nil;
        [UserInfo sharedInstance].realname = nil;
        [UserInfo sharedInstance].jposition = nil;
        [UserInfo sharedInstance].email = nil;
        [UserInfo sharedInstance].copyname = nil;
        [UserInfo sharedInstance].city = nil;
        [UserInfo sharedInstance].telnumber = nil;
        [UserInfo sharedInstance].birthday = nil;
        [UserInfo sharedInstance].headerimg = nil;
        LoginView* loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
        [self.navigationController pushViewController:loginView animated:YES];
        [loginView release];
    }else{
        //跳转到登陆页面
        LoginView* loginView = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
        [self.navigationController pushViewController:loginView animated:YES];
        [loginView release];
    }
}


-(IBAction)registerClick:(id)sender{
    //注册页面
    RegisterView* registerView = [[RegisterView alloc] initWithNibName:@"RegisterView" bundle:nil];
    [self.navigationController pushViewController:registerView animated:YES];
    [registerView release];
}

- (void)loadData {
	if (weiboClient) { 
		return;
	}
	weiboClient = [[WeiboClient alloc] initWithTarget:self 
											   engine:_engine
											   action:@selector(timelineDidReceive:obj:)];
	[weiboClient getFollowedTimelineSinceID:0 
							 startingAtPage:0 count:100];
}

- (void)loadTimeline{
     UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
    if (controller) {
        [self presentModalViewController:controller animated: YES];
        [self.sinaButton performSelectorOnMainThread:@selector(setTitle:forState:) withObject:@"绑定腾讯微博" waitUntilDone:YES];
    }
    else {
        [OAuthEngine setCurrentOAuthEngine:_engine];
        [self.sinaButton performSelectorOnMainThread:@selector(setTitle:forState:) withObject:@"取消绑定" waitUntilDone:YES];
        [self loadData];
    }

}

- (void)loadTimeline:(NSInteger)sign {
      UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
    if (sign == 1) {
        if (isBindSina) {
            [_engine signOut];
            [self.sinaButton setTitle:@"绑定新浪微博" forState:UIControlContentHorizontalAlignmentCenter];
            isBindSina = false;
        }else{
            [self loadTimeline];
        }
    }else{
        if (controller) {
            [self.sinaButton performSelectorOnMainThread:@selector(setTitle:forState:) withObject:@"绑定新浪微博" waitUntilDone:YES];
            isBindSina = false;
        }
        else {
            [self.sinaButton performSelectorOnMainThread:@selector(setTitle:forState:) withObject:@"取消绑定" waitUntilDone:YES];
            isBindSina = true;
        }
    }
}

-(void) tencent{
    if (appDelegate.tokenKey && appDelegate.tokenSecret) {
        appDelegate.tokenKey = nil;
        appDelegate.tokenSecret = nil;
        [appDelegate saveDefaultKey];
        [self.qqButton setTitle:@"绑定腾讯微博" forState:UIControlContentHorizontalAlignmentCenter];
    } else {
        QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
        NSString *retString = [api getRequestTokenWithConsumerKey:CONSUMERKEY consumerSecret:CONSUMERSECRET];
        [appDelegate parseTokenKeyWithResponse:retString];
                
        TencentLoginView* weiboLogin = [[TencentLoginView alloc] initWithNibName:@"TencentLoginView" bundle:nil];
        [self.navigationController pushViewController:weiboLogin animated:YES];
        [weiboLogin release];
    }
    
}
//人人网绑定
-(void)boundRenRen{
    
}

-(IBAction)boundClick:(id)sender{
    UIButton* button = (UIButton*)sender;
    int btnTag = [button tag];
    switch (btnTag) {
        case 10001:{
            //新浪微博分享绑定
            [self loadTimeline:1];
        }
            break;
        case 10002:
            //腾讯微博分享绑定
            [self tencent];
            break;
        case 10003:
            //人人网绑定
            [self boundRenRen];
            break;
        default:
            break;
    }
}

- (void)openAuthenticateView {
	[self removeCachedOAuthDataForUsername:_engine.username];
	[_engine signOut];
	UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	
	if (controller) 
		[self presentModalViewController: controller animated: YES];
}


- (void)followDidReceive:(WeiboClient*)sender obj:(NSObject*)obj {
	if (sender.hasError) {		
        return;
    }
	
    if (obj == nil || ![obj isKindOfClass:[NSDictionary class]]) {
        return;
    }
}

- (void)timelineDidReceive:(WeiboClient*)sender obj:(NSObject*)obj
{
    if (sender.hasError) {
		[sender alert];
        if (sender.statusCode == 401) {
            [self openAuthenticateView];
        }
    }
	weiboClient = nil;
    
    if (obj == nil || ![obj isKindOfClass:[NSArray class]]) {
        return;
    }
    
    [self.sinaButton performSelectorOnMainThread:@selector(setTitle:forState:) withObject:@"取消绑定" waitUntilDone:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_engine){
        _engine = [[OAuthEngine alloc] initOAuthWithDelegate: self];
        _engine.consumerKey = kOAuthConsumerKey;
        _engine.consumerSecret = kOAuthConsumerSecret;
    }
    appDelegate = 
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![CONSUMERKEY isEqualToString:appDelegate.appKey] || 
        ![CONSUMERSECRET isEqualToString:appDelegate.appSecret]) {
        appDelegate.appKey = CONSUMERKEY;
        appDelegate.appSecret = CONSUMERSECRET;
        appDelegate.tokenKey = nil;
        appDelegate.tokenSecret = nil;
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UserInfo sharedInstance].username != nil){
        [self.userNameLabel setText:[UserInfo sharedInstance].username];
        [self.isLoginLabel setText:@"已登录DOIT通行证"];
        [self.isLoginButton setTitle:@"注 销" forState:UIControlContentHorizontalAlignmentCenter];
        [self.registerButton setHidden:YES];
        if ([UserInfo sharedInstance].headerimg != nil) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSString* imageURL = [NSString stringWithFormat:@"http://passport.doit.com.cn%@",[UserInfo sharedInstance].headerimg];
            [NSThread detachNewThreadSelector:@selector(getUserImage:) toTarget:self withObject:imageURL];
        }
    }else{
        [self.userNameLabel setText:@"游 客"];
        [self.isLoginLabel setText:@"未登录DOIT通行证"];
        [self.isLoginButton setTitle:@"登 录" forState:UIControlContentHorizontalAlignmentCenter];
        [self.registerButton setHidden:NO];
        UIImage* image = [UIImage imageNamed:@"more_per_icom.png"];
        [self.userIcon setImage:image];
    }  
    [self loadTimeline:2];
    if (appDelegate.tokenKey && appDelegate.tokenSecret) {
        [self.qqButton setTitle:@"取消绑定" forState:UIControlContentHorizontalAlignmentCenter];
    } else {
        [self.qqButton setTitle:@"绑定腾讯微博" forState:UIControlContentHorizontalAlignmentCenter];
    }
}

-(void)getUserImage:(NSString*)imgURL{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSURL* url = [NSURL URLWithString:imgURL];
    NSData* data = [NSData dataWithContentsOfURL:url];
    UIImage* image = [UIImage imageWithData:data];
    [self.userIcon performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [pool release];
}

-(void) dealloc{
    [self.userIcon release];
    [self.isLoginLabel release];
    [self.isLoginButton release];
    [self.registerButton release];
    [self.sinaButton release];
    [self.qqButton release];
    [self.userNameLabel release];
    [super dealloc];
}


//=============================================================================================================================
#pragma mark OAuthEngineDelegate
- (void) storeCachedOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

- (void)removeCachedOAuthDataForUsername:(NSString *) username{
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults removeObjectForKey: @"authData"];
	[defaults synchronize];
}
//=============================================================================================================================
#pragma mark OAuthSinaWeiboControllerDelegate
- (void) OAuthController: (OAuthController *) controller authenticatedWithUsername: (NSString *) username {
	[self loadTimeline];
}

- (void) OAuthControllerFailed: (OAuthController *) controller {
    if (controller) 
		[self presentModalViewController: controller animated: YES];
	
}

- (void) OAuthControllerCanceled: (OAuthController *) controller {    
}


@end
