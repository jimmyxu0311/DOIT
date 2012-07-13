//
//  ImageTableViewCell.m
//  NSOperationTest
//
//  Created by jhwang on 11-10-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "InformationListCell.h"


@implementation InformationListCell
@synthesize imageView;
@synthesize title,summary;
@synthesize data = _data;

- (void)dealloc
{
    [imageView release];
    [title release];
    [summary release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSMutableData *mdata = [[NSMutableData alloc] init];
        self.data = mdata;
        [mdata release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}


- (void)setCell:(UIImage *)image title:(NSString *)titleText summary:(NSString *)summaryText 
{
    if (image != nil)
    {
        self.imageView.image = image;
    }
    
    self.title.text = titleText;
    self.summary.text = summaryText;
}

@end

