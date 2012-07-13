//
//  ImageDownloader.h
//  NSOperationTest
//
//  Created by jhwang on 11-10-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol imageDownloaderDelegate

@optional
//图片下载完成的委托
- (void)imageDidFinished:(UIImage *)image para:(NSObject *)obj;
@end

@interface ImageDownloader : NSObject 
{
    NSURLConnection *connection;
    NSMutableData* data;
    id<imageDownloaderDelegate> delegate;
    NSObject *delPara;
}

@property(nonatomic, assign) id<imageDownloaderDelegate> delegate;
@property(nonatomic, retain) NSObject *delPara;
@property(readonly) NSMutableData *data;

- (void)startDownLoaderImage:(NSString*)url;


@end

