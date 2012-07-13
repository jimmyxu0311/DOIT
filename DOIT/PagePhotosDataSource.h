//
//  PagePhotosDataSource.h
//  PagePhotosDemo
//
//  Created by Andy soonest on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PagePhotosDataSource

// 有多少页
//
- (int)numberOfPages;

// 每页的图片
//
- (UIImage *)imageAtIndex:(int)index;

// 每页的标题
//
-(NSString*)titleAtIndex:(int)index;

// 每页的创作类型
//
-(int)articleType:(int)index;

@end
