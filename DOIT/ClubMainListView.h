//
//  ClubMainListView.h
//  DOIT
//
//  Created by AppDev on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubMainListView : UIViewController{
    IBOutlet UIView *contentView;
    UIViewController *currentViewController;
    IBOutlet UILabel* titleLabel;
@private
    NSString* titleText;
    NSString* bkid;
    NSMutableArray *btnsArr;
}


@property(nonatomic, retain) IBOutlet UIView *contentView;
@property(nonatomic, retain) IBOutlet UILabel* titleLabel;

@property(nonatomic, retain) NSString* titleText;
@property(nonatomic, retain) NSString* bkid;

-(IBAction)backClick:(id)sender;

@end
