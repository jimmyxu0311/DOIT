//
//  TipService.m
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TipService.h"
#import "DOITUtil.h"
//#import "SZJsonParser.h"
#import "JSON.h"
#import "Tip.h"

@implementation TipService


+(NSMutableArray*) getTipArray:(NSURL*)url{
    NSMutableArray* tipArray = [[[NSMutableArray alloc] init] autorelease];
    NSString* jsonData = [DOITUtil getRequestJsonData:url];
    if (jsonData != nil) {
        NSArray* jsonArray = [jsonData JSONValue];
        if ([jsonArray count] > 0) {
            int i;
            for (i = 0; i < [jsonArray count]; i++) {
                Tip* tip = [[Tip alloc] init];
                tip.author = [[jsonArray objectAtIndex:i] objectForKey:@"author"];
                tip.tid = [[jsonArray objectAtIndex:i] objectForKey:@"tid"];
                tip.replies = [[jsonArray objectAtIndex:i] objectForKey:@"replies"];
                tip.dateline = [[jsonArray objectAtIndex:i] objectForKey:@"dateline"];
                tip.views = [[jsonArray objectAtIndex:i] objectForKey:@"views"];
                tip.subejct = [[jsonArray objectAtIndex:i] objectForKey:@"subejct"];
                tip.digest = [[jsonArray objectAtIndex:i] objectForKey:@"digest"];
                tip.attachment = [[jsonArray objectAtIndex:i] objectForKey:@"attachment"];
                [tipArray addObject:tip];
                [tip release];
            }
        }
    }
    
    return tipArray;
}

@end
