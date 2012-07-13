//
//  UISegmentedControl+CustomTintExtension.m
//  UISegmentedControlDemo
//
//  Created by AppDev on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UISegmentedControl+CustomTintExtension.h"

@implementation UISegmentedControl (CustomTintExtension)

-(void)setTag:(NSInteger)tag forSegmentAtIndex:(NSInteger)segment{
    [[[self subviews] objectAtIndex:segment] setTag:tag];
}
-(void)setTintColor:(UIColor*)color forTag:(NSInteger)aTag{
    UIView* segment = [self viewWithTag:aTag];
    SEL tint = @selector(setTintColor:);
    if (segment && ([segment respondsToSelector:tint])) {
        [segment performSelector:tint withObject:color];
    }
}
-(void)setTextColor:(UIColor*)color forTag:(NSInteger)aTag{
    UIView* segment = [self viewWithTag:aTag];
    for (UIView* view in segment.subviews) {
        SEL text = @selector(setTextColor:);
        if (view && ([view respondsToSelector:text])) {
            [view performSelector:text withObject:color];
        }
    }
}
-(void)setShadowColor:(UIColor*)color forTag:(NSInteger)aTag{
    UIView* segment = [self viewWithTag:aTag];
    for (UIView* view in segment.subviews) {
        SEL shadowColor = @selector(setShadowColor:);
        if (view && ([view respondsToSelector:shadowColor])) {
            [view performSelector:shadowColor withObject:color];
        }
    }
}

@end
