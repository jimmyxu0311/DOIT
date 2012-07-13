//
//  PagePhotosView.h
//  PagePhotosDemo
//
//  Created by Andy soonest on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePhotosDataSource.h"
#import "AppDelegate.h"

@interface PagePhotosView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;
	UIPageControl *pageControl;
	
	id<PagePhotosDataSource> dataSource;
	NSMutableArray *imageViews;
    
    NSArray* array;
    int pageTest;
	UILabel *lbltitle;
    UIImageView *imgV;
	// To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
    AppDelegate *appDelegate;
    
    NSTimer *timer;
}

@property (nonatomic, assign) id<PagePhotosDataSource> dataSource;
@property (nonatomic, retain) NSMutableArray *imageViews;

-(void)timerstart;

- (IBAction)changePage:(id)sender;

- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)_dataSource array:(NSArray*)_array;

@end
