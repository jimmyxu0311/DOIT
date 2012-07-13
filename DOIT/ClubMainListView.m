//
//  ClubMainListView.m
//  DOIT
//
//  Created by AppDev on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ClubMainListView.h"
#import "AllTipListView.h"
#import "CreamTipListView.h"

@implementation ClubMainListView

@synthesize contentView;
@synthesize titleLabel;
@synthesize titleText;
@synthesize bkid;

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
    NSArray* segmentArray = [NSArray arrayWithObjects:@"全部",@"精华帖", nil];
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
    AllTipListView* allTipListView = [self.childViewControllers objectAtIndex:0];
    CreamTipListView* creamTipListView = [self.childViewControllers objectAtIndex:1];
    if ((currentViewController == allTipListView && sortIndex == 0) || (currentViewController == creamTipListView && sortIndex == 1)) {
        return;
    }
    
    UIViewController *oldViewController=currentViewController;
    
    switch (sortIndex) {
        case 1:{
            [self transitionFromViewController:currentViewController toViewController:creamTipListView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=creamTipListView;
                }else{
                    currentViewController=oldViewController;
                }
            }];
        }
            break;
        default:{
            [self transitionFromViewController:currentViewController toViewController:allTipListView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=allTipListView;
                }else{
                    currentViewController=oldViewController;
                }
            }];
        }
        break;
    }
}


-(IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createSegment];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = self.titleText;
    AllTipListView* allTipListView = [[AllTipListView alloc] initWithNibName:@"AllTipListView" bundle:nil];
    allTipListView.bkid = self.bkid;
    allTipListView.titleText = self.titleText;
    [self addChildViewController:allTipListView];
//    [allTipListView release];
    
    CreamTipListView* creamTipListView = [[CreamTipListView alloc] initWithNibName:@"CreamTipListView" bundle:nil];
    creamTipListView.bkid = self.bkid;
    creamTipListView.titleText = self.titleText;
    [self addChildViewController:creamTipListView];
//    [creamTipListView release];
    
    [contentView addSubview:allTipListView.view];
    currentViewController = allTipListView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.titleText = nil;
    self.bkid = nil;
}

- (void)dealloc{
    [self.contentView release];
    [self.titleLabel release];
    [super dealloc];
}

@end
