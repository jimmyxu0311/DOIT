//
//  InformationDetail.h
//  DOITIOS
//
//  Created by AppDev on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationDetail : NSObject{
    NSString* commentNum;
    NSString* content;
    NSString* pageSize;
    NSString* url;
    NSString* title;
    NSString* summary;
    NSString* siteID;
}

@property(nonatomic, retain) NSString* commentNum;
@property(nonatomic, retain) NSString* content;
@property(nonatomic, retain) NSString* pageSize;
@property(nonatomic, retain) NSString* url;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSString* summary;
@property(nonatomic, retain) NSString* siteID;

@end
