//
//  ClubMain.h
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Club : NSObject{
    NSString* clubID;
    NSString* bkid;
    NSString* bname;
}

@property(nonatomic, retain) NSString* clubID;
@property(nonatomic, retain) NSString* bkid;
@property(nonatomic, retain) NSString* bname;

@end
