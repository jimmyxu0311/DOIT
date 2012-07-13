//
//  ArticleCell.h
//  DOIT
//
//  Created by AppDev on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleCell : UITableViewCell{
    IBOutlet UIImageView* imageView;
    IBOutlet UILabel* titleLabel;
    IBOutlet UILabel* summaryLabel;
    IBOutlet UIImageView* imgType;
}
@property(nonatomic,retain) IBOutlet UIImageView* imageView;
@property(nonatomic, retain) IBOutlet UILabel* titleLabel;
@property(nonatomic, retain) IBOutlet UILabel* summaryLabel;
@property(nonatomic, retain) IBOutlet UIImageView* imgType;


//-(void) setCell:(NSString *)title summary:(NSString *)summary imageURL:(NSString *)imageURL;
-(void) setCell:(NSString *)title summary:(NSString *)summary image:(UIImage *)image articletype:(int)articletype;

@end
