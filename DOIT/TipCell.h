//
//  TipCell.h
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tip.h"

@interface TipCell : UITableViewCell{
    IBOutlet UIImageView* imageView;
    IBOutlet UILabel* authorLabel;
    IBOutlet UILabel* titleLabel;
    IBOutlet UILabel* timeLabel;
    IBOutlet UILabel* viewsLabel;
}

@property(nonatomic, retain) IBOutlet UIImageView* imageView;
@property(nonatomic, retain) IBOutlet UILabel* authorLabel;
@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) IBOutlet UILabel* timeLabel;
@property(nonatomic, retain) IBOutlet UILabel* viewsLabel;

-(void)setCell:(Tip*)tip;

@end
