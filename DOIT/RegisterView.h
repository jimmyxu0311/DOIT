//
//  RegisterView.h
//  DOIT
//
//  Created by AppDev on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    IBOutlet UITableView* registerView;
    IBOutlet UILabel* toastLabel;
    
    
    NSString* username;
    NSString* email;
    NSString* password;
    NSString* configpassword;
    NSString* telnumber;
    
    NSURLConnection* _connection;
    NSMutableData* _data;
}


@property(nonatomic, retain) IBOutlet UITableView* registerView;
@property(nonatomic, retain) IBOutlet UILabel* toastLabel;


@property(nonatomic, retain) NSString* username;
@property(nonatomic, retain) NSString* email;
@property(nonatomic, retain) NSString* password;
@property(nonatomic, retain) NSString* configpassword;
@property(nonatomic, retain) NSString* telnumber;

@property(nonatomic, retain) NSURLConnection* connection;


-(IBAction)backClick:(id)sender;
-(IBAction)registerClick:(id)sender;
-(IBAction)complete:(id)sender;

@end
