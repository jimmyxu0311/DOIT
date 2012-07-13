//
//  ImageDownloader.m
//  NSOperationTest
//
//  Created by jhwang on 11-10-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageDownloader.h"
#import "UIImage+CustomUIImage.h"


@implementation ImageDownloader
@synthesize delegate;
@synthesize delPara;
@synthesize data;

- (void)startDownLoaderImage:(NSString *)url{
    if (nil == url) {
        return;
    }
    if (nil != connection) {
        [connection release];
    }
    if (nil != data) {
        [data release];
    }
    data = [[NSMutableData data] retain];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection*)theConnection didReceiveData:(NSData *)incrementalData{
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection{
    [connection release];
    connection = nil;
    UIImage *image = [UIImage imageWithData:data];
    UIImage *topImage = [image scaleToSize:CGSizeMake(80.0, 60.0)];
    if (self.delegate) {
        [delegate imageDidFinished:topImage para:self.delPara];
    }
}

-(void)connection: (NSURLConnection *) _connection didFailWithError: (NSError *) error
{
    [connection release];
    connection=nil; 
}

- (void)dealloc 
{
    [connection cancel];
    [connection release];
    [data release];
    [delPara release];
    [super dealloc];
    
}

@end
