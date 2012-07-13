//
//  Tip.h
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tip : NSObject{
    NSString* author;
    NSString* tid;
    NSString* replies;
    NSString* dateline;
    NSString* views;
    NSString* subejct;
    NSString* digest;
    NSString* attachment;
}

@property(nonatomic, retain) NSString* author;
@property(nonatomic, retain) NSString* tid;
@property(nonatomic, retain) NSString* replies;
@property(nonatomic, retain) NSString* dateline;
@property(nonatomic, retain) NSString* views;
@property(nonatomic, retain) NSString* subejct;
@property(nonatomic, retain) NSString* digest;
@property(nonatomic, retain) NSString* attachment;

@end
