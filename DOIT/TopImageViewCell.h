//
//  TopImageViewCell.h
//  DOIT
//
//  Created by AppDev on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePhotosDataSource.h"

@interface TopImageViewCell : UITableViewCell<UIScrollViewDelegate,PagePhotosDataSource>{
    NSArray* _array;
}

-(void) setCell:(NSArray*)array;

-(int) getIndex;

@end
