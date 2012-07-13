//
//  ShareView.m
//  DOIT
//
//  Created by AppDev on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ShareView.h"
#import "AppDelegate.h"
#import "QWeiboSyncApi.h"
#import "TencentLoginView.h"
#import "QWeiboAsyncApi.h"
#import "JSON.h"

#define kOAuthConsumerKey				@"3427254395"		//REPLACE ME
#define kOAuthConsumerSecret			@"a90214025b43251d3b22cabdabf5d8ff"		//REPLACE ME

//NSString *consumerKey = @"801062118";
//NSString *consumerSecret = @"40d8c2c2588b958446457d2c3b868be5";

#define CONSUMERKEY @"801062118"
#define CONSUMERSECRET @"40d8c2c2588b958446457d2c3b868be5"

@interface ShareView (Private)

- (void)removeCachedOAuthDataForUsername:(NSString *) username;
- (void)postNewStatus;

@end

@implementation ShareView

@synthesize shareContent,isBind,inputCount,shareType,shareContentStr,toastLabel,shareLabel;
@synthesize connection;
@synthesize responseData;

- (void)openAuthenticateView {
	[self removeCachedOAuthDataForUsername:_engine.username];
	[_engine signOut];
	UIViewController *controller1 = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	
	if (controller1) 
		[self presentModalViewController: controller animated: YES];
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
}


- (void)loadTimeline {
    controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	if (controller) {
		[self presentModalViewController: controller animated: YES];
        //[self.isBind setText:@"未绑定"];
    }
	else {
        //[self.isBind setText:@"已绑定"];
		[OAuthEngine setCurrentOAuthEngine:_engine];
		[self loadData];
	}
}

-(void)hidden{
    [UIView animateWithDuration:2.0 delay:0 options:0 animations:^{
        toastLabel.alpha = 0;
    } completion:^(BOOL finished){
        toastLabel.alpha = 0;
    }];
}

-(void)show{
    [UIView animateWithDuration:2.0 delay:0 options:0 animations:^{
        toastLabel.alpha = 1;
    } completion:^(BOOL finished){
        toastLabel.alpha = 1;
    }];
}

-(BOOL) validate{
    NSString* textViewContent = self.shareContent.text;
    if ([textViewContent length] <=140 && [textViewContent length] > 0) {
        return true;
    }
    return false;
}

-(IBAction)shareClick:(id)sender{
    if (shareType == 0) {
        controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
        if (controller) {
            [self presentModalViewController: controller animated: YES];
        }else{
            if ([self validate]) {
                [self postNewStatus];
            }
        }
        
    }else{
        if ([self validate]) {
            
            if (appDelegate.tokenKey && ![appDelegate.tokenKey isEqualToString:@""] && 
                appDelegate.tokenSecret && ![appDelegate.tokenSecret isEqualToString:@""]) {
                NSString *content = self.shareContent.text;
                
                //asynchronous http request
                QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
                
                self.connection	= [api publishMsgWithConsumerKey:appDelegate.appKey 
                                                  consumerSecret:appDelegate.appSecret 
                                                  accessTokenKey:appDelegate.tokenKey 
                                               accessTokenSecret:appDelegate.tokenSecret 
                                                         content:content 
                                                       imageFile:nil 
                                                      resultType:RESULTTYPE_JSON 
                                                        delegate:self];
            } else {
                [self.isBind setText:@"未绑定"];
                [self performSelector:@selector(loadLoginView) withObject:nil afterDelay:0];
            }
        }
    }
    
}

- (void)newTweet {
	[draft release];
	draft = [[Draft alloc]initWithType:DraftTypeNewTweet];
	//[self focusInput];
}

- (void)postNewStatus
{
	WeiboClient *client = [[WeiboClient alloc] initWithTarget:self 
													   engine:[OAuthEngine currentOAuthEngine]
													   action:@selector(postStatusDidSucceed:obj:)];
	client.context = [draft retain];
	draft.draftStatus = DraftStatusSending;
    [client post:draft.text];
}

- (void)postStatusDidSucceed:(WeiboClient*)sender obj:(NSObject*)obj;
{
	Draft *sentDraft = nil;
	if (sender.context && [sender.context isKindOfClass:[Draft class]]) {
		sentDraft = (Draft *)sender.context;
		[sentDraft autorelease];
	}
	
    if (sender.hasError) {
        [self loadTimeline];
        [sender alert];	
        return;
    }
    
    NSDictionary *dic = nil;
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary*)obj;    
    }
	
    if (dic) {
        Status* sts = [Status statusWithJsonDictionary:dic];
		if (sts) {
			//delete draft!
			if (sentDraft) {
				
			}
		}
    }
	[self.navigationController popViewControllerAnimated:YES];
}


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

