//
//  PagePhotosView.m
//  PagePhotosDemo
//
//  Created by Andy soonest on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PagePhotosView.h"
#import "Article.h"
#import "InformationDetailView.h"
#import "MobileInfo.h"

@interface PagePhotosView (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation PagePhotosView
@synthesize dataSource;
@synthesize imageViews;

-(void)setImgV:(int)type{
    switch (type) {
        case 1:
            imgV.image=[UIImage imageNamed:@"yuanchuang.png"];
            break;
            
        default:
            break;
    }
}

- (id)initWithFrame:(CGRect)frame withDataSource:(id<PagePhotosDataSource>)_dataSource array:(NSArray*)_array{
    if ((self = [super initWithFrame:frame])) {
        array = [_array copy];
        
        appDelegate = 
        (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
		self.dataSource = _dataSource;
        // Initialization UIScrollView
		int pageControlHeight = 20;
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 170)];
        
        UIView *backlbl=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - pageControlHeight-10, frame.size.width, pageControlHeight+10)];
        [backlbl setBackgroundColor:[UIColor blackColor]];
        [backlbl setAlpha:0.6];
        lbltitle=[[UILabel alloc] initWithFrame:CGRectMake(pageControlHeight, frame.size.height - pageControlHeight-5, 300, pageControlHeight)];
        [lbltitle setBackgroundColor:[UIColor clearColor]];
        lbltitle.textColor=[UIColor whiteColor];
        [lbltitle setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:15]];
        lbltitle.text=[dataSource titleAtIndex:0];
        
        imgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - pageControlHeight-5, pageControlHeight, pageControlHeight)];
        [self setImgV:[dataSource articleType:0]];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(120, frame.size.height - pageControlHeight-5, frame.size.width, pageControlHeight)];
		
		[self addSubview:scrollView];
        [self addSubview:backlbl];
        [self addSubview:lbltitle];
        [lbltitle release];
        [self addSubview:imgV];
        [imgV release];
		[self addSubview:pageControl];
		
		int kNumberOfPages = [dataSource numberOfPages];
		
		// in the meantime, load the array with placeholders which will be replaced on demand
		NSMutableArray *views = [[NSMutableArray alloc] init];
		for (unsigned i = 0; i < kNumberOfPages; i++) {
			[views addObject:[NSNull null]];
		}
		self.imageViews = views;
		[views release];
		
		// a page is the width of the scroll view
		scrollView.pagingEnabled = YES;
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		scrollView.delegate = self;
		
		pageControl.numberOfPages = kNumberOfPages;
		pageControl.currentPage = 0;
		pageControl.backgroundColor = [UIColor clearColor];
        pageControl.alpha = 0.7;
		[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
		// pages are created on demand
		// load the visible page
		// load the page on either side to avoid flashes when the user starts scrolling
		[self loadScrollViewWithPage:0];
		[self loadScrollViewWithPage:1];
        [self loadScrollViewWithPage:2];
		[self timerstart];
    
    }
    return self;
}

-(void)timerstart{
    timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(pageChangeAlone) userInfo:nil repeats:YES];
}

-(void)pageChangeAlone{
    pageControl.currentPage+=1;
    if (pageControl.currentPage==[dataSource numberOfPages]-1) {
        pageControl.currentPage=0;
    }
    [self loadScrollViewWithPage:pageControl.currentPage - 1];
    [self loadScrollViewWithPage:pageControl.currentPage];
    [self loadScrollViewWithPage:pageControl.currentPage + 1];
    lbltitle.text=[dataSource titleAtIndex:pageControl.currentPage];
    [self setImgV:[dataSource articleType:pageControl.currentPage]];
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

- (void)loadScrollViewWithPage:(int)page {
	int kNumberOfPages = [dataSource numberOfPages];
    pageTest = page;
	
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
    // replace the placeholder if necessary
    //UIImageView *view = [imageViews objectAtIndex:page];
    UIButton* view = [imageViews objectAtIndex:page];
    if ((NSNull *)view == [NSNull null]) {
		UIImage *image = [dataSource imageAtIndex:page];
        //view = [[UIImageView alloc] initWithImage:image];
        view = [[UIButton alloc] init];
        [view setBackgroundImage:image forState:UIControlStateNormal];
        [view addTarget:self action:@selector(readArticle:) forControlEvents:UIControlEventTouchUpInside];
        [imageViews replaceObjectAtIndex:page withObject:view];
		[view release];
    }
	
    // add the controller's view to the scroll view
    if (nil == view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        view.frame = frame;
        [scrollView addSubview:view];
    }
}

-(void)readArticle:(id)sender{
    InformationDetailView* informationDetailView = [[InformationDetailView alloc] initWithNibName:@"InformationDetailView" bundle:nil];
    informationDetailView.userip = [MobileInfo shareInstance].userIPAddress;
    informationDetailView.sortText = @"头条";
    informationDetailView.currentArray = array;
    informationDetailView.currentIndex = pageTest - 1;
    [appDelegate.navigationController pushViewController:informationDetailView animated:YES];
    [informationDetailView release];

}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (pageControlUsed) {
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    lbltitle.text=[dataSource titleAtIndex:page];
    [self setImgV:[dataSource articleType:page]];
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    lbltitle.text=[dataSource titleAtIndex:page];
    [self setImgV:[dataSource articleType:page]];
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


- (void)dealloc {
    if (array != nil) {
        [array release];
    }
	[scrollView release];
	[pageControl release];
    [super dealloc];
}


@end
