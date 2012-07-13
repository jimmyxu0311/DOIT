//
//  InformationDetailService.m
//  DOIT
//
//  Created by AppDev on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "InformationDetailService.h"
#import "DOITUtil.h"
//#import "SZJsonParser.h"
#import "JSON.h"

@implementation InformationDetailService


+(InformationDetail*) getArticleContentArray:(NSURL*)url{
    InformationDetail* information = [[[InformationDetail alloc] init] autorelease];
    NSString* jsonData = [DOITUtil getRequestJsonData:url];
    if (jsonData != nil) {
        NSDictionary* dictionary = [jsonData JSONValue];
        if (dictionary != nil) {
            information.commentNum = [dictionary objectForKey:@"commentNum"];
            information.content = [dictionary objectForKey:@"content"];
            information.pageSize = [dictionary objectForKey:@"pageSize"];
            information.url = [dictionary objectForKey:@"url"];
            information.title = [dictionary objectForKey:@"title"];
            information.summary = [dictionary objectForKey:@"summary"];
            information.siteID = [dictionary objectForKey:@"siteid"];
        }
    }
    return information;
}

@end
