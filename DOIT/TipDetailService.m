//
//  TipDetailService.m
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TipDetailService.h"
#import "DOITUtil.h"
//#import "SZJsonParser.h"
#import "JSON.h"

@implementation TipDetailService

+(TipDetail*) getTipDetail:(NSURL*)url{
    TipDetail* tipDetail = [[[TipDetail alloc] init] autorelease];
    NSString* jsonData = [DOITUtil getRequestJsonData:url];
    if (jsonData != nil) {
        NSDictionary* jsonDictionary = [jsonData JSONValue];
        if (jsonDictionary != nil) {
            tipDetail.threadMessage = [jsonDictionary objectForKey:@"threadMessage"];
            tipDetail.pageSize = [jsonDictionary objectForKey:@"pageSize"];
        }
    }
    return  tipDetail;
}

@end
