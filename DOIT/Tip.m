//
//  Tip.m
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Tip.h"

@implementation Tip
@synthesize author;
@synthesize tid;
@synthesize replies;
@synthesize dateline;
@synthesize views;
@synthesize subejct;
@synthesize digest;
@synthesize attachment;

-(void)dealloc{
    [self.author release];
    [self.tid release];
    [self.replies release];
    [self.dateline release];
    [self.views release];
    [self.subejct release];
    [self.digest release];
    [self.attachment release];
    [super dealloc];
}

@end
