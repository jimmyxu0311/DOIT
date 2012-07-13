//
//  MainViewController.m
//  DOIT
//
//  Created by AppDev on 12-2-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "HeadLineViewController.h"
#import "StoreViewController.h"
#import "ServerViewController.h"
#import "CloubViewController.h"
#import "SafetyViewController.h"
#import "NewsViewController.h"
#import "DOITUtil.h"
#import "ArticleService.h"
#import "SettingView.h"
#import "SQLite3_Manager.h"
#import "InformationSqlite.h"
#import "ArticleService.h"
#import "Article.h"
#import "GTMBase64.h"
#import "InformationDetailService.h"

@implementation MainViewController
@synthesize contentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//+ (UILabel *)labelWithFrame:(CGRect)frame title:(NSString*)title
//{
//    UILabel* label = [[[UILabel alloc] initWithFrame:frame] autorelease];
//    label.textAlignment = UITextAlignmentLeft;
//    label.text = title;
////    label.font = [UIFont boldSystemFontOfSize:17.0];
//    label.font = [UIFont fontWithName:@"Helvetica" size:17.0];
//    label.textColor = [UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0];
//    label.backgroundColor = [UIColor clearColor];
//    return label;
//}

-(void)createSegment
{
    NSArray* segmentArray = [NSArray arrayWithObjects:@"头条",@"云计算",@"硬件",@"软件",@"商用",@"渠道", nil];
    
    UIView *tempSegmentView=[[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 30)];
    UIImageView *imgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SegmentBg.png"]];
    [imgv setFrame:CGRectMake(0, 0, 320, 30)];
    [tempSegmentView addSubview:imgv];
    [imgv release];
    btnsArr=[[NSMutableArray alloc] init];
    int x=5;
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
    
    HeadLineViewController* headLineView = [self.childViewControllers objectAtIndex:0];
    StoreViewController* storeView = [self.childViewControllers objectAtIndex:1];
    ServerViewController* serverView = [self.childViewControllers objectAtIndex:2];
    CloubViewController* cloubView = [self.childViewControllers objectAtIndex:3];
    SafetyViewController* safetyView = [self.childViewControllers objectAtIndex:4];
    NewsViewController* newsView = [self.childViewControllers objectAtIndex:5];
    if ((currentViewController == headLineView && sortIndex==0)||(currentViewController == storeView && sortIndex == 1)||(currentViewController == serverView && sortIndex == 2)||(currentViewController == cloubView && sortIndex == 3)||(currentViewController == safetyView && sortIndex == 4)||(currentViewController == newsView && sortIndex == 5)) {
        return;
    }
        
    UIViewController *oldViewController=currentViewController;
    
    switch (sortIndex) {
        case 1:{
            [self transitionFromViewController:currentViewController toViewController:storeView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=storeView;
                }else{
                    currentViewController=oldViewController;
                }
            }];
        }
            break;
        case 2:{
            [self transitionFromViewController:currentViewController toViewController:serverView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=serverView;
                }else{
                    currentViewController=oldViewController;
                }
            }];
        }
            break;
        case 3:{
            [self transitionFromViewController:currentViewController toViewController:cloubView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=cloubView;
                }else{
                    currentViewController=oldViewController;
                }
            }];
        }
            break;
        case 4:{
            [self transitionFromViewController:currentViewController toViewController:safetyView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=safetyView;
                }else{
                    currentViewController=oldViewController;
                }
            }];
        }
            break;
        case 5:{
            [self transitionFromViewController:currentViewController toViewController:newsView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=newsView;
                }else{
                    currentViewController=oldViewController;
                }
            }];
        }
            break;
        default:{
            [self transitionFromViewController:currentViewController toViewController:headLineView duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController=headLineView;
                }else{
                    currentViewController=oldViewController;
                }
            }];
        }
            break;
    }

}

