//
//  InformationDetailView.h
//  DOIT
//
//  Created by AppDev on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationDetail.h"
#import <MessageUI/MessageUI.h>

@interface InformationDetailView : UIViewController<UIActionSheetDelegate,UITextFieldDelegate,UIWebViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>{
    IBOutlet UIButton* genTipButton;
    IBOutlet UITextField* genTipContentText;
    IBOutlet UIButton* sendButton;
    IBOutlet UIButton* collectionButton;
    IBOutlet UIWebView* webView;
    InformationDetail* informationDetail;
    IBOutlet UIButton* guidButton;
    
    IBOutlet UILabel* sortLabel;
    IBOutlet UIButton* previous_button;
    IBOutlet UIButton* next_button;
    
    IBOutlet UIImageView* backImage;
    
    IBOutlet UILabel* toastLabel;
    NSString* sortText;
    
    NSString* _articleID;
    NSString* _articleTitle;
    NSString* _summary;
    NSString* _siteID;
    NSString* _userip;
    
    NSMutableData* _data;
    int currentIndex;
    
    NSArray* currentArray;
    
    NSMutableString* content;
    
    BOOL keyboardWasShown;
    NSString* share_Content;
    @private
    int commentSize;
    int pageSize;
    float fieldY;
    float imgY;
//    BOOL isflage;
    int assinNum;
    NSString* path;
}

@property(nonatomic, retain) IBOutlet UILabel* sortLabel;
@property(nonatomic, retain) IBOutlet UIButton* genTipButton;
@property(nonatomic, retain) IBOutlet UITextField* genTipContentText;
@property(nonatomic, retain) IBOutlet UIButton* sendButton;
@property(nonatomic, retain) IBOutlet UIButton* collectionButton;
@property(nonatomic, retain) IBOutlet UIButton* guidButton;
@property(nonatomic, retain) NSString* userip;
@property(nonatomic, retain) IBOutlet UIImageView* backImage;
@property(nonatomic, retain) NSString* sortText;

@property(nonatomic, retain) IBOutlet UIButton* previous_button;
@property(nonatomic, retain) IBOutlet UIButton* next_button;

@property(nonatomic, retain) IBOutlet UILabel* toastLabel;

@property(nonatomic, retain) IBOutlet UIWebView* webView;

@property(nonatomic, retain) NSArray* currentArray;
@property int currentIndex;

-(IBAction)genTipClick:(id)sender;
-(IBAction)backClick:(id)sender;
-(IBAction)sendClick:(id)sender;
-(IBAction)shareClick:(id)sender;
-(IBAction)collectionClick:(id)sender;
-(IBAction)previousClick:(id)sender;
-(IBAction)nextClick:(id)sender;
-(IBAction)guidButtonClick:(id)sender;
-(IBAction)topBackImgClick:(id)sender;

@end
