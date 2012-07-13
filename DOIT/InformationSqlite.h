//
//  InformationSqlite.h
//  DOIT
//
//  Created by AppDev on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationSqlite : NSObject{
    int informationID;
    NSString* articleID;
    NSString* title;
    NSString* summary;
    NSString* siteid;
    NSString* pictrue;
}

@property int informationID;
@property(nonatomic, retain) NSString* articleID;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSString* summary;
@property(nonatomic, retain) NSString* siteid;
@property(nonatomic, retain) NSString* pictrue;

@end
