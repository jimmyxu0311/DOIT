//
//  Commend.h
//  DOIT
//
//  Created by AppDev on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commend : NSObject{
    NSString* _content;
    NSString* _pubtime;
    NSString* _commendID;
    NSString* _guestname;
}

@property(nonatomic, retain) NSString* content;
@property(nonatomic, retain) NSString* pubtime;
@property(nonatomic, retain) NSString* commendID;
@property(nonatomic, retain) NSString* guestname;

@end
