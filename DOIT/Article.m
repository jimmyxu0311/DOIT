//
//  Article.m
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Article.h"

@implementation Article

@synthesize articleID;
@synthesize title;
@synthesize picture;
@synthesize summary;
@synthesize siteid;
@synthesize articleType;
@synthesize pictrue;

-(void)dealloc{
    [articleID release];
    [title release];
    [picture release];
    [summary release];
    [siteid release];
    [articleType release];
    [pictrue release];
    [super dealloc];
}

@end
