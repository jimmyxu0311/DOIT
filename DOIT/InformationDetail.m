//
//  InformationDetail.m
//  DOITIOS
//
//  Created by AppDev on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "InformationDetail.h"

@implementation InformationDetail
@synthesize commentNum;
@synthesize content;
@synthesize pageSize;
@synthesize url;
@synthesize title;
@synthesize summary;
@synthesize siteID;


-(void)dealloc{
    [self.content release];
    [self.commentNum release];
    [self.url release];
    [self.pageSize release];
    [self.title release];
    [self.summary release];
    [self.siteID release];
    [super dealloc];
}
@end
