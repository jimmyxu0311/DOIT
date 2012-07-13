//
//  ShareView.h
//  DOIT
//
//  Created by AppDev on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthController.h"
#import "WeiboClient.h"
#import "Draft.h"
#import "AppDelegate.h"

@interface ShareView : UIViewController<UITextViewDelegate,OAuthControllerDelegate>{
    IBOutlet UITextView* shareContent;
    IBOutlet UILabel* isBind;
    IBOutlet UILabel* inputCount;
    IBOutlet UILabel* toastLabel;
    IBOutlet UILabel* shareLabel;
    int shareType;
    NSString* shareContentStr;
    
    OAuthEngine	*_engine;
	WeiboClient *weiboClient;
    Draft *draft;
    AppDelegate *appDelegate;
    
    NSURLConnection *connection;
    NSMutableData *responseData;
    
    UIViewController *controller;
}

@property (nonatomic, retain) IBOutlet UITextView* shareContent;
@property (nonatomic, retain) IBOutlet UILabel* isBind;
@property (nonatomic, retain) IBOutlet UILabel* inputCount;
@property (nonatomic, retain) IBOutlet UILabel* shareLabel;
@property int shareType;
@property (nonatomic, retain) NSString* shareContentStr;
@property(nonatomic, retain) IBOutlet UILabel* toastLabel;

@property (nonatomic, retain) NSURLConnection	*connection;
@property (nonatomic, retain) NSMutableData		*responseData;

- (void)newTweet;
- (void)openAuthenticateView;
-(IBAction)shareClick:(id)sender;
-(IBAction)backClick:(id)sender;
-(IBAction)doneClick:(id)sender;

@end
