//
//  ArticleCell.m
//  DOIT
//
//  Created by AppDev on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ArticleCell.h"

@implementation ArticleCell

@synthesize imageView;
@synthesize titleLabel;
@synthesize summaryLabel;
@synthesize imgType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void) setCell:(NSString *)title summary:(NSString *)summary image:(UIImage *)image articletype:(int)articletype{
    [self.titleLabel setAdjustsFontSizeToFitWidth:NO];
    [self.titleLabel setNumberOfLines:1];
    self.titleLabel.lineBreakMode = UILineBreakModeClip;
    self.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    titleLabel.text = title;
    if ([summary length]>=28) {
        summaryLabel.text = [[summary substringToIndex:28] stringByAppendingString:@"..."];
    }
    
    [self.summaryLabel setNumberOfLines:2];
    if (image) {
        self.imageView.image = image;
    }
    switch (articletype) {
        case 1:
            self.imgType.image=[UIImage imageNamed:@"yuanchuang.png"];
            break;
        case 2:
            self.imgType.image=[UIImage imageNamed:@""];
            break;
            
        default:
            break;
    }
}

-(void)dealloc{
    [self.imageView release];
    [self.titleLabel release];
    [self.summaryLabel release];
    [super dealloc];
}

@end
