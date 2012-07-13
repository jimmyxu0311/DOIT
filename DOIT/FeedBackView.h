//
//  FeedBackView.h
//  DOIT
//
//  Created by AppDev on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackView : UIViewController<UITextViewDelegate>{
    IBOutlet UITextView* feedBackTextView;
    IBOutlet UILabel* limitLabel;
    IBOutlet UILabel* toastLabel;
    
    NSURLConnection* _connection;
    NSMutableData* _data;
}

@property(nonatomic, retain) IBOutlet UITextView* feedBackTextView;
@property(nonatomic, retain) IBOutlet UILabel* limitLabel;
@property(nonatomic, retain) IBOutlet UILabel* toastLabel;

@property(nonatomic, retain) NSURLConnection* connection;


-(IBAction)backClick:(id)sender;
-(IBAction)sendClick:(id)sender;
-(IBAction)doneClick:(id)sender;



@end
