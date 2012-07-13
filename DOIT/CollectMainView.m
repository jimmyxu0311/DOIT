//
//  CollectMainView.m
//  DOIT
//
//  Created by AppDev on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CollectMainView.h"
#import "ArticleListView.h"
#import "TipListView.h"

@implementation CollectMainView
@synthesize contentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)createSegment
{
    
    NSArray* segmentArray = [NSArray arrayWithObjects:@"新闻",@"帖子", nil];
    
    UIView *tempSegmentView=[[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 30)];
    UIImageView *imgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SegmentBg.png"]];
    [imgv setFrame:CGRectMake(0, 0, 320, 30)];
    [tempSegmentView addSubview:imgv];
    [imgv release];
    btnsArr=[[NSMutableArray alloc] init];
    int x=109;
    for (int i=0; i<[segmentArray count]; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(x, 4, 50, 23)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn setTitle:[segmentArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"SegmentBtn.png"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        if (i==0) {
            [btn setSelected:YES];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:100+i];
        [btnsArr addObject:btn];
        [tempSegmentView addSubview:btn];
        x+=52;
    }
    [self.view addSubview:tempSegmentView];
    [tempSegmentView release];

}
-(void)btnClick:(id)sender{
    for (UIButton *btn in btnsArr) {
        [btn setSelected:NO];
    }
    [(UIButton*)sender setSelected:YES];
    NSInteger sortIndex = [(UIButton*)sender tag]%100;
    ArticleListView* articleListView = [self.childViewControllers objectAtIndex:0];
    TipListView* tipListView = [self.childViewControllers objectAtIndex:1];
    if ((currentViewController == articleListView && sortIndex == 0)||(currentViewController == tipListView && sortIndex == 1)) {
        return;
    }
    UIViewController *oldViewController=currentViewController;
    switch (sortIndex) {
        case 1:{
            [self transitionFromViewController:currentViewController toViewController:tipListView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=tipListView;
                }else{
                    currentViewController=oldViewController;
                }
            }];
        }
            break;
            
        default:{
            [self transitionFromViewController:currentViewController toViewController:articleListView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=articleListView;
                }else{
                    currentViewController=oldViewController;
                }
            }];
            
        }
            break;
    }

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSegment];
    
    // Do any additional setup after loading the view from its nib.
    ArticleListView* articleListView = [[ArticleListView alloc] initWithNibName:@"ArticleListView" bundle:nil];
    [self addChildViewController:articleListView];
    [articleListView release];
    
    TipListView* tipListView = [[TipListView alloc] initWithNibName:@"TipListView" bundle:nil];
    [self addChildViewController:tipListView];
    [tipListView release];
    
    [self.contentView addSubview:articleListView.view];
    currentViewController = articleListView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.contentView = nil;
}

- (void)dealloc{
    [self.contentView release];
    [super dealloc];
    
}
@end
