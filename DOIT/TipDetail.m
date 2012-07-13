//
//  TipDetail.m
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TipDetail.h"

@implementation TipDetail
@synthesize threadMessage;
@synthesize pageSize;

-(void) dealloc{
    [threadMessage release];
    [pageSize release];
    [super dealloc];
}

@end
