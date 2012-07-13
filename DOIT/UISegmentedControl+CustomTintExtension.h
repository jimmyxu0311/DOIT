//
//  UISegmentedControl+CustomTintExtension.h
//  UISegmentedControlDemo
//
//  Created by AppDev on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (CustomTintExtension)

-(void)setTag:(NSInteger)tag forSegmentAtIndex:(NSInteger)segment;
-(void)setTintColor:(UIColor*)color forTag:(NSInteger)aTag;
-(void)setTextColor:(UIColor*)color forTag:(NSInteger)aTag;
-(void)setShadowColor:(UIColor*)color forTag:(NSInteger)aTag;

@end
