//
//  Article.h
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject{
    NSString* articleID;
    NSString* title;
    NSString* picture;
    NSString* summary;
    NSString* siteid;
    NSString* articleType;
    NSString* pictrue;
}

@property(nonatomic, retain) NSString* articleID;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSString* picture;
@property(nonatomic, retain) NSString* summary;
@property(nonatomic, retain) NSString* siteid;
@property(nonatomic, retain) NSString* articleType;
@property(nonatomic, retain) NSString* pictrue;

@end
