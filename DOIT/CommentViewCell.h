//
//  CommentViewCell.h
//  DOIT
//
//  Created by AppDev on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewCell : UITableViewCell{
    IBOutlet UILabel* authorLabel;
    IBOutlet UILabel* timeLabel;
    IBOutlet UILabel* contentLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* authorLabel;
@property(nonatomic, retain) IBOutlet UILabel* timeLabel;
@property(nonatomic, retain) IBOutlet UILabel* contentLabel;

-(void)setCell:(NSString*)author time:(NSString*)time content:(NSString*)content;

@end
