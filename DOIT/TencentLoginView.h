//
//  TencentLoginView.h
//  DOIT
//
//  Created by AppDev on 11-12-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TencentLoginView : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView* mWebView;
    
    AppDelegate *appDelegate;
}
@property(nonatomic, retain) IBOutlet UIWebView* mWebView;

-(IBAction)cancerClick:(id)sender;

@end
