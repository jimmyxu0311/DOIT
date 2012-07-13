//
//  CommendService.m
//  DOIT
//
//  Created by AppDev on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommendService.h"
#import "Commend.h"
//#import "SZJsonParser.h"
#import "DOITUtil.h"
#import "JSON.h"

@implementation CommendService


+(NSMutableArray*) getCommendArray:(NSURL*)url{
    NSMutableArray* commentArray = [[[NSMutableArray alloc] init] autorelease];
    NSString* jsonData = [DOITUtil getRequestJsonData:url];
    if (jsonData != nil) {
        NSArray* jsonArray = [jsonData JSONValue];
        if ([jsonArray count] > 0) {
            int i;
            for (i = 0; i < [jsonArray count]; i++) {
                Commend* commend = [[Commend alloc] init];
                commend.content = [[jsonArray objectAtIndex:i] objectForKey:@"content"];
                commend.pubtime = [[jsonArray objectAtIndex:i] objectForKey:@"pubtime"];
                commend.commendID = [[jsonArray objectAtIndex:i] objectForKey:@"id"];
                commend.guestname = [[jsonArray objectAtIndex:i] objectForKey:@"guestname"];
                [commentArray addObject:commend];
                [commend release];
            }
        }
    }
    return commentArray;
}

@end
