//
//  MainViewController.h
//  DOIT
//
//  Created by AppDev on 12-2-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController{
    IBOutlet UIView *contentView;
    UIViewController *currentViewController;
    UIView *bgView;
    NSMutableArray *btnsArr;
    UIButton *btninfo;
    //    NSMutableArray* imageArray;
}

//@property(nonatomic, retain) NSMutableArray* imageArray;
@property(nonatomic, retain) IBOutlet UIView *contentView;

@end
