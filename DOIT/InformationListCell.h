//
//  ImageTableViewCell.h
//  NSOperationTest
//
//  Created by jhwang on 11-10-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"


@interface InformationListCell : UITableViewCell{
    IBOutlet UILabel *title;
    IBOutlet UILabel *summary;
    IBOutlet UIImageView *imageView;
    NSMutableData *_data;
}
@property (nonatomic, retain)IBOutlet UILabel *title;
@property (nonatomic, retain)IBOutlet UIImageView *imageView;
@property (nonatomic, retain)IBOutlet UILabel *summary;
@property (nonatomic, retain) NSMutableData *data;

- (void)setCell:(UIImage *)image title:(NSString *)titleText summary:(NSString *)summaryText;

@end
