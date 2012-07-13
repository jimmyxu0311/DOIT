//
//  CustomInformationCell.m
//  DOIT
//
//  Created by AppDev on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomInformationCell.h"

@implementation CustomInformationCell
@synthesize informationTitle;
@synthesize informationSummary;
@synthesize informationImg;
@synthesize data = _data;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


-(void) setCell:(NSString*)url title:(NSString*)title summary:(NSString*)summary{
    self.informationTitle.text = title;
    self.informationSummary.text = summary;
    if (url) {
        NSMutableData *mdata = [[NSMutableData alloc] init];
        self.data = mdata;
        [mdata release];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        NSURL* imgUrl = [NSURL URLWithString:url];
        NSURLRequest* request = [NSURLRequest requestWithURL:imgUrl];
        [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1{
    [_data appendData:data1];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    UIImage *img = [UIImage imageWithData:_data];
    self.informationImg.image = img;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)dealloc{
    [self.data release];
    [self.informationTitle release];
    [self.informationSummary release];
    [self.informationImg release];
    [super dealloc];
}


@end
