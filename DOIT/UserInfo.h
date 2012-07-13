//
//  UserInfo.h
//  DOIT
//
//  Created by AppDev on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject{
    NSString* faxnumber;
    NSString* gender;
    NSString* address;
    NSString* province;
    NSString* industrytype;
    NSString* department;
    NSString* idnumber;
    NSString* result;
    NSString* postcode;
    NSString* celnumber;
    NSString* realname;
    NSString* jposition;
    NSString* username;
    NSString* email;
    NSString* copyname;
    NSString* city;
    NSString* telnumber;
    NSString* birthday;
    NSString* headerimg;
    NSString* password;
}

@property(nonatomic, retain) NSString* faxnumber;
@property(nonatomic, retain) NSString* gender;
@property(nonatomic, retain) NSString* address;
@property(nonatomic, retain) NSString* province;
@property(nonatomic, retain) NSString* industrytype;
@property(nonatomic, retain) NSString* department;
@property(nonatomic, retain) NSString* idnumber;
@property(nonatomic, retain) NSString* result;
@property(nonatomic, retain) NSString* postcode;
@property(nonatomic, retain) NSString* celnumber;
@property(nonatomic, retain) NSString* realname;
@property(nonatomic, retain) NSString* jposition;
@property(nonatomic, retain) NSString* username;
@property(nonatomic, retain) NSString* email;
@property(nonatomic, retain) NSString* copyname;
@property(nonatomic, retain) NSString* city;
@property(nonatomic, retain) NSString* telnumber;
@property(nonatomic, retain) NSString* birthday;
@property(nonatomic, retain) NSString* headerimg;
@property(nonatomic, retain) NSString* password;


+(UserInfo*)sharedInstance;

@end
