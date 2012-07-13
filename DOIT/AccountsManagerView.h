//
//  AccountsManagerView.h
//  DOIT
//
//  Created by AppDev on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthController.h"
#import "WeiboClient.h"
#import "AppDelegate.h"

@interface AccountsManagerView : UIViewController<OAuthControllerDelegate>{
    IBOutlet UIImageView* userIcon;
    IBOutlet UILabel* isLoginLabel;
    IBOutlet UIButton* isLoginButton;
    IBOutlet UIButton* registerButton;
    IBOutlet UIButton* sinaButton;
    IBOutlet UIButton* qqButton;
    IBOutlet UILabel* userNameLabel;
    
    OAuthEngine				*_engine;
	WeiboClient *weiboClient;
    
    NSURLConnection *connection;
    NSMutableData *responseData;
    AppDelegate *appDelegate;
    

}

@property(nonatomic, retain) IBOutlet UIImageView* userIcon;
@property(nonatomic, retain) IBOutlet UILabel* isLoginLabel;
@property(nonatomic, retain) IBOutlet UIButton* isLoginButton;
@property(nonatomic, retain) IBOutlet UIButton* registerButton;
@property(nonatomic, retain) IBOutlet UIButton* sinaButton;
@property(nonatomic, retain) IBOutlet UIButton* qqButton;
@property(nonatomic, retain) IBOutlet UILabel* userNameLabel;

@property (nonatomic, retain) NSURLConnection	*connection;
@property (nonatomic, retain) NSMutableData		*responseData;

- (void)openAuthenticateView;
-(IBAction)backClick:(id)sender;
-(IBAction)loginClick:(id)sender;
-(IBAction)registerClick:(id)sender;
-(IBAction)boundClick:(id)sender;

@end
