//
//  CustomTabBarController.h
//  DOIT
//
//  Created by AppDev on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarController : UITabBarController{
    //item的背景图片
   // UIImageView* background_image;
    //选中时的图片
    UIImageView* select_image;
    //背景图片
    UIImageView* tab_bar_bg;
    //button上的text
    NSMutableArray* tab_text;
    
    NSMutableArray* tab_btn;
    UIButton* btn;
}

-(void)init_tab;
-(void)when_tabbar_is_unselected;
-(void)add_custom_tabbar_elements;
-(void)when_tabbar_is_selected:(int)tabID;


@end
