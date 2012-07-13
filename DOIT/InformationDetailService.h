//
//  InformationDetailService.h
//  DOIT
//
//  Created by AppDev on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InformationDetail.h"

@interface InformationDetailService : NSObject

+(InformationDetail*) getArticleContentArray:(NSURL*)url;

@end
