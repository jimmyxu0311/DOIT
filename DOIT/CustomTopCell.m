//
//  CustomTopCell.m
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomTopCell.h"
#import "Article.h"

@implementation CustomTopCell
@synthesize myScrollView;
@synthesize myPageControl;
@synthesize titleLabel;
@synthesize imageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= 5)
        return;
    //Article* article = [articleArray objectAtIndex:page];
    //self.titleLabel.text = article.title;
    
    //imageView = [[UIImageView alloc] init];
    
    /*CGRect frame = myScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    imageView.frame = frame;
    [myScrollView addSubview:imageView];*/
    //[NSThread detachNewThreadSelector:@selector(downLoadImage:) toTarget:self withObject:article.picture];
}

-(void) downLoadImage:(NSString*)urlString{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSURL* url = [NSURL URLWithString:urlString];
    NSData* data = [NSData dataWithContentsOfURL:url];
    UIImage* image = [UIImage imageWithData:data];
    [imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    [pool release];

}


-(void)setCell:(NSArray*)topArticleArray{
    /*
    articleArray = topArticleArray;

    myScrollView.pagingEnabled = YES;

    myPageControl.currentPage = 0;
    
    [self loadScrollViewWithPage:0];
    //[self loadScrollViewWithPage:1];*/
    
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = myScrollView.frame.size.width;
    int page = floor((myScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    myPageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}



- (IBAction)changePage:(id)sender
{
    int page = myPageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = myScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [myScrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


-(void) dealloc{
    [self.imageView release];
    [self.myScrollView release];
    [self.myPageControl release];
    [self.titleLabel release];
    [super dealloc];
}
@end
