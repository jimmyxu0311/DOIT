//
//  UserInfo.m
//  DOIT
//
//  Created by AppDev on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize faxnumber;
@synthesize gender;
@synthesize address;
@synthesize province;
@synthesize industrytype;
@synthesize department;
@synthesize idnumber;
@synthesize result;
@synthesize postcode;
@synthesize celnumber;
@synthesize realname;
@synthesize jposition;
@synthesize username;
@synthesize email;
@synthesize copyname;
@synthesize city;
@synthesize telnumber;
@synthesize birthday;
@synthesize headerimg;
@synthesize password;

static UserInfo* myUserInfo = nil;

+(UserInfo*)sharedInstance{
    if (myUserInfo == nil) {
        myUserInfo = [[self alloc] init];
    }
    return myUserInfo;
}

-(void)dealloc{
    [self.faxnumber release];
    [self.gender release];
    [self.address release];
    [self.province release];
    [self.industrytype release];
    [self.department release];
    [self.idnumber release];
    [self.result release];
    [self.postcode release];
    [self.celnumber release];
    [self.realname release];
    [self.jposition release];
    [self.username release];
    [self.email release];
    [self.copyname release];
    [self.city release];
    [self.telnumber release];
    [self.birthday release];
    [self.headerimg release];
    [self.password release];
    [super dealloc];
}

@end
