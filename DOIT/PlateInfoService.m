//
//  PlateInfoService.m
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlateInfoService.h"
#import "DOITUtil.h"
//#import "SZJsonParser.h"
#import "JSON.h"

@implementation PlateInfoService

+(PlateInfo*) getPlateInfo:(NSURL*)url{
    PlateInfo* plateInfo = [[[PlateInfo alloc] init] autorelease];
    NSString* jsonData = [DOITUtil getRequestJsonData:url];
    if (jsonData != nil) {
        NSDictionary* jsonDictionary = [jsonData JSONValue];
        if (jsonDictionary != nil) {
            plateInfo.threads = [jsonDictionary objectForKey:@"threads"];
            plateInfo.rowCount = [jsonDictionary objectForKey:@"rowCount"];
            plateInfo.description = [jsonDictionary objectForKey:@"description"];
            plateInfo.pageSize = [jsonDictionary objectForKey:@"pageSize"];
            plateInfo.posts = [jsonDictionary objectForKey:@"posts"];
            plateInfo.moderators = [jsonDictionary objectForKey:@"moderators"];
            plateInfo.pageNum = [jsonDictionary objectForKey:@"pageNum"];
            plateInfo.name = [jsonDictionary objectForKey:@"name"];
        }
    }
    
    return plateInfo;
}

@end
