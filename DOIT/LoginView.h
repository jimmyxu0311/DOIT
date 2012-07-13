//
//  LoginView.h
//  DOIT
//
//  Created by AppDev on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    IBOutlet UITableView* loginView;
    IBOutlet UILabel* toastLabel;
    
    NSString* userName;
    NSString* passWord;
    
    NSURLConnection* _connection;
    NSMutableData* _data;
}

@property(nonatomic, retain) IBOutlet UITableView* loginView;
@property(nonatomic, retain) IBOutlet UILabel* toastLabel;
@property(nonatomic, retain) NSString* userName;
@property(nonatomic, retain) NSString* passWord;
@property(nonatomic, retain) NSURLConnection* connection;

-(IBAction)loginClick:(id)sender;
-(IBAction)registerClick:(id)sender;
-(IBAction)backClick:(id)sender;

@end
