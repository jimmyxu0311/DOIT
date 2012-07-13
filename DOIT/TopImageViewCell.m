//
//  TopImageViewCell.m
//  DOIT
//
//  Created by AppDev on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TopImageViewCell.h"
#import "Article.h"
#import "PagePhotosView.h"
#import "UIImage+CustomUIImage.h"
#import "AppDelegate.h"
#import "GTMBase64.h"

@implementation TopImageViewCell

static int indexPage;

-(void) loadImage:(NSArray*) imgArr{
    PagePhotosView *pagePhotosView = [[PagePhotosView alloc] initWithFrame: CGRectMake(0, 0, 320, 170) withDataSource: self array:imgArr];
    [self addSubview:pagePhotosView];
    [pagePhotosView release];
}

-(void) setCell:(NSArray*)array{
    _array = [array copy];
    
    //[NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:_array];
    PagePhotosView *pagePhotosView = [[PagePhotosView alloc] initWithFrame: CGRectMake(0, 0, 320, 170) withDataSource: self array:_array];
    [_array release];
    [self addSubview:pagePhotosView];
    
    [pagePhotosView release];
}



// 有多少页
//
- (int)numberOfPages {
	return [_array count];
}

// 每页的图片
- (UIImage *)imageAtIndex:(int)index {
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] getCurrntNet]==nil) {
        indexPage = index;
        Article* article = [_array objectAtIndex:index];
        NSString* picURL = article.pictrue;
        UIImage* image = [UIImage imageWithData:[GTMBase64 decodeString:picURL]];
        UIImage* topImage = [image scaleToSize:CGSizeMake(640.0, 340.0)];
        return topImage;
    }
    indexPage = index;
    Article* article = [_array objectAtIndex:index];
    NSString* picURL = article.picture;
    NSURL* url = [NSURL URLWithString:picURL];
    NSData* data = [NSData dataWithContentsOfURL:url];
    UIImage* image = [UIImage imageWithData:data];
    UIImage* topImage = [image scaleToSize:CGSizeMake(640.0, 340.0)];
    return topImage;
}

// 每页的标题
-(NSString*)titleAtIndex:(int)index{
    indexPage=index;
    Article* article = [_array objectAtIndex:index];
    return article.title;
}

//每页的创作类型
-(int)articleType:(int)index{
    indexPage=index;
    Article* article = [_array objectAtIndex:index];
    return [article.articleType intValue];
}

-(int) getIndex{
    return indexPage;
}

@end
