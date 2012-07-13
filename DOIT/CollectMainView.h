//
//  CollectMainView.h
//  DOIT
//
//  Created by AppDev on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectMainView : UIViewController{
    IBOutlet UIView *contentView;
    UIViewController *currentViewController;
    NSMutableArray *btnsArr;
}

@property(nonatomic, retain) IBOutlet UIView *contentView;


@end
