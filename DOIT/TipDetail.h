//
//  TipDetail.h
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TipDetail : NSObject{
    NSString* threadMessage;
    NSString* pageSize;
}

@property(nonatomic, retain) NSString* threadMessage;
@property(nonatomic, retain) NSString* pageSize;

@end