-(IBAction)doneClick:(id)sender{
    [self.shareContent resignFirstResponder];
    if ([self validate]) {
        if (shareType == 0) {
            [self performSelector:@selector(loadTimeline) withObject:nil afterDelay:0]; 
        }else if(shareType == 1){
            if (appDelegate.tokenKey && ![appDelegate.tokenKey isEqualToString:@""] && 
                appDelegate.tokenSecret && ![appDelegate.tokenSecret isEqualToString:@""]) {
                [self.isBind setText:@"已绑定"];
            } else {
                [self.isBind setText:@"未绑定"];
                [self performSelector:@selector(loadLoginView) withObject:nil afterDelay:0];
            }
        }
        
    }
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];  
    [topView setAlpha:0.8];
    [topView setBarStyle:UIBarStyleBlack];  
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];  
    
    
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneClick:)];  
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];  
    
    [doneButton release];  
    
    [btnSpace release];  
    
    [topView setItems:buttonsArray];  
    
    [textView setInputAccessoryView:topView]; 
    return YES;
}

- (void)textChanged:(NSNotification *)notification{
    NSString* textViewContent = self.shareContent.text;
    int input = 140 - textViewContent.length;
    if (input >= 0) {
        self.toastLabel.alpha = 0;
        NSString *inputStr = [NSString stringWithFormat:@"%d",input];
        inputCount.text = inputStr;
        inputCount.textColor = [UIColor blackColor];
    }else{
        [self.toastLabel setText:@"您已超过字数！"];
        self.toastLabel.alpha = 1;
        inputCount.text = @"0";
        inputCount.textColor = [UIColor redColor];
    }
    draft.text = textViewContent;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    if (shareType == 0) {
        self.shareLabel.text = @"分享到新浪微博";
    }else if(shareType == 1){
        self.shareLabel.text = @"分享到腾讯微博";
    }else if(shareType == 2){
        self.shareLabel.text = @"分享到人人网";
    }
    if (shareContentStr != NULL) {
        shareContent.text = shareContentStr;
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
    
    NSUInteger shareContentLenth = [shareContentStr length];
    NSUInteger input = 140 - shareContentLenth;
    NSString *inputStr = [NSString stringWithFormat:@"%d",input];
    inputCount.text = inputStr;
    
    [draft release];
	draft = [[Draft alloc]initWithType:DraftTypeNewTweet];
    draft.text = shareContentStr;
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(textChanged:) 
												 name:UITextViewTextDidChangeNotification 
											   object:self.shareContent];
    if(shareType == 0){
        if (!_engine){
            _engine = [[OAuthEngine alloc] initOAuthWithDelegate: self];
            _engine.consumerKey = kOAuthConsumerKey;
            _engine.consumerSecret = kOAuthConsumerSecret;
        }
        
        //[self performSelector:@selector(loadTimeline) withObject:nil afterDelay:1.0];
    }else if (shareType == 1) {
//        if (appDelegate.tokenKey && appDelegate.tokenSecret) {
//            [self.isBind setText:@"已绑定"];
//        } else {
//            [self.isBind setText:@"未绑定"];
//            [self performSelector:@selector(loadLoginView) withObject:nil afterDelay:1.0];
//        }
    }
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
   
    if (shareType == 0) {
        if (controller) {
            [self.isBind setText:@"未绑定"];
        }else{
            [self.isBind setText:@"已绑定"];
        }
         
    }else if(shareType == 1){
        //NSLog(@"tokenKey = %@, tokenSecret = %@",appDelegate.tokenKey,appDelegate.tokenSecret);
        if (appDelegate.tokenKey && appDelegate.tokenSecret) {
                [self.isBind setText:@"已绑定"];
            } else {
                [self.isBind setText:@"未绑定"];
                //[self performSelector:@selector(loadLoginView) withObject:nil afterDelay:1.0];
            }
    }
}


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

- (void) OAuthControllerFailed: (OAuthController *) controller2 {
    if (controller2) 
		[self presentModalViewController: controller2 animated: YES];
	
}

- (void) OAuthControllerCanceled: (OAuthController *) controller {    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	self.responseData = [NSMutableData data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	appDelegate.response = [[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease];
    //NSLog(@"response = %@",appDelegate.response);
    NSDictionary* dic = [appDelegate.response JSONValue];
    NSString* errcode = [dic objectForKey:@"errcode"];
    //NSLog(@"errcode = %@",errcode);
    int result = -1;
    @try {
        result = [errcode intValue];
    }
    @catch (NSException *exception) {
        result = -2;
    }
    if (result == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.toastLabel setText:@"分享失败！"];
        self.toastLabel.alpha = 1;
    }
	self.connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	appDelegate.response = [NSString stringWithFormat:@"connection error:%@", error];
	self.connection = nil;
}



-(void)dealloc{
    [connection release];
	[responseData release];
    [self.shareLabel release];
    [self.toastLabel release];
    [self.shareContentStr release];
    [self.shareContent release];
    [self.inputCount release];
    [self.isBind release];
    [super dealloc];
}

@end
