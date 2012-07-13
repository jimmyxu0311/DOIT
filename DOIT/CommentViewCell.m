//
//  CommentViewCell.m
//  DOIT
//
//  Created by AppDev on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommentViewCell.h"

@implementation CommentViewCell
@synthesize authorLabel;
@synthesize timeLabel;
@synthesize contentLabel;


-(void)setCell:(NSString*)author time:(NSString*)time content:(NSString*)content{
    self.authorLabel.text = author;
    self.timeLabel.text = time;
    self.contentLabel.text = content;
}

-(void) dealloc{
    [self.authorLabel release];
    [self.timeLabel release];
    [self.contentLabel release];
    [super dealloc];
}

@end
