//
//  TipDetailView.h
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipDetail.h"
#import <MessageUI/MessageUI.h>

@interface TipDetailView : UIViewController<UIWebViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>{
    IBOutlet UIWebView* webView;
    IBOutlet UILabel* pageSizeLabel;
    IBOutlet UILabel* toastLabel;
    IBOutlet UIButton *leftbtn;
    IBOutlet UIButton *rightbtn;
    
    NSString* _tid;
    NSString* _bkid;
    NSString* _tipTitle;
    NSString* _userip;
    
    TipDetail* tipDetail;
    NSString* share_content;
    
    IBOutlet UILabel* titleLabel;
    NSString* titleText;
}

@property(nonatomic, retain) IBOutlet UIWebView* webView;
@property(nonatomic, retain) IBOutlet UILabel* pageSizeLabel;
@property(nonatomic, retain) IBOutlet UILabel* toastLabel;
@property(nonatomic, retain) IBOutlet UIButton *leftbtn;
@property(nonatomic, retain) IBOutlet UIButton *rightbtn;

@property(nonatomic, retain) NSString* tid;
@property(nonatomic, retain) NSString* bkid;
@property(nonatomic, retain) NSString* tipTitle;
@property(nonatomic, retain) NSString* userip;

@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) NSString* titleText;

-(IBAction)backClick:(id)sender;
-(IBAction)replayClick:(id)sender;
-(IBAction)leftClick:(id)sender;
-(IBAction)rightClick:(id)sender;


@end
