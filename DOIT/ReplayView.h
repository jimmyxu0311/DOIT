//
//  ReplayView.h
//  DOIT
//
//  Created by AppDev on 11-12-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplayView : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>{
    IBOutlet UITextView* textView;
    IBOutlet UIImageView* selImageView;
    IBOutlet UILabel* toastLabel;

    NSString* _tid;
    NSString* _pid;
    NSString* _fid;
    NSString* _userip;
}

@property(nonatomic, retain) IBOutlet UITextView* textView;
@property(nonatomic, retain) IBOutlet UIImageView* selImageView;
@property(nonatomic, retain) IBOutlet UILabel* toastLabel;

@property(nonatomic, retain) NSString* tid;
@property(nonatomic, retain) NSString* pid;
@property(nonatomic, retain) NSString* fid;
@property(nonatomic, retain) NSString* userip;

-(IBAction)backClick:(id)sender;
-(IBAction)sendClick:(id)sender;
-(IBAction)selectImgClick:(id)sender;
-(IBAction)startCamareClick:(id)sender;

@end
