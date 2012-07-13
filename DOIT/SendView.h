//
//  SendView.h
//  DOIT
//
//  Created by AppDev on 11-12-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendView : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>{
    IBOutlet UITextField* titleField;
    IBOutlet UITextView* messageTextView;
    IBOutlet UILabel* toastLabel;
    IBOutlet UIImageView* selImageView;
    
    NSString* _fid;
    NSString* _userip;
}

@property(nonatomic, retain) IBOutlet UITextField* titleField;
@property(nonatomic, retain) IBOutlet UITextView* messageTextView;
@property(nonatomic, retain) IBOutlet UILabel* toastLabel;
@property(nonatomic, retain) IBOutlet UIImageView* selImageView;

@property(nonatomic, retain) NSString* fid;
@property(nonatomic, retain) NSString* userip;

-(IBAction)backClick:(id)sender;
-(IBAction)sendClick:(id)sender;
-(IBAction)selectImgClick:(id)sender;
-(IBAction)startCamareClick:(id)sender;


@end
