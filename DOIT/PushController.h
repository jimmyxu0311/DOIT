//
//  PushController.h
//  手机DOIT
//
//  Created by AppDev on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "InformationDetail.h"

@interface PushController : UIViewController<UIActionSheetDelegate,UITextFieldDelegate,UIWebViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>{
    NSString* artID;
    
    IBOutlet UIButton* genTipButton;
    IBOutlet UIButton* collectionButton;
    IBOutlet UIButton* sendButton;
    IBOutlet UILabel* toastLabel;
//    IBOutlet UILabel* sortLabel;
    IBOutlet UIWebView* webView;
    IBOutlet UITextField* genTipContentText;
    IBOutlet UIImageView* backImage;
    
@private
    BOOL keyboardWasShown;
    NSString* share_Content;
    int commentSize;
    int pageSize;
    float fieldY;
    float imgY;
    BOOL isflage;
    NSMutableString* content;
    NSString* _userip;
    InformationDetail* informationDetail;
    NSMutableData* _data;
}

@property(nonatomic, retain) NSString* artID;

@property(nonatomic, retain) IBOutlet UIButton* genTipButton;
@property(nonatomic, retain) IBOutlet UIButton* collectionButton;
@property(nonatomic, retain) IBOutlet UIButton* sendButton;
@property(nonatomic, retain) IBOutlet UILabel* toastLabel;
@property(nonatomic, retain) IBOutlet UIImageView* backImage;
@property(nonatomic, retain) IBOutlet UIWebView* webView;
@property(nonatomic, retain) IBOutlet UITextField* genTipContentText;



-(IBAction)genTipClick:(id)sender;
-(IBAction)backClick:(id)sender;
-(IBAction)sendClick:(id)sender;
-(IBAction)shareClick:(id)sender;
-(IBAction)collectionClick:(id)sender;
@end
