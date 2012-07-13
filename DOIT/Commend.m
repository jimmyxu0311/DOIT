//
//  Commend.m
//  DOIT
//
//  Created by AppDev on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Commend.h"

@implementation Commend
@synthesize content = _content;
@synthesize pubtime = _pubtime;
@synthesize commendID = _commendID;
@synthesize guestname = _guestname;

-(void) dealloc{
    [self.commendID release];
    [self.pubtime release];
    [self.commendID release];
    [self.guestname release];
    [super dealloc];
}


@end
