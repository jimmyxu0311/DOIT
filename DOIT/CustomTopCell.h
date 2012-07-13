//
//  CustomTopCell.h
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTopCell : UITableViewCell<UIScrollViewDelegate>{
    IBOutlet UIScrollView* myScrollView;
    IBOutlet UIPageControl* myPageControl;
    IBOutlet UILabel* titleLabel;
    
    IBOutlet UIImageView* imageView;
    BOOL pageControlUsed;
    NSArray* articleArray;
}

@property(nonatomic, retain) IBOutlet UIScrollView* myScrollView;
@property(nonatomic, retain) IBOutlet UIPageControl* myPageControl;
@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) IBOutlet UIImageView* imageView;

- (IBAction)changePage:(id)sender;

-(void)setCell:(NSArray*)topArticleArray;

@end
