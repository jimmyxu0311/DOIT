//
//  UIImage+CustomUIImage.m
//  DOIT
//
//  Created by AppDev on 11-12-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+CustomUIImage.h"

@implementation UIImage (CustomUIImage)

-(UIImage*)scaleToSize:(CGSize)size{
    //创建一个bitmap的context,并把它设置成当前正在使用的context
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    //使用当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的图片
    return scaledImage;
}

@end
