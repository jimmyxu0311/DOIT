//
//  TipSqlite.h
//  DOIT
//
//  Created by AppDev on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TipSqlite : NSObject{
    int tipID;
    NSString* tid;
    NSString* title;
    NSString* bkid;
}

@property int tipID;
@property(nonatomic, retain)  NSString* tid;
@property(nonatomic, retain)  NSString* title;
@property(nonatomic, retain)  NSString* bkid;

@end
