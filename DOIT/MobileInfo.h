//
//  MobileInfo.h
//  DOIT
//
//  Created by AppDev on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileInfo : NSObject{
    NSString* userIPAddress;
    NSString* userMacAddress;
    BOOL isLoadImg;
}

@property(nonatomic, retain) NSString* userIPAddress;
@property(nonatomic, retain) NSString* userMacAddress;
@property BOOL isLoadImg;

+(MobileInfo*)shareInstance;

@end
