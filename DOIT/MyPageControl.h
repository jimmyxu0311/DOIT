//
//  MyPageControl.h
//  手机DOIT
//
//  Created by AppDev on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageControl : UIPageControl{
    UIImage* imagePageStateNormal;
    UIImage* imagePageStateHighlighted;
}

-(id)initWithFrame:(CGRect)frame;
@property(nonatomic, retain)UIImage* imagePageStateNormal;
@property(nonatomic, retain)UIImage* imagePageStateHighlighted;

@end