-(NSMutableArray*)fetchArticleArray{
    NSString* requestURL = [NSString stringWithFormat:@"%@article.show.list.do?actionType=ttfocus",[DOITUtil getUrlBase]];
    NSURL* url = [NSURL URLWithString:requestURL];
    return [ArticleService getArticleArray:url];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSegment];
    
    HeadLineViewController* headLineView = [[HeadLineViewController alloc] initWithNibName:@"HeadLineViewController" bundle:nil];
    headLineView.topArray = [self fetchArticleArray];
    [self addChildViewController:headLineView];
    [headLineView release];
    
    StoreViewController* storeView = [[StoreViewController alloc] initWithNibName:@"StoreViewController" bundle:nil];
    [self addChildViewController:storeView];
    [storeView release];
    
    ServerViewController* serverView = [[ServerViewController alloc] initWithNibName:@"ServerViewController" bundle:nil];
    [self addChildViewController:serverView];
    [serverView release];
    
    CloubViewController* cloubView = [[CloubViewController alloc] initWithNibName:@"CloubViewController" bundle:nil];
    [self addChildViewController:cloubView];
    [cloubView release];
    
    SafetyViewController* safetyView = [[SafetyViewController alloc] initWithNibName:@"SafetyViewController" bundle:nil];
    [self addChildViewController:safetyView];
    [safetyView release];
    
    NewsViewController* newsView = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
    [self addChildViewController:newsView];
    [newsView release];
    
    [contentView addSubview:headLineView.view];
    currentViewController = headLineView;
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame=CGRectMake(0, 0, 320, 44);
    [btnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    btninfo=[UIButton buttonWithType:UIButtonTypeInfoLight];
    btninfo.frame=CGRectMake(275, 7, 30, 30);
    btninfo.tag=101;
    [btninfo addTarget:self action:@selector(btninfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btninfo];
}

-(void)btninfoClick:(id)sender{
    if (((UIButton*)sender).tag==101) {
        [bgView removeFromSuperview];
        bgView=[[UIView alloc] initWithFrame:CGRectMake(170, 30, 140, 70)];
        [self.view addSubview:bgView];
        
        UIImageView *tempimg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"I_BG.png"]];
        tempimg.frame=CGRectMake(0, 0, 140, 70);
        [bgView addSubview:tempimg];
        
        UIButton *unOlineDownloadBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [unOlineDownloadBtn setImage:[UIImage imageNamed:@"Information_unlinedownload.png"] forState:UIControlStateNormal];
        unOlineDownloadBtn.frame=CGRectMake(4, 14, 66, 42);
        [unOlineDownloadBtn addTarget:self action:@selector(unOlineDownBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:unOlineDownloadBtn];
        
        UIButton *settingBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [settingBtn setImage:[UIImage imageNamed:@"Information_setting.png"] forState:UIControlStateNormal];
        settingBtn.frame=CGRectMake(70, 14, 67, 42);
        [settingBtn addTarget:self action:@selector(settingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:settingBtn];
        ((UIButton*)sender).tag=102;
    }
    else{
        ((UIButton*)sender).tag=101;
        [bgView removeFromSuperview];
    }
}

-(void)btnBackClick:(id)sender{
    [bgView removeFromSuperview];
}

-(void)downloadData:(UIView*)v{
    
    SQLite3_Manager *sqlm=[[SQLite3_Manager alloc] init];
    
    [sqlm deleteInformationCache];
    [sqlm deleteInformationDetail];
    [sqlm deleteInformationTop];
    
    NSArray* array = [[ArticleService getArticleArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=ttfocus",[DOITUtil getUrlBase]]]] retain];
    for (int i=0; i<[array count]; i++) {
        Article *art=[array objectAtIndex:i];
        
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:art.picture]];
        [sqlm insertInformationTop:art.articleID title:art.title summary:art.summary siteid:art.siteid pictrue:[GTMBase64 stringByEncodingData:data] articleType:art.articleType];
        
        InformationDetail *subArr=[InformationDetailService getArticleContentArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=content&id=%@&requestNum=1",[DOITUtil getUrlBase],art.articleID]]];
        [sqlm insertInformationDetail:subArr.commentNum summary:subArr.summary content:subArr.content pageSize:subArr.pageSize siteid:subArr.siteID url:subArr.url];
    }
    
    array = [[ArticleService getArticleArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=ttlist&requestNum=5&page=1",[DOITUtil getUrlBase]]]] retain];
    for (int i=0; i<[array count]; i++) {
        Article *art=[array objectAtIndex:i];
        
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:art.picture]];
        [sqlm insertInformationCache:art.articleID title:art.title summary:art.summary siteid:art.siteid pictrue:[GTMBase64 stringByEncodingData:data] articleType:art.articleType type:@"HeadLine"];
        
        InformationDetail *subArr=[InformationDetailService getArticleContentArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=content&id=%@&requestNum=1",[DOITUtil getUrlBase],art.articleID]]];
        [sqlm insertInformationDetail:subArr.commentNum summary:subArr.summary content:subArr.content pageSize:subArr.pageSize siteid:subArr.siteID url:subArr.url];
    }
    
    array = [[ArticleService getArticleArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=cloud&requestNum=10&page=1",[DOITUtil getUrlBase]]]] retain];
    for (int i=0; i<[array count]; i++) {
        Article *art=[array objectAtIndex:i];
        
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:art.picture]];
        
        [sqlm insertInformationCache:art.articleID title:art.title summary:art.summary siteid:art.siteid pictrue:[GTMBase64 stringByEncodingData:data] articleType:art.articleType type:@"Cloud"];
        
        InformationDetail *subArr=[InformationDetailService getArticleContentArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=content&id=%@&requestNum=1",[DOITUtil getUrlBase],art.articleID]]];
        [sqlm insertInformationDetail:subArr.commentNum summary:subArr.summary content:subArr.content pageSize:subArr.pageSize siteid:subArr.siteID url:subArr.url];
    }
    
    array = [[ArticleService getArticleArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=storage&requestNum=10&page=1",[DOITUtil getUrlBase]]]] retain];
    for (int i=0; i<[array count]; i++) {
        Article *art=[array objectAtIndex:i];
        
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:art.picture]];
        
        [sqlm insertInformationCache:art.articleID title:art.title summary:art.summary siteid:art.siteid pictrue:[GTMBase64 stringByEncodingData:data] articleType:art.articleType type:@"Storage"];
        
        InformationDetail *subArr=[InformationDetailService getArticleContentArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=content&id=%@&requestNum=1",[DOITUtil getUrlBase],art.articleID]]];
        [sqlm insertInformationDetail:subArr.commentNum summary:subArr.summary content:subArr.content pageSize:subArr.pageSize siteid:subArr.siteID url:subArr.url];
    }
    
    array = [[ArticleService getArticleArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=industry&requestNum=10&page=1",[DOITUtil getUrlBase]]]] retain];
    for (int i=0; i<[array count]; i++) {
        Article *art=[array objectAtIndex:i];
        
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:art.picture]];
        
        [sqlm insertInformationCache:art.articleID title:art.title summary:art.summary siteid:art.siteid pictrue:[GTMBase64 stringByEncodingData:data] articleType:art.articleType type:@"Industry"];
        
        InformationDetail *subArr=[InformationDetailService getArticleContentArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=content&id=%@&requestNum=1",[DOITUtil getUrlBase],art.articleID]]];
        [sqlm insertInformationDetail:subArr.commentNum summary:subArr.summary content:subArr.content pageSize:subArr.pageSize siteid:subArr.siteID url:subArr.url];
    }
    
    array = [[ArticleService getArticleArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=server&requestNum=10&page=1",[DOITUtil getUrlBase]]]] retain];
    for (int i=0; i<[array count]; i++) {
        Article *art=[array objectAtIndex:i];
        
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:art.picture]];
        
        [sqlm insertInformationCache:art.articleID title:art.title summary:art.summary siteid:art.siteid pictrue:[GTMBase64 stringByEncodingData:data] articleType:art.articleType type:@"Server"];
        
        InformationDetail *subArr=[InformationDetailService getArticleContentArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=content&id=%@&requestNum=1",[DOITUtil getUrlBase],art.articleID]]];
        [sqlm insertInformationDetail:subArr.commentNum summary:subArr.summary content:subArr.content pageSize:subArr.pageSize siteid:subArr.siteID url:subArr.url];
    }
    
    array = [[ArticleService getArticleArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=security&requestNum=10&page=1",[DOITUtil getUrlBase]]]] retain];
    for (int i=0; i<[array count]; i++) {
        Article *art=[array objectAtIndex:i];
        
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:art.picture]];
        
        [sqlm insertInformationCache:art.articleID title:art.title summary:art.summary siteid:art.siteid pictrue:[GTMBase64 stringByEncodingData:data] articleType:art.articleType type:@"Security"];
        InformationDetail *subArr=[InformationDetailService getArticleContentArray:[NSURL URLWithString:[NSString stringWithFormat:@"%@article.show.list.do?actionType=content&id=%@&requestNum=1",[DOITUtil getUrlBase],art.articleID]]];
        [sqlm insertInformationDetail:subArr.commentNum summary:subArr.summary content:subArr.content pageSize:subArr.pageSize siteid:subArr.siteID url:subArr.url];
        
    }
    [sqlm release];
    [v removeFromSuperview];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)unOlineDownBtnClick:(id)sender{
    btninfo.tag=101;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [bgView removeFromSuperview];
    UIView *tempV=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)] autorelease];
    [tempV setBackgroundColor:[UIColor blackColor]];
    [tempV setAlpha:0.8];
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [lbl setText:@"正在下载中..."];
    [lbl setFont:[UIFont fontWithName:@"ArialRoundedMTBold" size:15]];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [tempV addSubview:lbl];
    [lbl release];
    [self.view addSubview:tempV];
    [NSThread detachNewThreadSelector:@selector(downloadData:) toTarget:self withObject:tempV];

}

-(void)settingBtnClick:(id)sender{
    btninfo.tag=101;
    [bgView removeFromSuperview];
    SettingView* settingView = [[SettingView alloc] initWithNibName:@"SettingView" bundle:nil];
    [self.navigationController pushViewController:settingView animated:YES];
    [settingView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)dealloc{
    [btnsArr release];
    [self.contentView release];
    [super dealloc];

}

@end
