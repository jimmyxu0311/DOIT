//
//  TipCell.m
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TipCell.h"

@implementation TipCell
@synthesize imageView;
@synthesize authorLabel;
@synthesize timeLabel;
@synthesize titleLabel;
@synthesize viewsLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setCell:(Tip*)tip{
    int isJing = [tip.digest intValue];
    if (isJing > 0) {
        [self.imageView setImage:[UIImage imageNamed:@"club_jing.png"]];
    }
    [self.authorLabel setText:tip.author];
    [self.titleLabel setText:tip.subejct];
    if (tip.subejct.length>20) {
        [self.titleLabel setText:[NSString stringWithFormat:@"%@...",[tip.subejct substringToIndex:18]]];
    }
    //self.titleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    //self.titleLabel.numberOfLines = 1;
    NSString* timeString = [NSString stringWithFormat:@"时间: %@",tip.dateline];
    [self.timeLabel setText:timeString];
    NSString* viewsString = [NSString stringWithFormat:@"%@回复|%@查看",tip.replies,tip.views];
    [self.viewsLabel setText:viewsString];
}


-(void)dealloc{
    [self.imageView release];
    [self.authorLabel release];
    [self.timeLabel release];
    [self.titleLabel release];
    [self.viewsLabel release];
    [super dealloc];
}

@end
