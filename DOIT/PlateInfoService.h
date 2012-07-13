//
//  PlateInfoService.h
//  DOIT
//
//  Created by AppDev on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlateInfo.h"

@interface PlateInfoService : NSObject

+(PlateInfo*) getPlateInfo:(NSURL*)url;

@end
