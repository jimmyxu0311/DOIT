//
//  TencentLoginView.m
//  DOIT
//
//  Created by AppDev on 11-12-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TencentLoginView.h"
#define VERIFY_URL @"http://open.t.qq.com/cgi-bin/authorize?oauth_token="
#import "QWeiboSyncApi.h"
#import "AppDelegate.h"

@implementation TencentLoginView
@synthesize mWebView;

-(IBAction)cancerClick:(id)sender{
    appDelegate.tokenKey = nil;
    appDelegate.tokenSecret = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *url = [NSString stringWithFormat:@"%@%@", VERIFY_URL, appDelegate.tokenKey];
	NSURL *requestUrl = [NSURL URLWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
	[mWebView loadRequest:request];
}

-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	for(NSString *aPair in pairs){
		NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
		if([keyAndValue count] != 2) continue;
		if([[keyAndValue objectAtIndex:0] isEqualToString:key]){
			return [keyAndValue objectAtIndex:1];
		}
	}
	return nil;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	NSString *query = [[request URL] query];
	NSString *verifier = [self valueForKey:@"oauth_verifier" ofQuery:query];
	
	if (verifier && ![verifier isEqualToString:@""]) {
		
		QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
		NSString *retString = [api getAccessTokenWithConsumerKey:appDelegate.appKey 
												  consumerSecret:appDelegate.appSecret 
												 requestTokenKey:appDelegate.tokenKey 
											  requestTokenSecret:appDelegate.tokenSecret 
														  verify:verifier];
		[appDelegate parseTokenKeyWithResponse:retString];
		[appDelegate saveDefaultKey];
		
        [self.navigationController popViewControllerAnimated:YES];
		
		return NO;
	}
	
	return YES;
}



-(void) dealloc{
    [self.mWebView release];
    [super dealloc];
}

@end
