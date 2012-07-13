//
//  ClubMain.m
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Club.h"

@implementation Club
@synthesize clubID;
@synthesize bkid;
@synthesize bname;

-(void)dealloc{
    [clubID release];
    [bkid release];
    [bname release];
    [super dealloc];
}

@end
