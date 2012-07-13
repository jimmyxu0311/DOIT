//
//  ArticleService.m
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ArticleService.h"
#import "DOITUtil.h"
#import "Article.h"
//#import "SZJsonParser.h"
#import "JSON.h"

@implementation ArticleService

+(NSMutableArray*) getArticleArray:(NSURL*)url{
    NSMutableArray* articleArray = [[[NSMutableArray alloc] init] autorelease];
    NSString* jsonData = [DOITUtil getRequestJsonData:url];
    NSArray* jsonArray = nil;
    if (jsonData != nil) {
        jsonArray = [jsonData JSONValue];
    }
    if ([jsonArray count] > 0) {
        int i;
        for ( i = 0; i < [jsonArray count]; i++) {
            Article* article = [[Article alloc] init];
            article.articleID = [[jsonArray objectAtIndex:i] objectForKey:@"id"];
            article.title = [[jsonArray objectAtIndex:i] objectForKey:@"title"];
            article.picture = [[jsonArray objectAtIndex:i] objectForKey:@"picture"];
            article.summary = [[jsonArray objectAtIndex:i] objectForKey:@"summary"];
            article.siteid = [[jsonArray objectAtIndex:i] objectForKey:@"siteid"];
            article.articleType=[[jsonArray objectAtIndex:i] objectForKey:@"articletype"];
            [articleArray addObject:article];
            [article release];
        }
    }
    return articleArray;
}

@end
