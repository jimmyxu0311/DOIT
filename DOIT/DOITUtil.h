//
//  DOITUtil.h
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOITUtil : NSObject

+(NSString*) getUrlBase;

+(NSString*) getRequestJsonData:(NSURL*)requestUrl;

+(NSString*) encodeBase64:(UIImage*)image;

+(NSString*) encodeStrBase64:(NSString*)String;

+(NSString*) deviceIPAddress;

+(NSString*) deviceMACAddress;

+(NSString*) deviceID;

@end
