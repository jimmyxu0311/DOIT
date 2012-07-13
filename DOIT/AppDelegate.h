//
//  AppDelegate.h
//  DOIT
//
//  Created by AppDev on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <mach/mach_host.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <ifaddrs.h>
#import <sys/socket.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <ifaddrs.h>
#import "Reachability.h"
#import "Article.h"

//#import "UICustomTabController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>{
    UINavigationController* navigationController;
    NSString* _userip;
    NSString *appKey;
	NSString *appSecret;
	NSString *tokenKey;
	NSString *tokenSecret;
	NSString *verifier;
	
	NSString *response;
    
    Article* pushArticle;
    
    //    UICustomTabController *tabbar_controller;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController* navigationController;


@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *tokenKey;
@property (nonatomic, copy) NSString *tokenSecret;
@property (nonatomic, copy) NSString *verifier;
@property (nonatomic, copy) NSString *response;

- (void)parseTokenKeyWithResponse:(NSString *)response;

- (void)saveDefaultKey;

- (UIViewController *)mainViewController;

- (NSString*)getCurrntNet;


@end
