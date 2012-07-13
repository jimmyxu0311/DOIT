//
//  ArticleService.h
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleService : NSObject

+(NSMutableArray*) getArticleArray:(NSURL*)url;
@end
