//
//  AsyncImageView.h
//  DOIT
//
//  Created by AppDev on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncImageView : UIView{
    NSURLConnection *connection;
    NSMutableData* data;
}

- (void)loadImageFormURL:(NSURL*)url;

@end
