//
//  InformationSqlite.m
//  DOIT
//
//  Created by AppDev on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "InformationSqlite.h"

@implementation InformationSqlite
@synthesize informationID;
@synthesize articleID;
@synthesize title;
@synthesize summary;
@synthesize siteid;
@synthesize pictrue;


-(void) dealloc{
    [self.articleID release];
    [self.title release];
    [self.summary release];
    [self.siteid release];
    [self.pictrue release];
    [super dealloc];
}

@end
