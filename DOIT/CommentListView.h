//
//  CommentListView.h
//  DOIT
//
//  Created by AppDev on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListView : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    IBOutlet UITableView* listView;
    IBOutlet UITextField* commentField;
    IBOutlet UIButton* sendButton;
    IBOutlet UIImageView* backImage;
    IBOutlet UILabel* toastLabel;
    
    NSString* _siteid;
    NSString* _articleid;
    NSMutableData* _data;
    NSString* _userip;
    
    NSMutableArray* commendListArray;
    BOOL keyboardWasShown;
}
@property(nonatomic, retain) IBOutlet UITableView* listView;
@property(nonatomic, retain) IBOutlet UITextField* commentField;
@property(nonatomic, retain) IBOutlet UIButton* sendButton;
@property(nonatomic, retain) IBOutlet UIImageView* backImage;
@property(nonatomic, retain) IBOutlet UILabel* toastLabel;
@property(nonatomic, retain) NSString* siteid;
@property(nonatomic, retain) NSString* articleid;
@property(nonatomic, retain) NSString* userip;

-(IBAction)originalClick:(id)sender;
-(IBAction)publishClick:(id)sender;

@end
