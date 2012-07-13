//
//  MobileInfo.m
//  DOIT
//
//  Created by AppDev on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MobileInfo.h"

@implementation MobileInfo
@synthesize userIPAddress;
@synthesize userMacAddress;
@synthesize isLoadImg;
static MobileInfo* myMobile = nil;

+(MobileInfo*)shareInstance{
    if (myMobile == nil) {
        myMobile = [[self alloc] init];
    }
    return myMobile;
}

-(void)dealloc{
    [self.userIPAddress release];
    [self.userMacAddress release];
    [super dealloc];
}

@end
