//
//  ClubService.m
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ClubService.h"
#import "DOITUtil.h"
//#import "SZJsonParser.h"
#import "JSON.h"
#import "Club.h"

@implementation ClubService

+(NSMutableArray*) getClubArray:(NSURL*)url{
    NSMutableArray* clubArray = [[[NSMutableArray alloc] init] autorelease];
    NSString* jsonData = [DOITUtil getRequestJsonData:url];
    if (jsonData != nil) {
        NSArray* jsonArray = [jsonData JSONValue];
        if ([jsonArray count] > 0) {
            int i ;
            for ( i = 0; i < [jsonArray count]; i++) {
                Club* club = [[Club alloc] init];
                club.clubID = [[jsonArray objectAtIndex:i] objectForKey:@"id"];
                club.bkid = [[jsonArray objectAtIndex:i] objectForKey:@"bkid"];
                club.bname = [[jsonArray objectAtIndex:i] objectForKey:@"bname"];
                [clubArray addObject:club];
                [club release];
            }
        }
    }
    return clubArray;
}

+(NSMutableArray*) getAllClubArray:(NSURL*)url{
    NSMutableArray *dicClub = [[[NSMutableArray alloc] init] autorelease];
    NSString* jsonData = [DOITUtil getRequestJsonData:url];
    if (jsonData != nil) {
        NSArray* jsonArray = [jsonData JSONValue];
        if ([jsonArray count] > 0) {
            for (int i = 0; i < [jsonArray count]; i++) {
                NSMutableArray *clubArr=[[NSMutableArray alloc] init];
                for (int j=0; j<[[[jsonArray objectAtIndex:i] objectForKey:@"abkObj"] count]; j++) {
                    Club* club = [[Club alloc] init];
                    club.clubID = [[[[jsonArray objectAtIndex:i] objectForKey:@"abkObj"] objectAtIndex:j] objectForKey:@"id"];
                    club.bkid = [[[[jsonArray objectAtIndex:i] objectForKey:@"abkObj"] objectAtIndex:j] objectForKey:@"bkid"];
                    club.bname = [[[[jsonArray objectAtIndex:i] objectForKey:@"abkObj"] objectAtIndex:j] objectForKey:@"bname"];
                    [clubArr addObject:club];
                    [club release];
                }
                
                [dicClub addObject:[NSArray arrayWithObjects:clubArr,[[jsonArray objectAtIndex:i] objectForKey:@"bname"], nil]];
                [clubArr release];
            }
        }
    }
    return dicClub;
}

@end
