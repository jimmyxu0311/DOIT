//
//  CustomTabBarController.m
//  DOIT
//
//  Created by AppDev on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBarController.h"

@implementation CustomTabBarController

-(id)init{
    self = [super init];
    if (self) {
        /* self.navigationController.navigationBarHidden = YES;
         CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 49);
         UIView* view = [[UIView alloc] initWithFrame:frame];
         UIImage* tabBarBackgroundImage = [UIImage imageNamed:@"tabbarbackground.png"];
         UIColor* color = [[UIColor alloc] initWithPatternImage:tabBarBackgroundImage];
         [view setBackgroundColor:color];
         [color release];
         [[self tabBar] addSubview:view];
         self.tabBar.opaque = YES;
         [view release];*/
    }
    return self;
}

-(void)init_tab{
    select_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_btn_bg_s"]];
    tab_bar_bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBackground"]];
    tab_text = [[NSMutableArray alloc] initWithObjects:@"资讯",@"社区",@"收藏",@"更多", nil];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self init_tab];
    [self when_tabbar_is_unselected];
    [self add_custom_tabbar_elements];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self init_tab];
//    [self when_tabbar_is_unselected];
//    [self add_custom_tabbar_elements];
}

-(void)when_tabbar_is_unselected{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            view.hidden = YES;
            break;
        }
    }
}

-(void)add_custom_tabbar_elements{
    int tab_num = 4;
    int i;
    
    UIImageView* tabbar_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 430, 320, 50)];
    [tabbar_bg setImage:tab_bar_bg.image];
    [self.view addSubview:tabbar_bg];
    
    tab_btn = [[NSMutableArray alloc] initWithCapacity:0];
    for (i = 0; i < tab_num; i++) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(10+i*75, 430, 75, 50)];
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        [btn setBackgroundImage:select_image.image forState:UIControlStateSelected];
        [btn setTitle:[tab_text objectAtIndex:i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        if (i == 0) {
            [btn setSelected:YES];
        }
        [btn setTag:i];
        [tab_btn addObject:btn];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(button_clicked_tag:) forControlEvents:UIControlEventTouchUpInside];
        [btn release];
    }
}


-(void)button_clicked_tag:(id)sender{
    int tagNum = [sender tag];
    
    //NSLog(@"tag = %i",tagNum);
    
    [self when_tabbar_is_selected:tagNum];
}

-(void)when_tabbar_is_selected:(int)tabID{
    switch (tabID) {
        case 1:
            [[tab_btn objectAtIndex:0] setSelected:false];
            [[tab_btn objectAtIndex:1] setSelected:true];
            [[tab_btn objectAtIndex:2] setSelected:false];
            [[tab_btn objectAtIndex:3] setSelected:false];
            break;
        case 2:
            [[tab_btn objectAtIndex:0] setSelected:false];
            [[tab_btn objectAtIndex:1] setSelected:false];
            [[tab_btn objectAtIndex:2] setSelected:true];
            [[tab_btn objectAtIndex:3] setSelected:false];
            break;
        case 3:
            [[tab_btn objectAtIndex:0] setSelected:false];
            [[tab_btn objectAtIndex:1] setSelected:false];
            [[tab_btn objectAtIndex:2] setSelected:false];
            [[tab_btn objectAtIndex:3] setSelected:true];
            break;
        default:
            [[tab_btn objectAtIndex:0] setSelected:true];
            [[tab_btn objectAtIndex:1] setSelected:false];
            [[tab_btn objectAtIndex:2] setSelected:false];
            [[tab_btn objectAtIndex:3] setSelected:false];
            break;
       
    }
    self.selectedIndex = tabID;
}


-(void) dealloc{
    [select_image release];
    [tab_bar_bg release];
    [tab_text release];
    [tab_btn release];
    [super dealloc];
}




@end
