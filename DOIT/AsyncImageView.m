//
//  AsyncImageView.m
//  DOIT
//
//  Created by AppDev on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"
#import "UIImage+CustomUIImage.h"

@implementation AsyncImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadImageFormURL:(NSURL *)url{
    if (nil != connection) {
        [connection release];
    }
    if (nil != data) {
        [data release];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection*)theConnection didReceiveData:(NSData *)incrementalData{
    if (nil == data) {
        data = [[NSMutableData alloc] initWithLength:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection{
    [connection release];
    connection = nil;
    if ([[self subviews] count] > 0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    UIImage *image = [UIImage imageWithData:data];
    UIImage * topImage = [image scaleToSize:CGSizeMake(80.0, 60.0)];
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:topImage] autorelease];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout];
    [self setNeedsLayout];
    [data release];
    data = nil;
}

- (UIImage*)image{
    UIImageView* iv = [[self subviews] objectAtIndex:0];
    return [iv image];
}

- (void)dealloc{
    [connection cancel];
    [connection release];
    [data release];
    [super dealloc];
}

@end
