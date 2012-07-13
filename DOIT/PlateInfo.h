//
//  PlateInfo.h
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlateInfo : NSObject{
    NSString* threads;
    NSString* rowCount;
    NSString* description;
    NSString* pageSize;
    NSString* posts;
    NSString* moderators;
    NSString* pageNum;
    NSString* name;
}

@property(nonatomic, retain) NSString* threads;
@property(nonatomic, retain) NSString* rowCount;
@property(nonatomic, retain) NSString* description;
@property(nonatomic, retain) NSString* pageSize;
@property(nonatomic, retain) NSString* posts;
@property(nonatomic, retain) NSString* moderators;
@property(nonatomic, retain) NSString* pageNum;
@property(nonatomic, retain) NSString* name;

@end
