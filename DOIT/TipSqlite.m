//
//  TipSqlite.m
//  DOIT
//
//  Created by AppDev on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TipSqlite.h"

@implementation TipSqlite
@synthesize tipID;
@synthesize tid;
@synthesize title;
@synthesize bkid;


-(void)dealloc{
    [self.tid release];
    [self.title release];
    [self.bkid release];
    [super dealloc];
}

@end
