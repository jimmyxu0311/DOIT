//
//  PlateInfo.m
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlateInfo.h"

@implementation PlateInfo

@synthesize threads;
@synthesize rowCount;
@synthesize description;
@synthesize pageSize;
@synthesize posts;
@synthesize moderators;
@synthesize pageNum;
@synthesize name;

-(void)dealloc{
    [threads release];
    [rowCount release];
    [description release];
    [pageSize release];
    [posts release];
    [moderators release];
    [pageNum release];
    [name release];
    [super dealloc];
}

@end
