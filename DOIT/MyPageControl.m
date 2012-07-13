//
//  MyPageControl.m
//  手机DOIT
//
//  Created by AppDev on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyPageControl.h"
@interface MyPageControl(private)
-(void)updateDots;
@end;

@implementation MyPageControl
@synthesize imagePageStateNormal;
@synthesize imagePageStateHighlighted;

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    return self;
}

-(void)setImagePageStateNormal:(UIImage *)image{
    [imagePageStateNormal release];
    imagePageStateNormal = [image retain];
    [self updateDots];
}

-(void)setImagePageStateHighlighted:(UIImage *)image{
    [imagePageStateHighlighted release];
    imagePageStateHighlighted = [image retain];
    [self updateDots];
}


-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

-(void)updateDots{
    if (imagePageStateNormal||imagePageStateHighlighted) {
        NSArray* subView = self.subviews;
        for (NSInteger i = 0; i < [subView count]; i++) {
            UIImageView* dot = [subView objectAtIndex:i];
            dot.image = self.currentPage == i ?imagePageStateNormal:imagePageStateHighlighted;
        }
    }
}

-(void)dealloc{
    [imagePageStateNormal release],imagePageStateNormal = nil;
    [imagePageStateHighlighted release],imagePageStateHighlighted = nil;
    [super dealloc];
}
@end
